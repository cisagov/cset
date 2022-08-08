using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.User
{
    public interface IUserBusiness
    {
        Task<UserCreateResponse> CreateUser(UserDetail userDetail, CSETContext tmpContext);
        Task UpdateUser(int userid, string PrimaryEmail, CreateUser user);
        UserDetail GetUserDetail(string email);
        CreateUser GetUserInfo(int userId);
        UserCreateResponse CheckUserExists(UserDetail userDetail);
        UserDetail GetUserDetail(int userId);
    }
}