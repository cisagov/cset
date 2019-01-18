using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Models;


namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Houses all API calls used by the StandardBuilder logic.
    /// </summary>
    public class StandardBuilderController : ApiController
    {
        /// <summary>
        /// Returns a list of 'stock' standards, plus any custom standards
        /// owned by the current user.  Stock standards are marked as non-editable,
        /// while custom standards are editable.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/builder/GetCustomSets")]
        public List<SetDetail> GetCustomSetsList()
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.GetCustomSetList();
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetSetDetail")]
        public SetDetail GetSetDetail([FromUri] string setName)
        {
            StandardBuilderManager m = new StandardBuilderManager();
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
            StandardBuilderManager m = new StandardBuilderManager();
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
            StandardBuilderManager m = new StandardBuilderManager();
            return m.CloneSet(setName);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetQuestionsForSet")]
        public QuestionListResponse GetQuestionsForSet([FromUri] string setName)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            QuestionListResponse response = m.GetQuestionsForSet(setName);

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

            StandardBuilderManager m = new StandardBuilderManager();
            return m.ExistsQuestionText(questionText);
        }


        /// <summary>
        /// Creates a new custom question from the supplied text.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddCustomQuestionToSet")]
        public void AddCustomQuestionToSet([FromBody] SetQuestion request)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.AddCustomQuestionToSet(request);
        }


        /// <summary>
        /// Adds a 'base' or 'stock' question to the Set.
        /// </summary>
        /// <param name="request"></param>
        [HttpPost]
        [Route("api/builder/AddQuestionToSet")]
        public void AddQuestionToSet([FromBody] SetQuestion request)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.AddQuestionToSet(request);
        }


        [HttpPost]
        [Route("api/builder/RemoveQuestionFromSet")]
        public void RemoveQuestionFromSet([FromBody] SetQuestion request)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.RemoveQuestionFromSet(request);
        }


        [HttpGet]
        [Route("api/builder/GetStandardCategories")]
        public List<CategoryEntry> GetStandardCategories()
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.GetStandardCategories();
        }


        [HttpGet]
        [Route("api/builder/GetCategoriesSubcategoriesGroupHeadings")]
        public CategoriesSubcategoriesGroupHeadings GetCategoriesSubcategoriesGroupHeadings()
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.GetCategoriesSubcategoriesGroupHeadings();
        }


        [HttpPost]
        [Route("api/builder/SearchQuestions")]
        public List<QuestionDetail> SearchQuestions([FromBody] QuestionSearch searchParms)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.SearchQuestions(searchParms);
        }


        [HttpPost]
        [Route("api/builder/SetSalLevel")]
        public void SetSalLevel([FromBody] SalParms parms)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.SetSalLevel(parms);
        }


        [HttpPost]
        [Route("api/builder/UpdateQuestionText")]
        public void UpdateQuestionText([FromBody] QuestionTextUpdateParms parms)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.UpdateQuestionText(parms.QuestionID, parms.QuestionText);
        }


        [HttpGet]
        [Route("api/builder/IsQuestionInUse")]
        public bool IsQuestionInUse([FromUri] int questionID)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.IsQuestionInUse(questionID);
        }


        [HttpPost]
        [Route("api/builder/UpdateHeadingText")]
        public void UpdateHeadingText([FromBody] HeadingUpdateParms parms)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            m.UpdateHeadingText(parms.PairID, parms.HeadingText);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/builder/GetStandardStructure")]
        public StandardsResponse GetStandardStructure([FromUri] string setName)
        {
            StandardBuilderManager m = new StandardBuilderManager();
            return m.GetStandardStructure(setName);
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
            StandardBuilderManager m = new StandardBuilderManager();
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
            StandardBuilderManager m = new StandardBuilderManager();
            return m.GetRequirement(setName, reqID);
        }
    }
}
