using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Reports.Controllers
{
    public class AuthController : Controller
    {
        private CSETContext _context;
        private readonly TokenManager _token;

        public AuthController(CSETContext context, TokenManager token)
        {
            _context = context;
            _token = token;
        }

        [CsetAuthorize]
        [HttpPost]
        [Route("api/auth/SetSession")]
        public async Task<IActionResult> SetSession()
        {
            var auth = new CsetAuthorize();
            var authHeader = HttpContext.Request.Headers["Authorization"];
            var tokenString = string.Empty;
            if (authHeader.Count == 0)
            {
                return Unauthorized();
            }

            var authHeaderValue = authHeader.ToString().Split(" ");
            if (authHeaderValue.Length == 2 && authHeaderValue[0].ToLower() == "bearer")
            {
                tokenString = authHeaderValue[1];
            }
            else
            {
                tokenString = authHeaderValue[0];
            }

            if (await _token.IsTokenValid(tokenString))
            {
                await _token.Init(tokenString);
                var assessmentId = _token.GetAssessmentId();
                HttpContext.Session.SetString("assessmentId", assessmentId.ToString());
                return Ok();
            }

            return Unauthorized();

        }
    }
}
