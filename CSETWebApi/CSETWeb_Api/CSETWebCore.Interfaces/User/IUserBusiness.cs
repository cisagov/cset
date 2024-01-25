//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;

namespace CSETWebCore.Interfaces.User
{
    public interface IUserBusiness
    {
        UserCreateResponse CreateUser(UserDetail userDetail, CSETContext tmpContext);
        void UpdateUser(int userid, string PrimaryEmail, CreateUser user);
        UserDetail GetUserDetail(string email);
        CreateUser GetUserInfo(int? userId);
        UserCreateResponse CheckUserExists(UserDetail userDetail);
        UserDetail GetUserDetail(int userId);

        string CreateTempPassword();

        string InsertRandom(string s, string choices, int number);
    }
}