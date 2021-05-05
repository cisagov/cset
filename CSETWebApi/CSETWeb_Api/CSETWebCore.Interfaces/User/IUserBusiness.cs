using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;

namespace CSETWebCore.Interfaces.User
{
    public interface IUserBusiness
    {
        UserCreateResponse CreateUser(UserDetail userDetail);
        void UpdateUser(int userid, string PrimaryEmail, CreateUser user);
        UserDetail GetUserDetail(string email);
        CreateUser GetUserInfo(int userId);
        UserCreateResponse CheckUserExists(UserDetail userDetail);
        UserDetail GetUserDetail(int userId);
    }
}