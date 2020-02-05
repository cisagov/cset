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
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Manages Cybersecurity Framework Tier answers.
    /// </summary>
    [CSETAuthorize]
    public class FrameworkController : ApiController
    {
        /// <summary>
        /// Returns a list of all displayable cybersecurity framework tiers.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/frameworks")]
        public FrameworkResponse GetFrameworks()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new FrameworkManager().GetFrameworks(assessmentId);
        }


        /// <summary>
        /// Persists the selected tier value to the database.
        /// </summary>
        [HttpPost]
        [Route("api/framework")]
        public void PersistSelectedTierAnswer(TierSelection tier)
        {
            // In case nothing is sent, bail out gracefully
            if (tier == null)
            {
                return;
            }

            int assessmentId = Auth.AssessmentForUser();
            new FrameworkManager().PersistSelectedTierAnswer(assessmentId, tier);
        }
    }
}


