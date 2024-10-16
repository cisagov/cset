using CSETWebCore.Interfaces.Helpers;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using NLog;

namespace CSETWebCore.AutoResponder
{
    public class EmailHelper : IEmailHelper
    {
        private IConfiguration _configuration;
        private IResourceHelper _resourceHelper;


        public EmailHelper(IConfiguration configuration, IResourceHelper resourceHelper)
        {
            this._configuration = configuration;
            this._resourceHelper = resourceHelper;

        }


        /// <summary>
        /// 
        /// </summary>
        public void SendFollowUp(string email, string firstName, string lastName)
        {
            string templateFile = @"App_Data\assessmentFollowUpTemplate_CF.html";
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            string bodyHtml = _resourceHelper.GetEmbeddedResource(templateFile);
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _configuration.GetValue<string>("rootUrl"));

            MailMessage message = new MailMessage();
            message.Subject = "CSET Assessment Follow-up for Cybersecure Florida";
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));

            var configFromEmail = emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail");
            if (configFromEmail.Value == null)
            {
                // Don't send email because we don't have a "From:" address configured
                LogManager.GetCurrentClassLogger().Error("No configuration for Email:SenderEmail");
                return;
            }

            message.From = new MailAddress(configFromEmail.Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);

            message.IsBodyHtml = true;

            SendMail(message);
        }


        /// <summary>
        /// 
        /// </summary>
        public void SendWeekly(string attachmentPath, string email, string firstName, string lastName)
        {
            string templateFile = @"App_Data\weeklyTemplate_CF.html";
            var emailConfig = _configuration.GetSection("Email").AsEnumerable();
            string bodyHtml = _resourceHelper.GetEmbeddedResource(templateFile);
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", _configuration.GetValue<string>("rootUrl"));

            MailMessage message = new MailMessage();
            message.Subject = "New Weekly Contacts for Cybersecure Florida";
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));

            var configFromEmail = emailConfig.FirstOrDefault(x => x.Key == "Email:SenderEmail");
            if (configFromEmail.Value == null)
            {
                // Don't send email because we don't have a "From:" address configured
                LogManager.GetCurrentClassLogger().Error("No configuration for Email:SenderEmail");
                return;
            }

            message.From = new MailAddress(configFromEmail.Value,
                emailConfig.FirstOrDefault(x => x.Key == "Email:SenderDisplayName").Value);

            message.IsBodyHtml = true;
            message.Attachments.Add(new Attachment(attachmentPath));

            SendMail(message);
        }


        // <summary>
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

            string footerCF = _resourceHelper.GetEmbeddedResource(@"App_Data\EmailFooter_CF.html");
            mail.Body = mail.Body.Replace("{{email-footer-CF}}", footerCF);

            var configSmtpHost = emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpHost");

            // if no mail host defined, don't send the email
            if (configSmtpHost.Value == null)
            {
                LogManager.GetCurrentClassLogger().Error("No configuration for Email:SmtpHost");
                return;
            }


            SmtpClient client = new SmtpClient
            {
                DeliveryMethod = SmtpDeliveryMethod.Network,
                Host = configSmtpHost.Value,
                Port = int.Parse(emailConfig.FirstOrDefault(x => x.Key == "Email:SmtpPort").Value ?? "25"),
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
            try
            {
                client.Send(mail);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error("Most Likely Bad email was " + mail.To);
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                Console.Write(exc);
            }

        }
    }
}
