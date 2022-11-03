namespace CSETWebCore.AutoResponder
{
    public interface IEmailHelper
    {
        void SendFollowUp(string email, string firstName, string lastName);
        void SendWeekly(string attachmentPath, string email, string firstName, string lastName);
    }
}