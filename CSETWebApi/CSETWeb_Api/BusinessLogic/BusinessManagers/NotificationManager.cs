//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Web;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;

namespace CSETWeb_Api.BusinessLogic
{
    /// <summary>
    /// Manages all email notifications.
    /// NOTE IMPORTANT YOU MUST SET THE CONFIGURATION MANAGER 
    /// before calling this class.
    /// 
    /// See the Global.asax.cs file for the implementation currently.
    /// </summary>
    public class NotificationManager
    {
        /// <summary>
        /// The client application that is in use.
        /// </summary>
        private string Scope;

        /// <summary>
        /// Display names for supported client applications, keyed by code/scope.
        /// </summary>
        private Dictionary<string, string> appDisplayName = new Dictionary<string, string>();


        private static IConfigurationManager config;
        private static IConfigurationManager ConfigurationManager
        {
          get {
                if (config == null)
                    throw new ApplicationException("You must set the configuration manager before calling this class");
                return config;
          }
          set { config = value; }
        }

        public static void SetConfigurationManager(IConfigurationManager manager)
        {
            ConfigurationManager = manager;
        }


        /// <summary>
        /// Creates an instance of NotificationManager that
        /// uses the scope embedded in the JWT.
        /// </summary>
        public NotificationManager()
        {
            TokenManager tm = new TokenManager();
            this.Scope = tm.Payload("scope");

            Initialize();
        }


        /// <summary>
        /// Creates an instance of NotificationManager with a 
        /// specified scope/appCode.
        /// </summary>
        /// <param name="appCode"></param>
        public NotificationManager(string appCode)
        {
            this.Scope = appCode;

            Initialize();
        }


        /// <summary>
        /// Performs initialization common to any instantiation.
        /// </summary>
        private void Initialize()
        {
            // Populate the app display names.
            this.appDisplayName.Add("CSET", "CSET");
            this.appDisplayName.Add("ACET", "ACET");
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
            string bodyHtml = ResourceHelper.GetEmbeddedResource(@"App_Data\assessmentInviteTemplate_" + this.Scope +".html");

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
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", Utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = contact.Subject;
            message.Body = bodyHtml;
            message.IsBodyHtml = true;
            message.To.Add(new MailAddress(contact.PrimaryEmail));
            message.From = new MailAddress(
            ConfigurationManager.GetAppSetting("Sender Email"),
            ConfigurationManager.GetAppSetting("Sender Display Name"));
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
        public void SendPasswordEmail(string email, string firstName, string lastName, string password)
        {
            string bodyHtml = ResourceHelper.GetEmbeddedResource(@"App_Data\passwordCreationTemplate_" + this.Scope + ".html");
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", Utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = "New " + appDisplayName[this.Scope] + " account creation";
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            ConfigurationManager.GetAppSetting("Sender Email"),
            ConfigurationManager.GetAppSetting("Sender Display Name"));

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
        public void SendInviteePassword(string email, string firstName, string lastName, string password)
        {            
            string templateFile = @"App_Data\invitedPasswordCreationTemplate_" + this.Scope + ".html";

            string bodyHtml = ResourceHelper.GetEmbeddedResource(templateFile);
            bodyHtml = bodyHtml.Replace("{{name}}", firstName + " " + lastName);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", Utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = "You are invited to " + appDisplayName[this.Scope];
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
            ConfigurationManager.GetAppSetting("Sender Email"),
            ConfigurationManager.GetAppSetting("Sender Display Name"));

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
        public void SendPasswordResetEmail(string email, string firstName, string lastName, string password, string subject)
        {
            string bodyHtml = ResourceHelper.GetEmbeddedResource(@"App_Data\passwordResetTemplate_" + this.Scope + ".html");
            string name = (firstName + " " + lastName).Trim();
            if (string.IsNullOrEmpty(name)) name = email;

            bodyHtml = bodyHtml.Replace("{{name}}", name);
            bodyHtml = bodyHtml.Replace("{{password}}", password);
            bodyHtml = bodyHtml.Replace("{{rootUrl}}", Utilities.GetClientHost());

            MailMessage message = new MailMessage();
            message.Subject = subject;
            message.Body = bodyHtml;
            message.To.Add(new MailAddress(email));
            message.From = new MailAddress(
                ConfigurationManager.GetAppSetting("Sender Email"),
                ConfigurationManager.GetAppSetting("Sender Display Name"));

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
#if DEBUG
            // Override the recipient if configured for debug
            string debugRecipient = ConfigurationManager.GetAppSetting("DEBUG EMAIL RECIPIENT");
            if (!string.IsNullOrWhiteSpace(debugRecipient))
            {
                mail.To.RemoveAt(0);
                mail.To.Add(new MailAddress(debugRecipient));
            }
#endif


            // apply stylesheet
            string inlineStylesheet = ResourceHelper.GetEmbeddedResource(@"App_Data\inlineStylesheet.html");
            mail.Body = mail.Body.Replace("{{inline-stylesheet}}", inlineStylesheet);


            SmtpClient client = new SmtpClient();
            client.Port = int.Parse(System.Configuration.ConfigurationManager.AppSettings["SMTP Port"]);
            client.DeliveryMethod = SmtpDeliveryMethod.Network;
            client.UseDefaultCredentials = false;
            client.Host = ConfigurationManager.GetAppSetting("SMTP Host");
            client.Send(mail);
        }


        /// <summary>
        /// Sends a test email.
        /// </summary>
        public void SendTestEmail(string recip)
        {
            // only send the email if configured to do so (unpublished app setting)
            bool allowed = false;
            string allowSetting = ConfigurationManager.GetAppSetting("Allow Test Email");
            if (allowSetting == null || !bool.TryParse(allowSetting, out allowed))
            {
                if (!allowed)
                {
                    throw new Exception("Not configured to send test emails");
                }
            }

            MailMessage m = new MailMessage();
            m.Subject = appDisplayName[this.Scope] + " Test Message";
            m.Body = string.Format("Testing email server {0} on port {1}",
                ConfigurationManager.GetAppSetting("SMTP Host"),
                System.Configuration.ConfigurationManager.AppSettings["SMTP Port"]);
            m.To.Add(new MailAddress(recip));
            m.From = new MailAddress(
            ConfigurationManager.GetAppSetting("Sender Email"),
            ConfigurationManager.GetAppSetting("Sender Display Name"));
            this.SendMail(m);
        }
    }
}

