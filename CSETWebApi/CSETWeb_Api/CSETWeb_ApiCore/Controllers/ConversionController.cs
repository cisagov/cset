//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;


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
