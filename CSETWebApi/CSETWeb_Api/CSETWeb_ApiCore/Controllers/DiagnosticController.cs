//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using CSETWebCore.Interfaces.Notification;
using NLog;
using CSETWebCore.DataLayer.Model;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class DiagnosticController : ControllerBase
    {
        private readonly INotificationBusiness _notification;
        private readonly CSETContext _context;

        public DiagnosticController(INotificationBusiness notification, CSETContext context)
        {
            _notification = notification;
            _context = context;
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

        [HttpGet]
        [Route("api/version")]
        public IActionResult GetCsetVersion()
        {
            try
            {
                var dbVersion = _context.CSET_VERSION.FirstOrDefault();
                return Ok(dbVersion);
            }
            catch (Exception exc)
            {
                var logToDb = LogManager.GetCurrentClassLogger();
                logToDb.Error(exc.ToString());
                return Ok(exc.ToString());
            }
        }
    }
}
