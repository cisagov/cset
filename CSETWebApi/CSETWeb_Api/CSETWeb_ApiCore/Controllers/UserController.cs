using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly IUserBusiness _userBusiness;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IConfiguration _configuration;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public UserController(CSETContext context,
            IUserBusiness userBusiness,
            INotificationBusiness notificationBusiness,
            IConfiguration configuration)
        {
            _context = context;
            _userBusiness = userBusiness;
            _notificationBusiness = notificationBusiness;
            _configuration = configuration;
        }


        /// <summary>
        /// Returns a collection of the USERS in the system.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/users")]
        public IActionResult GetUsers([FromQuery] string apiKey)
        {           
            if (!IsApiKeyGood(apiKey))
            {
                return Unauthorized();
            }

            // TODO:  build out the response to send the users back to the admin client
            var resp = new List<USERS>();

            return Ok(resp);
        }


        /// <summary>
        /// Flip the IsActive flag on a USER.  
        /// When the flag is flipped to TRUE, send the user a temp password.
        /// 
        /// Randy's note:  I wrote this as a GET to quickly get the parms
        /// into the method signature.  If we want to do it as a POST we can 
        /// refactor them into their own object.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/user/activate")]
        public IActionResult ChangeUserActivation(
            [FromQuery] int userId, [FromQuery] bool isActive, [FromQuery] string apiKey)
        {
            if (!IsApiKeyGood(apiKey))
            {
                return Unauthorized();
            }


            // set the active flag on the user
            var user = _context.USERS.FirstOrDefault(x => x.UserId == userId);
            if (user == null)
            {
                return BadRequest();
            }

            // user.IsActive = isActive;   Once EF has been updated with the new column ...
            _context.SaveChanges();



            // if the user is being activated, send them a new temp password
            if (isActive)
            {
                var resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);
                resetter.ResetPassword(user.PrimaryEmail, "Temporary Password", "CSET");
            }


            // TODO:  What sort of response should we send?
            return Ok();
        }


        /// <summary>
        /// Checks the specified API Key against the secret in the DB.
        /// </summary>
        /// <param name="apiKey"></param>
        /// <returns></returns>
        private bool IsApiKeyGood(string apiKey)
        {
            if (string.IsNullOrEmpty(apiKey))
            {
                return false;
            }

            var gp = new CSETGlobalProperties(_context);
            var secret = gp.GetProperty("UserApprovalApiKey");
            return (apiKey == secret);
        }
    }
}
