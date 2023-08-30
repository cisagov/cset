//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers.ReportWidgets;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;
using System.Xml.Linq;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Helpers;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Common API intended to supply report content for EDM, CRR and IMR.
    /// </summary>
    public class ReportsCmuController : Controller
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;
        private readonly ICmuScoringHelper _scoring;


        public ReportsCmuController(ITokenManager token, IAssessmentBusiness assessment,
            IDemographicBusiness demographic, IReportsDataBusiness report,
            IAssessmentUtil assessmentUtil, IAdminTabBusiness admin, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = admin;
            _context = context;

            _scoring = new ICmuScoringHelper(context);
        }        
    }
}
