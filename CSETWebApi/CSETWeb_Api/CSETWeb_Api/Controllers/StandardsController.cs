//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Manages questions and their answers. 
    /// </summary>
    [CSETAuthorize]
    public class StandardsController : ApiController
    {
        /// <summary>
        /// Returns a list of all displayable cybersecurity standards.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/standards")]
        public StandardsResponse GetStandards()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new StandardsManager().GetStandards(assessmentId);
        }


        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpPost]
        [Route("api/standard")]
        public QuestionRequirementCounts PersistSelectedStandards(List<string> selectedStandards)
        {
            int assessmentId = Auth.AssessmentForUser();
            return new StandardsManager().PersistSelectedStandards(assessmentId, selectedStandards);
        }

        /// <summary>
        /// Set default standard for basic assessment
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/basicStandard")]
        public QuestionRequirementCounts PersistDefaultSelectedStandards()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new StandardsManager().PersistDefaultSelectedStandard(assessmentId);
        }

        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpGet]
        [Route("api/standard/IsFramework")]
        public bool GetFrameworkSelected()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new StandardsManager().GetFramework(assessmentId);
        }

        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpGet]
        [Route("api/standard/IsACET")]
        public bool GetACETSelected()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new StandardsManager().GetACET(assessmentId);
        }

        ///// <summary>
        ///// Returns the number of questions that are relevant for the selected standards.
        ///// 
        ///// This might not be called directly by the front end.  The manager
        ///// method might be called at the end of persisting the list of standards
        ///// to the API and included in the response.
        ///// </summary>
        ///// <returns></returns>
        //[HttpPost]
        //[Route("api/question/count")]
        //public int QuestionCountForSetNames([FromBody] List<string> setNames)
        //{
        //    int assessmentId = Auth.AssessmentForUser();
        //    return new StandardsManager().NumberOfQuestions(assessmentId, setNames);
        //}
    }
}


