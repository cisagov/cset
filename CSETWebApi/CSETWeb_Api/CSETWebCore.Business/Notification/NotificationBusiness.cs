using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Model.Contact;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Notification
{
    public class NotificationBusiness : INotificationBusiness
    {
        private readonly IConfiguration _configuration;
        private readonly ITokenManager _tokenManager;
        private readonly IUtilities _utilities;
        private readonly IResourceHelper _resourceHelper;
        private CSETContext _context;
        private string _scope;
        private Dictionary<string, string> _appDisplayName = new Dictionary<string, string>();

        public NotificationBusiness(IConfiguration configuration, ITokenManager tokenManager, IUtilities utilities,
            CSETContext context, IResourceHelper resourceHelper)
        {
            _configuration = configuration;
            _tokenManager = tokenManager;
            _utilities = utilities;
            _context = context;
            _resourceHelper = resourceHelper;

            Initialize();
        }

        public void SetAppCode()
        {
            _scope = _tokenManager.Payload("scope");
        }

        public void SetAppCode(string appCode)
        {
            _scope = appCode;
        }

        //public string GetConfiguration()
        //{
        //    return _configuration.GetSection("SMTP Port").Value;
        //}

        /// <summary>
        /// Performs initialization common to any instantiation.
        /// </summary>
        public void Initialize()
        {
            // Populate the app display names.
            this._appDisplayName.Add("CSET", "CSET");
            this._appDisplayName.Add("ACET", "ACET");
        }

        /// <summary>
        /// Sends an email to the recipient inviting them an Assessment.
        /// The content for this email is not defined by a template on the back end because the 
        /// user might have customized the subject and/or body in the browser.
        /// 
        /// See class level note (top of the file)
        /// </summary>
        public void InviteToAssessment(ContactCreateParameters contact)
        {
            SetAppCode();

            string bodyHtml = _resourceHelper.GetEmbeddedResource(@"App_Data\assessmentInviteTemplate_" + this._scope + ".html");
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            // Build the name if supplied.  
            string contactName = string.Empty;
            if (!string.IsNullOrEmpty(contact.FirstName) || !string.IsNullOrEmpty(contact.FirstName))
            {
                contactName = (contact.FirstName + " " + contact.LastName).Trim() + ",";
            }

            bodyHtml = bodyHtml.Replace("{{name}}", contactName);
            bodyHtml = bodyHtml.Replace("{{subject}}", contact.Subject);
            bodyHtml = bodyHtml.Replace("{{body}}", contact.Body.Replace("\r\n", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>"));
            bodyHtml = bodyHtml.Replace("{{id}}", contact.AssessmentId.ToString());
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = contact.Subject;
            message.Body = bodyHtml;
            message.IsBodyHtml = true;
            message.To.Add(new MailAddress(contact.PrimaryEmail));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Email").Value,
            emailConfig.FirstOrDefault(x=>x.Key== "Email:Sender Display Name").Value);
            SendMail(message);
        }


        /// <summary>
        /// Sends an email to the recipient containing their temporary password.
        /// See class level note (top of the file)
        /// </summary>
        /// <param name="email"></param>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="password"></param>
        public void SendPasswordEmail(string email, string firstName, string lastName, string password, string appCode)
        {
            string bodyHtml = _resourceHelper.GetEmbeddedResource(@"App_Data\passwordCreationTemplate_" + appCode + ".html");
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = "New " + _appDisplayName[appCode] + " account creation";
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Email").Value,
            emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Display Name").Value);

            message.IsBodyHtml = true;

            SendMail(message);
        }


        /// <summary>
        /// Sends an email to the invitee containing their temporary password.
        /// See class level note (top of the file)
        /// </summary>
        /// <param name="email"></param>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="password"></param>
        public void SendInviteePassword(string email, string firstName, string lastName, string password, string appCode)
        {
            string templateFile = @"App_Data\invitedPasswordCreationTemplate_" + appCode + ".html";
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            string bodyHtml = _resourceHelper.GetEmbeddedResource(templateFile);
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = "You are invited to " + _appDisplayName[appCode];
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Email").Value,
            emailConfig.FirstOrDefault(x => x.Key == "Email:Sender Display Name").Value);

            message.IsBodyHtml = true;

            SendMail(message);
        }


        /// <summary>
        /// Sends an email to the recipient containing their newly-reset password.
        /// See class level note (top of the file)
        /// </summary>
        /// <param name="email"></param>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <param name="password"></param>
        /// <param name="subject"></param>
        public void SendPasswordResetEmail(string email, string firstName, string lastName, string password, string subject, string appCode)
        {
            string bodyHtml = _resourceHelper.GetEmbeddedResource(@"App_Data\passwordResetTemplate_" + appCode + ".html");
            string name = (firstName + " " + lastName).Trim();
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            if (string.IsNullOrEmpty(name)) name = email;

            bodyHtml = bodyHtml.Replace("{{name}}", name);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = subject;
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
                emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Email").Value,
                emailConfig.FirstOrDefault(x=>x.Key == "Email:Sender Display Name").Value);

            message.IsBodyHtml = true;

            SendMail(message);
        }


        /// <summary>
        /// Sends a MailMessage using the configured SmtpClient.
        /// See class level note (top of the file)
        /// </summary>
        /// <param name="mail">MailMessage mail = new MailMessage("you@yourcompany.com", "user@hotmail.com");</param>
        public void SendMail(MailMessage mail)
        {
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            // apply stylesheet
            string inlineStylesheet = _resourceHelper.GetEmbeddedResource(@"App_Data\inlineStylesheet.html");
            mail.Body = mail.Body.Replace("{{inline-stylesheet}}", inlineStylesheet);

            // apply corresponding footer
            string footer = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter.html");
            mail.Body = mail.Body.Replace("{{email-footer}}", footer);
            string footerACET = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter_ACET.html");
            mail.Body = mail.Body.Replace("{{email-footer-ACET}}", footerACET);


            SmtpClient client = new SmtpClient
            {
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Host = emailConfig.FirstOrDefault(x=>x.Key == "Email:SMTP Host").Value,
                Port = int.Parse(emailConfig.FirstOrDefault(x=>x.Key == "Email:SMTP Port").Value),
                UseDefaultCredentials = false
            };

            bool.TryParse(emailConfig.FirstOrDefault(x=>x.Key == "Email:SMTP SSL").Value, out bool ssl);
            client.EnableSsl = ssl;

            var smtpUsername = emailConfig.FirstOrDefault(x => x.Key == "Email:SMTP Username").Value;
            var smtpPassword = emailConfig.FirstOrDefault(x => x.Key == "Email:SMTP Password").Value;
            if (smtpUsername != null)
            {
                client.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
            }

            Task.Run(() =>
            {
                try
                {
                    client.Send(mail);
                }
                catch (Exception)
                {
                    //CsetLogManager.Instance.LogErrorMessage("Exception thrown in NotificationManager.SendMail(): {0}", exc.ToString());
                    // throw exc;
                }
            });
        }


        /// <summary>
        /// Sends a test email.
        /// </summary>
        public void SendTestEmail(string recip)
        {
            SetAppCode();

            // only send the email if configured to do so (unpublished app setting)
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            bool allowed = false;
            string allowSetting = emailConfig.FirstOrDefault(x => x.Key == "Email:Allow Test Email").Value;
            if (allowSetting == null || !bool.TryParse(allowSetting, out allowed))
            {
                if (!allowed)
                {
                    throw new Exception("Not configured to send test emails");
                }
            }

            MailMessage m = new MailMessage();
            m.Subject = _appDisplayName[_scope] + " Test Message";
            m.Body = string.Format("Testing email server {0} on port {1}",
                emailConfig.FirstOrDefault(x => x.Key == "Email:SMTP Host").Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SMTP Port").Value);
            m.To.Add(new MailAddress(recip));
            m.From = new MailAddress(
                emailConfig.FirstOrDefault(x => x.Key == "Email:Sender Email").Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:Sender Display Name").Value);
            this.SendMail(m);
        }

    }
}