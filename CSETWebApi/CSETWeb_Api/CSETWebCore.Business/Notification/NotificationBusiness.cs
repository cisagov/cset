//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Model.Contact;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;
using HtmlAgilityPack;
using System.IO;


namespace CSETWebCore.Business.Notification
{
    public class NotificationBusiness : INotificationBusiness
    {
        private readonly IConfiguration _configuration;
        private readonly ITokenManager _tokenManager;
        private readonly IUtilities _utilities;
        private readonly IResourceHelper _resourceHelper;
        private readonly ILocalInstallationHelper _localInstallationHelper;
        private CSETContext _context;
        private string _scope;
        private Dictionary<string, string> _appDisplayName = new Dictionary<string, string>();

        public NotificationBusiness(IConfiguration configuration, ITokenManager tokenManager, IUtilities utilities,
            CSETContext context, IResourceHelper resourceHelper, ILocalInstallationHelper localInstallationHelper)
        {
            _configuration = configuration;
            _tokenManager = tokenManager;
            _utilities = utilities;
            _context = context;
            _resourceHelper = resourceHelper;
            _localInstallationHelper = localInstallationHelper;

            Initialize();
        }

        public void SetScope()
        {
            _scope = _tokenManager.Payload("scope");
            if (_scope == null)
            {
                _scope = "CSET";
            }
        }

        public void SetScope(string scope)
        {
            _scope = scope;
        }


        /// <summary>
        /// Performs initialization common to any instantiation.
        /// </summary>
        public void Initialize()
        {
            // Populate the app display names.
            this._appDisplayName.Add("CSET", "CSET");
            this._appDisplayName.Add("ACET", "ACET");
            this._appDisplayName.Add("TSA", "CSET-TSA");
            this._appDisplayName.Add("RRA", "RRA");
            this._appDisplayName.Add("CF", "Cyber Florida");
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
            SetScope();

            string bodyHtml = _resourceHelper.GetEmbeddedResource(Path.Combine("App_Data", @"assessmentInviteTemplate_{{scope}}.html"), this._scope);
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            // Build the name if supplied.  
            string contactName = String.Empty;
            if (!string.IsNullOrEmpty(contact.FirstName) || !string.IsNullOrEmpty(contact.FirstName))
            {
                contactName = (contact.FirstName + " " + contact.LastName).Trim() + ",";
            }

            if (contact.Body == null)
            {
                contact.Body = String.Empty;
            }

            bodyHtml = bodyHtml.Replace("{{name}}", contactName);
            bodyHtml = bodyHtml.Replace("{{subject}}", contact.Subject);
            bodyHtml = bodyHtml.Replace("{{body}}", contact.Body.Replace("\r\n", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>"));
            bodyHtml = bodyHtml.Replace("{{id}}", contact.AssessmentId.ToString());
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            // remove the link to CSET if running locally
            if (_localInstallationHelper.IsLocalInstallation())
            {
                RemoveCsetAppLink(ref bodyHtml);
            }


            MailMessage message = new MailMessage();
            message.Subject = "You've been invited to a CSET assessment";
            message.Body = bodyHtml;
            message.IsBodyHtml = true;
            message.To.Add(new MailAddress(contact.PrimaryEmail));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail").Value,
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);
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
        public void SendPasswordEmail(string email, string firstName, string lastName, string password, string appName)
        {
            string bodyHtml = _resourceHelper.GetEmbeddedResource(Path.Combine("App_Data", @"passwordCreationTemplate_{{scope}}.html"), appName);
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            // remove the link to CSET if running locally
            if (_localInstallationHelper.IsLocalInstallation())
            {
                RemoveCsetAppLink(ref bodyHtml);
            }


            MailMessage message = new MailMessage();
            message.Subject = "New " + _appDisplayName[appName] + " account creation";
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail").Value,
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);

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
        public void SendInviteePassword(string email, string firstName, string lastName, string password, string appName)
        {
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            string bodyHtml = _resourceHelper.GetEmbeddedResource(Path.Combine("App_Data", @"invitedPasswordCreationTemplate_{{scope}}.html"), appName);
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            // remove the link to CSET if running locally
            if (_localInstallationHelper.IsLocalInstallation())
            {
                RemoveCsetAppLink(ref bodyHtml);
            }


            MailMessage message = new MailMessage();
            message.Subject = "You are invited to " + _appDisplayName[appName];
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail").Value,
            emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);

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
        public void SendPasswordResetEmail(string email, string firstName, string lastName, string password, string subject, string appName)
        {
            SetScope(appName);
            string bodyHtml = _resourceHelper.GetEmbeddedResource(Path.Combine("App_Data", @"passwordResetTemplate_{{scope}}.html"), appName);
            string name = (firstName + " " + lastName).Trim();
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            if (string.IsNullOrEmpty(name)) name = email;

            bodyHtml = bodyHtml.Replace("{{name}}", name);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _utilities.GetClientHost());

            // remove the link to CSET if running locally
            if (_localInstallationHelper.IsLocalInstallation())
            {
                RemoveCsetAppLink(ref bodyHtml);
            }


            MailMessage message = new MailMessage();
            message.Subject = subject;
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail").Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);

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

            string footerACET = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter_ACET.html");
            mail.Body = mail.Body.Replace("{{email-footer-ACET}}", footerACET);

            string footerTSA = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter_TSA.html");
            mail.Body = mail.Body.Replace("{{email-footer-TSA}}", footerTSA);

            string footerCF = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter_CF.html");
            mail.Body = mail.Body.Replace("{{email-footer-CF}}", footerCF);

            string footer = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter.html");
            mail.Body = mail.Body.Replace("{{email-footer}}", footer);

            SmtpClient client = new SmtpClient
            {
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Host = emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpHost").Value,
                Port = int.Parse(emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpPort").Value),
                UseDefaultCredentials = false
            };

            bool.TryParse(emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpSsl").Value, out bool ssl);
            client.EnableSsl = ssl;

            var smtpUsername = emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpUsername").Value;
            var smtpPassword = emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpPassword").Value;
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
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                }
            });
        }


        /// <summary>
        /// Sends a test email.
        /// </summary>
        public void SendTestEmail(string recip)
        {
            SetScope();

            // only send the email if configured to do so (unpublished app setting)
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            bool allowed = false;
            string allowSetting = emailConfig.FirstOrDefault(x => x.Key == "Email:AllowTestEmail").Value;
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
                emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpHost").Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpPort").Value);
            m.To.Add(new MailAddress(recip));
            m.From = new MailAddress(
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail").Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);
            this.SendMail(m);
        }


        /// <summary>
        /// Removes the link to the CSET application from the email HTML.
        /// </summary>
        /// <param name="html"></param>
        /// <returns></returns>
        private void RemoveCsetAppLink(ref string html)
        {
            var doc = new HtmlDocument();
            doc.LoadHtml(html);

            var appLinks = doc.DocumentNode.SelectNodes("//*[contains(@class, 'cset-app-link')]");
            if (appLinks != null)
            {
                foreach (var link in appLinks)
                {
                    link.ParentNode.RemoveChild(link);
                }
            }

            html = doc.DocumentNode.OuterHtml;
        }
    }
}