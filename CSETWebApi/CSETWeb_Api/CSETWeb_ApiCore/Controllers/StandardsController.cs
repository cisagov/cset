//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using CSETWebCore.Model.Standards;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Standards;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using Microsoft.AspNetCore.Authorization;
using CSETWebCore.DataLayer;
using CSETWebCore.Business.Acet;
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    public class StandardsController : ControllerBase
    {
        private readonly IUserAuthentication _userAuthentication;
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;
        private IQuestionRequirementManager _questionRequirement;
        private IDemographicBusiness _demographicBusiness;


        public StandardsController(IUserAuthentication userAuthentication, ITokenManager tokenManager, CSETContext context,
             IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports, IQuestionRequirementManager questionRequirement,
            IDemographicBusiness demographicBusiness)
        {
            _userAuthentication = userAuthentication;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
            _questionRequirement = questionRequirement;
            _demographicBusiness = demographicBusiness;
        }


        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpGet]
        [Route("api/standard/IsACET")]
        public bool GetACETSelected()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return new StandardsBusiness(_context, _assessmentUtil, _questionRequirement, _tokenManager, _demographicBusiness).GetACET(assessmentId);
        }
    }
}
