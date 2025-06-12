//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Grouping;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using System;
using CSETWebCore.Model.Maturity;


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
        public IActionResult XXX([FromBody] GGG x)
        {
            int assessmentId = _token.AssessmentForUser();
            var lang = _token.GetCurrentLanguage();



            var biz = new GroupingBusiness(x, _context);
            biz.Persist();

            return Ok();
        }
    }
}
