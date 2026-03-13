//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Diagnostic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Notification;
using Microsoft.AspNetCore.Mvc;
using NLog;
using System;


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
            catch (Exception exc)
            {
                return exc.Message;
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

            return Ok($"Complete at {DateTime.UtcNow} UTC");
        }


        /// <summary>
        /// This endpoint is useful when preparing for release.  It looks
        /// for data that needs to be addressed or deleted, like temporary
        /// sets, custom sets, stranded requirements, temporary requirements, etc.
        /// It requires a valid token to invoke.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/diagnostic/data/audit")]
        [CsetAuthorize]
        public IActionResult AuditData([FromQuery] string text)
        {
            try
            {
                var audit = new DatabaseAuditor(_context);
                var result = audit.Run();
                return Ok(result);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
            }
        }
    }
}
