//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using CSETWebCore.Interfaces.Notification;
using NLog;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DiagnosticController : ControllerBase
    {
        private readonly INotificationBusiness _notification;

        public DiagnosticController(INotificationBusiness notification)
        {
            _notification = notification;
        }
        /// <summary>
        /// Tests connectivity to the SMTP server and sends 
        /// a test email to the designated recipient.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/diagnostic/email")]
        public string TestEmailServer(string recip)
        {
            try
            {
                _notification.SendTestEmail(recip);
            }
            catch (Exception Exc)
            {
                return Exc.Message;
            }

            return "Test email sent successfully";
        }


        /// <summary>
        /// Test logging configuration by echoing supplied text
        /// to the two logging targets.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/diagnostic/logging")]
        public IActionResult TestLogging([FromQuery] string text)
        {
            var logToDb = LogManager.GetCurrentClassLogger();
            logToDb.Info(text);

            var logToFile = LogManager.GetLogger("DBManager");
            logToFile.Info(text);

            return Ok();
        }
    }
}
