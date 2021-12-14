using Microsoft.AspNetCore.Mvc;
using System;
using CSETWebCore.Interfaces.Notification;

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
    }
}
