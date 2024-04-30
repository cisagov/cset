//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Net.Mail;
using CSETWebCore.Model.Contact;

namespace CSETWebCore.Interfaces.Notification
{
    public interface INotificationBusiness
    {
        void SetScope();
        void SetScope(string scope);
        void Initialize();
        void InviteToAssessment(ContactCreateParameters contact);
        void SendPasswordEmail(string email, string firstName, string lastName, string password, string appName);
        void SendInviteePassword(string email, string firstName, string lastName, string password, string appName);
        void SendPasswordResetEmail(string email, string firstName, string lastName, string password, string subject, string appName);
        void SendMail(MailMessage mail);
        void SendTestEmail(string recip);
    }
}