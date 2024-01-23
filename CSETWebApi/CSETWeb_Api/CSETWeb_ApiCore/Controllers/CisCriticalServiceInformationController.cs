//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class CisCriticalServiceInformationController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ICisDemographicBusiness _cisDemographicBusiness;
        private readonly IUserBusiness _user;
        private CSETContext _context;

        public CisCriticalServiceInformationController(ITokenManager token,
           INotificationBusiness notification, IAssessmentUtil assessmentUtil,
           ICisDemographicBusiness demographic, IUserBusiness user, CSETContext context)
        {
            _token = token;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _cisDemographicBusiness = demographic;
            _user = user;
            _context = context;
        }

        [HttpGet]
        [Route("api/cis/organizationDemographics")]
        public IActionResult GetOrganizationDemographics()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cisDemographicBusiness.GetOrgDemographics(assessmentId));
        }


        [HttpPost]
        [Route("api/cis/organizationDemographics")]
        public IActionResult SaveOrganizationDemographics([FromBody] CisOrganizationDemographics orgDemographics)
        {
            orgDemographics.AssessmentId = _token.AssessmentForUser();
            return Ok(_cisDemographicBusiness.SaveOrgDemographics(orgDemographics));
        }

        [HttpGet]
        [Route("api/cis/serviceDemographics")]
        public IActionResult GetServiceDemographics()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cisDemographicBusiness.GetServiceDemographics(assessmentId));
        }

        [HttpPost]
        [Route("api/cis/serviceDemographics")]
        public IActionResult SaveServiceDemographics([FromBody] CisServiceDemographics serviceDemographics)
        {
            serviceDemographics.AssessmentId = _token.AssessmentForUser();
            int userid = _token.GetUserId() ?? 0;
            return Ok(_cisDemographicBusiness.SaveServiceDemographics(serviceDemographics, userid));
        }

        [HttpGet]
        [Route("api/cis/serviceComposition")]
        public IActionResult GetServiceComposition()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_cisDemographicBusiness.GetServiceComposition(assessmentId));
        }

        [HttpPost]
        [Route("api/cis/serviceComposition")]
        public IActionResult SaveServiceComposition([FromBody] CisServiceComposition serviceComposition)
        {
            serviceComposition.AssessmentId = _token.AssessmentForUser();
            return Ok(_cisDemographicBusiness.SaveServiceComposition(serviceComposition));
        }

        [HttpGet]
        [Route("api/cis/staffCounts")]
        public IActionResult GetStaffCounts()
        {
            return Ok(_context.CIS_CSI_STAFF_COUNTS);
        }

        [HttpGet]
        [Route("api/cis/definingSystems")]
        public IActionResult GetDefiningSystems()
        {
            return Ok(_context.CIS_CSI_DEFINING_SYSTEMS);
        }

        [HttpGet]
        [Route("api/cis/customerCounts")]
        public IActionResult GetCustomerCounts()
        {
            return Ok(_context.CIS_CSI_CUSTOMER_COUNTS);
        }

        [HttpGet]
        [Route("api/cis/userCounts")]
        public IActionResult GetUserCounts()
        {
            return Ok(_context.CIS_CSI_USER_COUNTS);
        }

        [HttpGet]
        [Route("api/cis/budgetBases")]
        public IActionResult GetBudgetBases()
        {
            return Ok(_context.CIS_CSI_BUDGET_BASES);
        }
    }
}

