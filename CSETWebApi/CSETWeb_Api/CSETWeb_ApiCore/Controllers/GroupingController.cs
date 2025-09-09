//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Grouping;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
using Microsoft.AspNetCore.Mvc;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class GroupingController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly CSETContext _context;
        private readonly Hooks _hooks;


        /// <summary>
        /// CTOR
        /// </summary>
        public GroupingController(ITokenManager token, CSETContext context, Hooks hooks)
        {
            _token = token;
            _context = context;
            _hooks = hooks;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/groupselections")]
        public IActionResult GetSelections()
        {
            int assessmentId = _token.AssessmentForUser();

            var biz = new GroupingBusiness(assessmentId, _context);

            return Ok(biz.GetSelections());
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/groupselection")]
        public IActionResult ChangeSelection([FromBody] GroupSelectionRequest request)
        {
            int assessmentId = _token.AssessmentForUser();

            var biz = new GroupingBusiness(assessmentId, _context);
            biz.PersistSelections(request);

            _hooks.HookGroupingSelectionChanged(assessmentId);

            return Ok();
        }
    }
}
