using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.CF;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CFController : ControllerBase
    {
        public CSETContext _context;

        private readonly ITokenManager _token;
        private ICFBusiness _business;

        public CFController(CSETContext context, ITokenManager token, ICFBusiness business)
        {
            _context = context;
            _token = token;
            _business = business;
        }

        [HttpGet]        
        public async Task<IActionResult> GetRedirectURL()
        {
            int assessmentId = _token.AssessmentForUser();
            var userId = _token.GetCurrentUserId()??0;
            var url = await _business.callBull(assessmentId,userId);
            return Ok(new { url });
        }
      

    }
}
