using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Authentication;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using Microsoft.AspNetCore.Authentication.OpenIdConnect;


namespace CSETWebCore.Helpers
{
    public class UserAuthenticationAzure
    {
        CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public UserAuthenticationAzure(
            CSETContext context) 
        {
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public LoginResponse AuthenticateUser(Login login)
        {
            // authenticate against Azure




            // Read directly from the database; UserManager does not read password and salt, in order to keep them more private
            var loginUser = _context.USERS.Where(x => x.PrimaryEmail == login.Email).FirstOrDefault();

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                UserId = loginUser.UserId,
                Email = login.Email,
                Lang = loginUser.Lang,
                UserFirstName = loginUser.FirstName,
                UserLastName = loginUser.LastName,
                IsSuperUser = loginUser.IsSuperUser,
                ResetRequired = loginUser.PasswordResetRequired,
                ExportExtension = IOHelper.GetExportFileExtension(login.Scope),
                ImportExtensions = IOHelper.GetImportFileExtensions(login.Scope),
                LinkerTime = new BuildNumberHelper().GetLinkerTime(),
                IsFirstLogin = loginUser.IsFirstLogin
            };

            return resp;
        }
    }
}
