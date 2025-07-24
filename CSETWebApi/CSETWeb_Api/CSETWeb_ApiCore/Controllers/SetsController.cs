//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.ModuleIO;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Business.GalleryParser;
using Microsoft.Extensions.Logging;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class SetsController : ControllerBase
    {
        private CSETContext _context;
        private readonly IGalleryEditor _galleryEditor;
        private readonly ILogger<SetsController> _logger;

        public SetsController(CSETContext context, IGalleryEditor galleryEditor, ILogger<SetsController> logger)
        {
            _context = context;
            _galleryEditor = galleryEditor;
            _logger = logger;
        }

        [HttpGet]
        [Route("api/sets")]
        public IActionResult GetAllSets()
        {
            var sets = _context.SETS.Where(s => s.Is_Displayed)
                .Select(s => new { Name = s.Full_Name, SetName = s.Set_Name })
                .OrderBy(s => s.Name)
                .ToArray();
            return Ok(sets);
        }


        /// <summary>
        /// Import new standards into CSET
        /// </summary>
        [HttpPost]
        [Route("api/sets/import")]
        public IActionResult Import([FromBody] ExternalStandard externalStandard)
        {
            try
            {
                // Validate input model
                if (!ModelState.IsValid)
                {
                    _logger.LogWarning("Module import failed due to validation errors: {ValidationErrors}", 
                        string.Join(", ", ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage)));
                    
                    return ValidationProblem(ModelState);
                }

                // Validate required database dependencies
                var validationResults = ValidateImportDependencies(externalStandard);
                if (validationResults.Any())
                {
                    foreach (var error in validationResults)
                    {
                        ModelState.AddModelError(error.Key, error.Value);
                    }
                    
                    return ValidationProblem(ModelState);
                }

                // Check for existing module
                var existingModule = CheckForExistingModule(externalStandard.shortName);
                if (existingModule != null)
                {
                    return Conflict(ProblemDetailsFactory.CreateProblemDetails(HttpContext,
                        statusCode: 409,
                        title: "Module Already Exists",
                        detail: $"A module with short name '{externalStandard.shortName}' already exists. Please use a different short name or update the existing module.",
                        instance: HttpContext.Request.Path));
                }

                // Process the import
                var mp = new ModuleImporter(_context, _galleryEditor);
                mp.ProcessStandard(externalStandard);

                _logger.LogInformation("Successfully imported module: {ModuleName}", externalStandard.shortName);
                return Ok(new { message = "Module imported successfully", moduleName = externalStandard.shortName });
            }
            catch (InvalidOperationException ex)
            {
                _logger.LogError(ex, "Invalid operation during module import: {ModuleName}", externalStandard?.shortName);
                
                return BadRequest(ProblemDetailsFactory.CreateProblemDetails(HttpContext,
                    statusCode: 400,
                    title: "Invalid Import Operation",
                    detail: ex.Message,
                    instance: HttpContext.Request.Path));
            }
            catch (ArgumentException ex)
            {
                _logger.LogError(ex, "Invalid argument during module import: {ModuleName}", externalStandard?.shortName);
                
                return BadRequest(ProblemDetailsFactory.CreateProblemDetails(HttpContext,
                    statusCode: 400,
                    title: "Invalid Import Data", 
                    detail: ex.Message,
                    instance: HttpContext.Request.Path));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unexpected error during module import: {ModuleName}", externalStandard?.shortName);
                
                return Problem(
                    statusCode: 500,
                    title: "Import Failed",
                    detail: "An unexpected error occurred during module import. Please check the server logs for details.",
                    instance: HttpContext.Request.Path);
            }
        }

        private Dictionary<string, string> ValidateImportDependencies(ExternalStandard externalStandard)
        {
            var errors = new Dictionary<string, string>();

            // Validate category exists
            var category = _context.SETS_CATEGORY
                .FirstOrDefault(s => s.Set_Category_Name.Trim().ToLower() == externalStandard.category.Trim().ToLower());
            
            if (category == null)
            {
                errors.Add("category", $"Category '{externalStandard.category}' does not exist. Please use a valid category name.");
            }

            // Validate Custom gallery group exists
            var customGalleryGroup = _context.GALLERY_GROUP
                .FirstOrDefault(x => x.Group_Title.Equals("Custom"));
            
            if (customGalleryGroup == null)
            {
                errors.Add("galleryGroup", "Required 'Custom' gallery group is missing from the database. Please contact the system administrator.");
            }

            // Validate requirements have valid headings if present
            if (externalStandard.requirements != null && externalStandard.requirements.Any())
            {
                var invalidHeadings = new List<string>();
                foreach (var req in externalStandard.requirements)
                {
                    if (!string.IsNullOrWhiteSpace(req.heading))
                    {
                        var questionGroupHeading = _context.QUESTION_GROUP_HEADING
                            .FirstOrDefault(s => s.Question_Group_Heading1.Trim().ToLower() == req.heading.Trim().ToLower());
                        
                        if (questionGroupHeading == null && !invalidHeadings.Contains(req.heading))
                        {
                            invalidHeadings.Add(req.heading);
                        }
                    }
                }

                if (invalidHeadings.Any())
                {
                    errors.Add("requirements.headings", 
                        $"Invalid question group headings found: {string.Join(", ", invalidHeadings)}. Please use valid headings or contact the system administrator.");
                }
            }

            return errors;
        }

        private SETS CheckForExistingModule(string shortName)
        {
            if (string.IsNullOrWhiteSpace(shortName))
                return null;

            var setName = System.Text.RegularExpressions.Regex.Replace(shortName, @"\W", "_");
            return _context.SETS.FirstOrDefault(s => s.Set_Name == setName);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/sets/export/{setName}")]
        public IActionResult Export(string setName)
        {
            var set = _context.SETS
                .Include(s => s.Set_Category)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement)
                        .ThenInclude(rf => rf.REQUIREMENT_REFERENCES)
                            .ThenInclude(gf => gf.Gen_File)
                .Include(s => s.REQUIREMENT_SETS)
                    .ThenInclude(r => r.Requirement)
                        .ThenInclude(r => r.REQUIREMENT_LEVELS)
                .Where(s => (s.Is_Displayed) && s.Set_Name == setName).FirstOrDefault();

            if (set == null)
            {
                BadRequest($"A Set named '{setName}' was not found.");
            }

            return Ok(set.ToExternalStandard(_context));
        }
    }
}
