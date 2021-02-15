//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
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
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessManagers;
using BusinessLogic.Helpers;
using DataLayerCore.Model;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Manages assessments.
    /// </summary>
    [CSETAuthorize]
    public class AssessmentController : ApiController
    {
        /// <summary>
        /// Creates a new Assessment with the current user as the first contact
        /// in an admin role.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/createassessment")]
        public AssessmentDetail CreateAssessment(bool mode)
        {   
            // Get the current userid to set as the Assessment creator and first attached user
            int currentUserId = Auth.GetUserId();

            AssessmentManager man = new AssessmentManager();
            return man.CreateNewAssessment(currentUserId, mode);            
        }


        /// <summary>
        /// Returns an array of Assessments connected to the current user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentsforuser")]
        public IEnumerable<Assessments_For_User> GetMyAssessments()
        {
            // get all Assessments that the current user is associated with
            AssessmentManager assessmentManager = new AssessmentManager();
            return assessmentManager.GetAssessmentsForUser(TransactionSecurity.CurrentUserId);
        }


        /// <summary>
        /// Returns the AssessmentDetail for current Assessment defined in the security token.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentdetail")]
        public AssessmentDetail Get()
        {
            // Get the AssessmentId from the token
            int assessmentId = Auth.AssessmentForUser();

            AssessmentManager assessmentManager = new AssessmentManager();
            return assessmentManager.GetAssessmentDetail(assessmentId);
        }


        /// <summary>
        /// Persists the posted AssessmentDetail.
        /// </summary>
        /// <param name="assessmentDetail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/assessmentdetail")]
        public int Post([FromBody]AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = Auth.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new CSETApplicationException("Not currently authorized to update the Assessment", null);
            }

            AssessmentManager assessmentManager = new AssessmentManager();
            return assessmentManager.SaveAssessmentDetail(assessmentId, assessmentDetail);
        }


        /// <summary>
        /// Returns a collection of all documents attached to any question in the Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentdocuments")]
        public object GetDocumentsForAssessment()
        {
            int assessmentId = Auth.AssessmentForUser();

            DocumentManager dm = new DocumentManager(assessmentId);
            return dm.GetDocumentsForAssessment(assessmentId);
        }
    }
}


