using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.User;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class CistCriticalServiceInformationController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ICistDemographicBusiness _cistDemographicBusiness;
        private readonly IUserBusiness _user;
        private CSETContext _context;

        public CistCriticalServiceInformationController(ITokenManager token,
           INotificationBusiness notification, IAssessmentUtil assessmentUtil, 
           ICistDemographicBusiness demographic, IUserBusiness user, CSETContext context)
        {
            _token = token;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _cistDemographicBusiness = demographic;
            _user = user;
            _context = context;
        }

        [HttpGet]
        [Route("api/cist/organizationDemographics")]
        public IActionResult GetOrganizationDemographics() 
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetOrgDemographics(assessmentId));
        }


        [HttpPost]
        [Route("api/cist/organizationDemographics")]
        public IActionResult SaveOrganizationDemographics([FromBody] CistOrganizationDemographics orgDemographics)
        {
            orgDemographics.AssessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.SaveOrgDemographics(orgDemographics));
        }

        [HttpGet]
        [Route("api/cist/serviceDemographics")]
        public IActionResult GetServiceDemographics()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetServiceDemographics(assessmentId));
        }

        [HttpPost]
        [Route("api/cist/serviceDemographics")]
        public IActionResult SaveServiceDemographics([FromBody] CistServiceDemographics serviceDemographics)
        {
            serviceDemographics.AssessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.SaveServiceDemographics(serviceDemographics));
        }

        [HttpGet]
        [Route("api/cist/serviceComposition")]
        public IActionResult GetServiceComposition()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetServiceComposition(assessmentId));
        }

        [HttpPost]
        [Route("api/cist/serviceComposition")]
        public IActionResult SaveServiceComposition([FromBody] CistServiceComposition serviceComposition)
        {
            serviceComposition.AssessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.SaveServiceComposition(serviceComposition));
        }

        [HttpGet]
        [Route("api/cist/staffCounts")]
        public IActionResult GetStaffCounts()
        {
            return Ok(_context.CIST_CSI_STAFF_COUNTS);
        }

        [HttpGet]
        [Route("api/cist/definingSystems")]
        public IActionResult GetDefiningSystems()
        {
            return Ok(_context.CIST_CSI_DEFINING_SYSTEMS);
        }

        [HttpGet]
        [Route("api/cist/customerCounts")]
        public IActionResult GetCustomerCounts()
        {
            return Ok(_context.CIST_CSI_CUSTOMER_COUNTS);
        }

        [HttpGet]
        [Route("api/cist/userCounts")]
        public IActionResult GetUserCounts()
        {
            return Ok(_context.CIST_CSI_USER_COUNTS);
        }

        [HttpGet]
        [Route("api/cist/budgetBases")]
        public IActionResult GetBudgetBases()
        {
            return Ok(_context.CIST_CSI_BUDGET_BASES);
        }
    }
}

