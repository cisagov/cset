//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Net.Mail;
using CSETWebCore.Model.Contact;

namespace CSETWebCore.Interfaces.Notification
{
    public interface INotificationBusiness
    {
        void SetAppCode();
        void SetAppCode(string appCode);
        void Initialize();
        void InviteToAssessment(ContactCreateParameters contact);
        void SendPasswordEmail(string email, string firstName, string lastName, string password, string appCode);
        void SendInviteePassword(string email, string firstName, string lastName, string password, string appCode);
        void SendPasswordResetEmail(string email, string firstName, string lastName, string password, string subject, string appCode);
        void SendMail(MailMessage mail);
        void SendTestEmail(string recip);
    }
}