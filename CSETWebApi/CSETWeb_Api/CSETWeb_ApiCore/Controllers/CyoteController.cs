//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using Newtonsoft.Json;
using CSETWebCore.Business.CyOTE;
using CSETWebCore.Model.CyOTE;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    public class CyoteController : Controller
    {
        private readonly IUserAuthentication _userAuthentication;
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;

        public CyoteController(IUserAuthentication userAuthentication, ITokenManager tokenManager, CSETContext context,
             IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports,
             ICrrScoringHelper crr)
        {
            _userAuthentication = userAuthentication;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// Persists an Observable.  This can be a new or existing.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/cyote/observable")]
        public IActionResult StoreObservable([FromBody] Observable o)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var b = new CyoteBusiness(_context, _assessmentUtil, _adminTabBusiness);
            b.SaveCyoteObservable(o);
            return Ok();
        }


        /// <summary>
        /// Persists the observables in the order that the user chose.
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/cyote/sequence")]
        public IActionResult StoreSequence([FromBody] List<Observable> list)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var b = new CyoteBusiness(_context, _assessmentUtil, _adminTabBusiness);

            foreach (var o in list)
            {
                b.SaveCyoteObservable(o);
            }
            return Ok();
        }


        /// <summary>
        /// Returns the CyOTE-specific assessment detail,
        /// e.g., the observable/anomaly details.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cyote/detail")]
        public IActionResult GetCyoteAssessmentDetail()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var b = new CyoteBusiness(_context, _assessmentUtil, _adminTabBusiness);
            return Ok(b.GetCyoteAssessmentDetail(assessmentId));
        }
    }
}
