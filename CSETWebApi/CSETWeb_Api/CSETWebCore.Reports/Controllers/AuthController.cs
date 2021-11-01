using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Reports.Controllers
{
    public class AuthController : Controller
    {
        private CSETContext _context;

        public AuthController(CSETContext context)
        {
            _context = context;
        }

        [CsetAuthorize]
        [HttpPost]
        [Route("api/auth/SetSession")]
        public IActionResult SetSession()
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

            if (auth.IsTokenValid(tokenString))
            {
                HttpContext.Session.SetString("token", tokenString);
                return Ok();
            }

            return Unauthorized();

        }
    }
}
