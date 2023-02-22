//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using System.Linq;
using CSETWebCore.Model.Cis;
using DocumentFormat.OpenXml.Wordprocessing;
using System.Collections.Generic;


namespace CSETWebCore.Api.Controllers
{
    public class MaturityC2M2Controller : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;

        /// <summary>
        /// 
        /// </summary>
        public MaturityC2M2Controller(
            CSETContext context,
            ITokenManager tokenManager,
            IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness,
            IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/maturitystructure/c2m2")]
        public IActionResult GetQuestions()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructure(assessmentId, true);

            var json = Helpers.CustomJsonWriter.Serialize(x.Root);
            return Ok(json);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/c2m2/donuts")]
        public IActionResult GetDonuts()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var xStructure = biz.GetMaturityStructureForModel(12, assessmentId);

            var response = new List<CSETWebCore.Model.C2M2.Domain>();

            foreach (Grouping domain in xStructure.Model.Groupings.Where(x => x.GroupType == "Domain"))
            {
                var d = new CSETWebCore.Model.C2M2.Domain()
                {
                    Title = domain.Title,
                    Description = domain.Description
                };

                response.Add(d);

                foreach (Grouping objective in domain.Groupings)
                {
                    var o = new CSETWebCore.Model.C2M2.Objective()
                    {
                        Title = objective.Title,
                        FI = objective.Questions.Count(x => x.AnswerText == "FI"),
                        LI = objective.Questions.Count(x => x.AnswerText == "LI"),
                        PI = objective.Questions.Count(x => x.AnswerText == "PI"),
                        NI = objective.Questions.Count(x => x.AnswerText == "NI"),
                        U  = objective.Questions.Count(x => x.AnswerText == "U")
                    };

                    d.Objectives.Add(o);
                }
            }

            return Ok(response);
        }
    }
}
