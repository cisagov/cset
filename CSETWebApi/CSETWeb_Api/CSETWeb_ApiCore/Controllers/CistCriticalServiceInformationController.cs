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
        public IActionResult GetOrganizationDemograpics() 
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetOrgDemographics(assessmentId));
        }

        [HttpGet]
        [Route("api/cist/serviceDemographics")]
        public IActionResult GetServiceDemograpics()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetServiceDemographics(assessmentId));
        }

        [HttpGet]
        [Route("api/cist/serviceComposition")]
        public IActionResult GetServiceComposition()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cistDemographicBusiness.GetServiceComposition(assessmentId));
        }
    }
}
