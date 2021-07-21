using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using CSETWebCore.Authorization;
using CSETWebCore.CryptoBuffer;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Module;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class ProtectedFeatureController : ControllerBase
    {
        private CSETContext _context;

        public ProtectedFeatureController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("api/EnableProtectedFeature/Features/")]
        public IActionResult getFeatures()
        {

            return Ok(from a in _context.SETS.Where(x => x.IsEncryptedModule == true && x.IsEncryptedModuleOpen == true)
                    select new EnabledModule() { Short_Name = a.Short_Name, Full_Name = a.Full_Name });

        }

        [HttpPost]
        [Route("api/EnableProtectedFeature/unlockFeature/")]
        public IActionResult unlockFeature([FromBody] String unlock)
        {
            try
            {

                ColumnSetEncryption columnencryptor = new ColumnSetEncryption(unlock, "451f0b54b51f");
                var list = _context.NEW_QUESTION.Where(x => x.Original_Set_Name == "FAA");


                //* This fi.simple_questions check is looking to see if the question is encrypted or not
                //* encrypted questions are base64 encoded where a space is not a valid character 
                //* so if we find a space then the question is not encrypted if we do not find a space 
                //* then the question must be in base64 encoding and therefor is encrypted

                var fi = list.FirstOrDefault();
                if (fi == null)
                    return BadRequest("");

                if (fi.Simple_Question.Contains(" "))
                {
                    AddNewlyEnabledModule();
                    return BadRequest("This module is already enabled");
                }

                foreach (NEW_QUESTION q in list)
                {
                    if (!q.Simple_Question.Contains(" "))
                        q.Simple_Question = columnencryptor.Decrypt(q.Simple_Question);
                }
                var rlist = _context.NEW_REQUIREMENT.Where(x => x.Original_Set_Name == "FAA").OrderBy(x => x.Requirement_Id);
                foreach (NEW_REQUIREMENT r in rlist)
                {
                    if (!r.Requirement_Text.Contains(" "))
                        r.Requirement_Text = columnencryptor.Decrypt(r.Requirement_Text);
                    if (!r.Supplemental_Info.Contains(" "))
                        r.Supplemental_Info = columnencryptor.Decrypt(r.Supplemental_Info);
                }
                AddNewlyEnabledModule();
                _context.SaveChanges();

                return Ok("FAA PED Questionnaire has been enabled.");

            }
            catch (Exception)
            {
                return BadRequest("Sorry that unlock code was not recognized check the code and try again");
            }

        }

        private void AddNewlyEnabledModule()
        {
            var sets2 = _context.SETS.Where(x => x.Set_Name == "FAA");
            foreach (SETS sts in sets2)
            {
                sts.IsEncryptedModuleOpen = true;
            }
            _context.SaveChanges();
        }
    }
}
