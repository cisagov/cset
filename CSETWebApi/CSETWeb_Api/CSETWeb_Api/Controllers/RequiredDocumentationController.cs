//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Manages ASET Required Documentation for assessments.
    /// </summary>
    [CSETAuthorize]
    public class RequiredDocumentationController : ApiController
    {
        /// <summary>
        /// Returns a list of all available documentation.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reqddocs")]
        public RequiredDocumentationResponse GetRequiredDocumentsList()
        {
            int assessmentId = Auth.AssessmentForUser();
            return (new RequiredDocumentationManager()).GetRequiredDocuments(assessmentId);
        }

        /// <summary>
        /// Persists the selected required docs value to the database.
        /// </summary>
        [HttpPost]
        [Route("api/required")]
        public void PersistSelectedRequiredDocuments(RequiredDocument reqDoc)
        {
            // In case nothing is sent, bail out gracefully
            if (reqDoc == null)
            {
                return;
            }

            int assessmentId = Auth.AssessmentForUser();
            new RequiredDocumentationManager().PersistSelectedRequiredDocuments(assessmentId, reqDoc);
        }
    }
}