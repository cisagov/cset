using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Helpers.upload;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Houses all API calls used by the ModuleBuilder logic.
    /// </summary>
    public class ModuleBuilderController : ApiController
    {
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
        public List<SetDetail> GetCustomSetsList()
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetCustomSetList();
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetSetDetail")]
        public SetDetail GetSetDetail([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetSetDetail(setName);
        }


        /// <summary>
        /// Saves the set information and returns the setname (key) of the record.
        /// </summary>
        /// <param name="setDetail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/UpdateSetDetail")]
        public string UpdateSetDetail([FromBody]SetDetail setDetail)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.SaveSetDetail(setDetail);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/CloneSet")]
        public SetDetail CloneSet([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.CloneSet(setName);
        }

        /// <summary>
        /// 
        /// </summary>
        [HttpPost]
        [Route("api/builder/DeleteSet")]
        public BasicResponse DeleteSet([FromBody] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.DeleteSet(setName);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetQuestionsForSet")]
        public QuestionListResponse GetQuestionsForSet([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            QuestionListResponse response = m.GetQuestionsForSet(setName);

            return response;
        }


        /// <summary>
        /// Returns a list of questions whose 'original_set_name' is the one specified.
        /// This is used to know which questions will be affected if a set is 
        /// deleted.
        /// </summary>
        /// <param name="setName"></param>
        [HttpGet]
        [Route("api/builder/GetQuestionsOriginatingFromSet")]
        public List<int> GetQuestionsOriginatingFromSet([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            List<int> response = m.GetQuestionsOriginatingFromSet(setName);

            return response;
        }


        [HttpPost]
        [Route("api/builder/ExistsQuestionText")]
        public bool ExistsQuestionText([FromBody] string questionText)
        {
            // Don't let null be added as question text
            if (questionText == null)
            {
                return true;
            }

            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.ExistsQuestionText(questionText);
        }


        /// <summary>
        /// Creates a new custom question from the supplied text.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddCustomQuestion")]
        public void AddCustomQuestion([FromBody] SetQuestion request)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.AddCustomQuestion(request);
        }


        /// <summary>
        /// Adds 'base' or 'stock' questions to the Requirement or Set.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddQuestions")]
        public void AddQuestion([FromBody] AddQuestionsRequest request)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            foreach (QuestionAdd add in request.QuestionList)
            {
                SetQuestion r = new SetQuestion
                {
                    SetName = request.SetName,
                    RequirementID = request.RequirementID,
                    QuestionID = add.QuestionID,
                    SalLevels = add.SalLevels
                };
                m.AddQuestion(r);
            }
        }


        [HttpPost]
        [Route("api/builder/RemoveQuestion")]
        public void RemoveQuestion([FromBody] SetQuestion request)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.RemoveQuestion(request);
        }


        [HttpGet]
        [Route("api/builder/GetStandardCategories")]
        public List<CategoryEntry> GetStandardCategories()
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetStandardCategories();
        }


        [HttpGet]
        [Route("api/builder/GetCategoriesSubcategoriesGroupHeadings")]
        public CategoriesSubcategoriesGroupHeadings GetCategoriesSubcategoriesGroupHeadings()
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetCategoriesSubcategoriesGroupHeadings();
        }


        [HttpPost]
        [Route("api/builder/SearchQuestions")]
        public List<QuestionDetail> SearchQuestions([FromBody] QuestionSearch searchParms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.SearchQuestions(searchParms);
        }


        [HttpPost]
        [Route("api/builder/SetSalLevel")]
        public void SetSalLevel([FromBody] SalParms parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.SetSalLevel(parms);
        }


        [HttpPost]
        [Route("api/builder/UpdateQuestionText")]
        public BasicResponse UpdateQuestionText([FromBody] QuestionTextUpdateParms parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.UpdateQuestionText(parms.QuestionID, parms.QuestionText);
        }


        [HttpGet]
        [Route("api/builder/IsQuestionInUse")]
        public bool IsQuestionInUse([FromUri] int questionID)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.IsQuestionInUse(questionID);
        }


        [HttpPost]
        [Route("api/builder/UpdateHeadingText")]
        public void UpdateHeadingText([FromBody] HeadingUpdateParms parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.UpdateHeadingText(parms.PairID, parms.HeadingText);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetStandardStructure")]
        public ModuleResponse GetStandardStructure([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetModuleStructure(setName);
        }


        /// <summary>
        /// Creates a new Requirement.  Returns the ID.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/CreateRequirement")]
        public Requirement CreateRequirement([FromBody] Requirement parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.CreateRequirement(parms);
        }


        /// <summary>
        /// Returns the Requirement for the setname and requirement ID.
        /// </summary>
        /// <param name="setName"></param>
        /// <param name="reqID"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetRequirement")]
        public Requirement GetRequirement([FromUri] string setName, [FromUri] int reqID)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetRequirement(setName, reqID);
        }

        /// <summary>
        /// Updates an existing Requirement.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/UpdateRequirement")]
        public Requirement UpdateRequirement([FromBody] Requirement parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.UpdateRequirement(parms);
        }

        /// <summary>
        /// Removes an existing Requirement from the Set.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/builder/RemoveRequirement")]
        public void RemoveRequirement([FromBody] Requirement parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.RemoveRequirement(parms);
        }


        /// <summary>
        /// Returns a list of reference docs attached to the set after applying the filter.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocs")]
        public List<ReferenceDoc> GetReferenceDocs([FromUri] string setName, [FromUri] string filter)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetReferenceDocs(setName, filter);
        }


        /// <summary>
        /// Returns the list of reference docs attached to the set.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocsForSet")]
        public List<ReferenceDoc> GetReferenceDocs([FromUri] string setName)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetReferenceDocsForSet(setName);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetReferenceDocDetail")]
        public ReferenceDoc GetReferenceDocDetail([FromUri] int id)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.GetReferenceDocDetail(id);
        }


        [HttpPost]
        [Route("api/builder/UpdateReferenceDocDetail")]
        public void UpdateReferenceDocDetail([FromBody] ReferenceDoc doc)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.UpdateReferenceDocDetail(doc);
        }


        /// <summary>
        /// Refreshes the list of GEN_FILEs associated with a SET.
        /// The entire list of applicable files must be sent.
        /// </summary>
        /// <param name="parms"></param>
        [HttpPost]
        [Route("api/builder/SelectSetFile")]
        public void SelectSetFiles(SetFileSelection parms)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            m.SelectSetFile(parms);
        }


        /// <summary>
        /// Adds or deletes the source or resource doc/bookmark from the requirement.
        /// The 'isSourceRef' argument specifies whether the document is a 'source' document.
        /// The 'add' argument specifies whether the document is being added or removed from the requirement.
        /// </summary>
        [HttpGet]
        [Route("api/builder/AddDeleteRefDocToRequirement")]
        public ReferenceDocLists AddDeleteRefDocToRequirement([FromUri] int reqId, [FromUri] int docId, bool isSourceRef, [FromUri] string bookmark, [FromUri] bool add)
        {
            ModuleBuilderManager m = new ModuleBuilderManager();
            return m.AddDeleteRefDocToRequirement(reqId, docId, isSourceRef, bookmark, add);
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

                FileUploadStreamResult streamResult = await fileUploader.ProcessUploadStream(this.Request,formValues);

                        // Create a GEN_FILE entry, and a SET_FILES entry.
                        ModuleBuilderManager m = new ModuleBuilderManager();
                return m.RecordDocInDB(streamResult);
                
            }
            catch (System.Exception e)
            {
                throw e;
                // throw Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);
            }
        }
    }
}
