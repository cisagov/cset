//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Contact;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Authentication;
using DocumentFormat.OpenXml.Office2010.ExcelAc;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;


namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Manages conversion of assessment type(s) for an assessment.  
    /// </summary>
    [ApiController]
    public class ConversionController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ITokenManager _tokenManager;
        static readonly NLog.Logger _logger = NLog.LogManager.GetCurrentClassLogger();


        /// <summary>
        /// Constructor.
        /// </summary>
        public ConversionController(CSETContext context, ITokenManager tokenManager, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _tokenManager = tokenManager;
            _assessmentUtil = assessmentUtil;
        }
    }
}
