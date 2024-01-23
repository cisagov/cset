//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.ModuleBuilder;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Set;
using CSETWebCore.Helpers;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ModuleBuilderController : ControllerBase
    {
        private readonly IModuleBuilderBusiness _module;

        public ModuleBuilderController(IModuleBuilderBusiness module)
        {
            _module = module;
        }

        /// <summary>
        /// Returns a list of custom modules.
        /// 
        /// In the future, we may want to return all modules to allow the user
        /// to clone a 'stock' module.  Currently we cannot prevent the user
        /// from overwriting stock requirements or questions, so that functionality
        /// is turned off.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetCustomSets")]
        public IActionResult GetCustomSetsList()
        {
            return Ok(_module.GetCustomSetList());
        }


        [HttpGet]
        [Route("api/builder/GetAllSets")]
        public IActionResult GetAllSetsList()
        {
            return Ok(_module.GetCustomSetList(true));
        }


        [HttpGet]
        [Route("api/builder/GetSetsInUse")]
        public IActionResult GetSetsInUseList()
        {
            return Ok(_module.GetSetsInUseList());
        }


        [HttpGet]
        [Route("api/builder/GetNonCustomSets")]
        public IActionResult GetNonCustomSetList(string setName)
        {
            return Ok(_module.GetNonCustomSetList(setName));
        }

        [HttpPost]
        [Route("api/builder/SetBaseSets")]
        public IActionResult SetBaseSets(string setName, string[] setNames)
        {
            if (String.IsNullOrWhiteSpace(setName))
                return Ok();

            _module.SetBaseSets(setName, setNames);
            return Ok();
        }

        [HttpGet]
        [Route("api/builder/GetBaseSets")]
        public IActionResult GetBaseSets(string setName)
        {
            return Ok(_module.GetBaseSets(setName));
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetSetDetail")]
        public IActionResult GetSetDetail(string setName)
        {
            return Ok(_module.GetSetDetail(setName));
        }


        /// <summary>
        /// Saves the set information and returns the setname (key) of the record.
        /// </summary>
        /// <param name="setDetail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/UpdateSetDetail")]
        public IActionResult UpdateSetDetail([FromBody] SetDetail setDetail)
        {
            return Ok(new { SetName = _module.SaveSetDetail(setDetail) });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/CloneSet")]
        public IActionResult CloneSet(string setName)
        {
            return Ok(_module.CloneSet(setName));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/CopyBaseToCustom")]
        public IActionResult CopyBaseToCustom(string SourceSetName, string DestinationSetName)
        {
            _module.AddCopyToSet(SourceSetName, DestinationSetName);
            return Ok();
        }

        [HttpGet]
        [Route("api/builder/BaseToCustomDelete")]
        public IActionResult BaseToCustomDelete(string setName)
        {
            _module.DeleteCopyToSet(setName);
            return Ok();
        }

        /// <summary>
        /// 
        /// </summary>
        [HttpPost]
        [Route("api/builder/DeleteSet")]
        public IActionResult DeleteSet([FromBody] string setName)
        {
            return Ok(_module.DeleteSet(setName));
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetQuestionsForSet")]
        public IActionResult GetQuestionsForSet(string setName)
        {
            QuestionListResponse response = _module.GetQuestionsForSet(setName);

            return Ok(response);
        }


        /// <summary>
        /// Returns a list of questions whose 'original_set_name' is the one specified,
        /// but are also being used in other sets.
        /// </summary>
        /// <param name="setName"></param>
        [HttpGet]
        [Route("api/builder/GetMyQuestionsUsedByOtherSets")]
        public IActionResult GetMyQuestionsUsedByOtherSets(string setName)
        {
            List<int> response = _module.GetMyQuestionsUsedByOtherSets(setName);

            return Ok(response);
        }


        [HttpPost]
        [Route("api/builder/ExistsQuestionText")]
        public IActionResult ExistsQuestionText([FromBody] string questionText)
        {
            // Don't let null be added as question text
            if (questionText == null)
            {
                return Ok(true);
            }

            return Ok(_module.ExistsQuestionText(questionText));
        }


        /// <summary>
        /// Creates a new custom question from the supplied text.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddCustomQuestion")]
        public IActionResult AddCustomQuestion([FromBody] SetQuestion request)
        {
            _module.AddCustomQuestion(request);
            return Ok();
        }


        /// <summary>
        /// Adds 'base' or 'stock' questions to the Requirement or Set.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddQuestions")]
        public IActionResult AddQuestion([FromBody] AddQuestionsRequest request)
        {
            foreach (QuestionAdd add in request.QuestionList)
            {
                SetQuestion r = new SetQuestion
                {
                    SetName = request.SetName,
                    RequirementID = request.RequirementID,
                    QuestionID = add.QuestionID,
                    SalLevels = add.SalLevels
                };
                _module.AddQuestion(r);
            }

            return Ok();
        }


        [HttpPost]
        [Route("api/builder/RemoveQuestion")]
        public IActionResult RemoveQuestion([FromBody] SetQuestion request)
        {
            _module.RemoveQuestion(request);
            return Ok();
        }


        [HttpGet]
        [Route("api/builder/GetStandardCategories")]
        public IActionResult GetStandardCategories()
        {
            return Ok(_module.GetStandardCategories());
        }


        [HttpGet]
        [Route("api/builder/GetCategoriesSubcategoriesGroupHeadings")]
        public IActionResult GetCategoriesSubcategoriesGroupHeadings()
        {
            return Ok(_module.GetCategoriesSubcategoriesGroupHeadings());
        }


        [HttpPost]
        [Route("api/builder/SearchQuestions")]
        public IActionResult SearchQuestions([FromBody] QuestionSearch searchParms)
        {
            return Ok(_module.SearchQuestions(searchParms));
        }


        [HttpPost]
        [Route("api/builder/SetSalLevel")]
        public IActionResult SetSalLevel([FromBody] SalParms parms)
        {
            _module.SetSalLevel(parms);
            return Ok();
        }


        [HttpPost]
        [Route("api/builder/UpdateQuestionText")]
        public IActionResult UpdateQuestionText([FromBody] QuestionTextUpdateParms parms)
        {
            return Ok(_module.UpdateQuestionText(parms.QuestionID, parms.QuestionText));
        }


        [HttpGet]
        [Route("api/builder/IsQuestionInUse")]
        public IActionResult IsQuestionInUse(int questionID)
        {
            return Ok(_module.IsQuestionInUse(questionID));
        }


        [HttpPost]
        [Route("api/builder/UpdateHeadingText")]
        public IActionResult UpdateHeadingText([FromBody] HeadingUpdateParms parms)
        {
            _module.UpdateHeadingText(parms.PairID, parms.HeadingText);
            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetStandardStructure")]
        public IActionResult GetStandardStructure(string setName)
        {
            return Ok(_module.GetModuleStructure(setName));
        }


        /// <summary>
        /// Creates a new Requirement.  Returns the ID.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/CreateRequirement")]
        public IActionResult CreateRequirement([FromBody] Requirement parms)
        {
            return Ok(_module.CreateRequirement(parms));
        }


        /// <summary>
        /// Returns the Requirement for the setname and requirement ID.
        /// </summary>
        /// <param name="setName"></param>
        /// <param name="reqID"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetRequirement")]
        public IActionResult GetRequirement(string setName, int reqID)
        {
            return Ok(_module.GetRequirement(setName, reqID));
        }

        /// <summary>
        /// Updates an existing Requirement.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/UpdateRequirement")]
        public IActionResult UpdateRequirement([FromBody] Requirement parms)
        {
            return Ok(_module.UpdateRequirement(parms));
        }

        /// <summary>
        /// Removes an existing Requirement from the Set.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/RemoveRequirement")]
        public IActionResult RemoveRequirement([FromBody] Requirement parms)
        {
            _module.RemoveRequirement(parms);
            return Ok();
        }


        /// <summary>
        /// Returns a list of reference docs attached to the set after applying the filter.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocs")]
        public IActionResult GetReferenceDocs(string setName, string filter)
        {
            return Ok(_module.GetReferenceDocs(setName, filter));
        }


        /// <summary>
        /// Returns the list of reference docs attached to the set.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocsForSet")]
        public IActionResult GetReferenceDocs(string setName)
        {
            return Ok(_module.GetReferenceDocsForSet(setName));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocDetail")]
        public IActionResult GetReferenceDocDetail(int id)
        {
            return Ok(_module.GetReferenceDocDetail(id));
        }


        [HttpPost]
        [Route("api/builder/UpdateReferenceDocDetail")]
        public IActionResult UpdateReferenceDocDetail([FromBody] ReferenceDoc doc)
        {
            _module.UpdateReferenceDocDetail(doc);
            return Ok();
        }


        /// <summary>
        /// Refreshes the list of GEN_FILEs associated with a SET.
        /// The entire list of applicable files must be sent.
        /// </summary>
        /// <param name="parms"></param>
        [HttpPost]
        [Route("api/builder/SelectSetFile")]
        public IActionResult SelectSetFiles(SetFileSelection parms)
        {
            _module.SelectSetFile(parms);
            return Ok();
        }


        /// <summary>
        /// Adds or deletes the source or resource doc/bookmark from the requirement.
        /// The 'isSourceRef' argument specifies whether the document is a 'source' document.
        /// The 'add' argument specifies whether the document is being added or removed from the requirement.
        /// </summary>
        [HttpGet]
        [Route("api/builder/AddDeleteRefDocToRequirement")]
        public IActionResult AddDeleteRefDocToRequirement(int reqId, int docId, bool isSourceRef, string bookmark, bool add)
        {
            return Ok(_module.AddDeleteRefDocToRequirement(reqId, docId, isSourceRef, bookmark, add));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/UploadReferenceDoc")]
        public async Task<int> UploadReferenceDoc()
        {
            try
            {
                FileUploadStream fileUploader = new FileUploadStream();
                Dictionary<string, string> formValues = new Dictionary<string, string>();
                formValues.Add("title", null);
                formValues.Add("setName", null);

                FileUploadStreamResult streamResult = await fileUploader.ProcessUploadStream(HttpContext.Request.HttpContext, formValues);

                // Create a GEN_FILE entry, and a SET_FILES entry.
                return _module.RecordDocInDB(streamResult);

            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
            }
        }
    }
}
