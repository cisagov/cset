//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Grouping;
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


        /// <summary>
        /// CTOR
        /// </summary>
        public GroupingController(ITokenManager token, CSETContext context)
        {
            _token = token;
            _context = context;
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
            var lang = _token.GetCurrentLanguage();

            var biz = new GroupingBusiness(assessmentId, request, _context);
            biz.PersistSelection();

            return Ok();
        }
    }
}
