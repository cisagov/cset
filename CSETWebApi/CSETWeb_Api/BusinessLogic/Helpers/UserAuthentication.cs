//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security;
using System.Linq;
using System.Text;
using System.Web;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.Win32;
using CSETWeb_Api.BusinessManagers;
using System.IO;
using System.Security.Principal;
using BusinessLogic.Helpers;
using System.Reflection;
using System.Diagnostics;
using CSETWeb_Api.BusinessLogic.Version;

namespace CSETWeb_Api.Helpers
{
    /// <summary>
    /// Authenticates an instance of Login against the USER database table.
    /// </summary>
    public class UserAuthentication
    {
        public static LoginResponse Authenticate(Login login)
        {
            // Ensure that we have what we need
            if (login == null || string.IsNullOrEmpty(login.Email) || string.IsNullOrEmpty(login.Password))
            {
                return null;
            }

            USERS loginUser = null;

            // Read directly from the database; UserManager does not read password and salt, in order to keep them more private
            using (var db = new CSET_Context())
            {
                loginUser = db.USERS.Where(x => x.PrimaryEmail == login.Email).FirstOrDefault();

                if (loginUser == null)
                {
                    return null;
                }
            }

            // Validate the supplied password against the hashed password and its salt
            bool success = PasswordHash.ValidatePassword(login.Password, loginUser.Password, loginUser.Salt);
            if (!success)
            {
                return null;
            }

            // Generate a token for this user
            string token = TransactionSecurity.GenerateToken(loginUser.UserId, login.TzOffset, -1, null, login.Scope);

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                Token = token,
                UserId = loginUser.UserId,
                Email = login.Email,
                UserFirstName = loginUser.FirstName,
                UserLastName = loginUser.LastName,
                IsSuperUser = loginUser.IsSuperUser,
                PasswordResetRequired = loginUser.PasswordResetRequired ?? true,
                ExportExtension = BusinessLogic.ImportAssessment.Export.ExportAssessment.GetFileExtension(login.Scope)
            };

            return resp;
        }


        /// <summary>
        /// Emulates credential authentication without requiring credentials.
        /// The Windows file system is consulted to see if a certain file was placed there
        /// during the stand-alone install process.  
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public static LoginResponse AuthenticateStandalone(Login login)
        {
            int userIdSO = 100;
            string primaryEmailSO = "";

            // Read the file system for the LOCAL-INSTALLATION file put there at install time
            if (!IsLocalInstallation(login.Scope))
            {
                return null;
            }


            String name = WindowsIdentity.GetCurrent().Name;
            name = string.IsNullOrWhiteSpace(name) ? "Local" : name;
            primaryEmailSO = name + "@myorg.org";
            using (var db = new CSET_Context())
            {
                var user = db.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefault();
                if (user == null)
                {
                    UserManager um = new UserManager();
                    UserDetail ud = new UserDetail()
                    {
                        Email = primaryEmailSO,
                        FirstName = name,
                        LastName = ""
                    };
                    UserCreateResponse userCreateResponse = um.CreateUser(ud);

                    db.SaveChanges();
                }
                else
                {
                    userIdSO = user.UserId;
                }
            }

            if (string.IsNullOrEmpty(primaryEmailSO))
            {
                return null;
            }


            // Generate a token for this user
            string token = TransactionSecurity.GenerateToken(userIdSO, login.TzOffset, -1, null, login.Scope);

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                Token = token,
                Email = primaryEmailSO,
                UserFirstName = name,
                UserLastName = "",
                IsSuperUser = false,
                PasswordResetRequired = false,
                ExportExtension = BusinessLogic.ImportAssessment.Export.ExportAssessment.GetFileExtension(login.Scope)
            };


            return resp;
        }


        /// <summary>
        /// Returns 'true' if the installation is 'local' (self-contained using Windows identity).
        /// The local installer will place an empty file (LOCAL-INSTALLATION) in the website folder
        /// and the existence of the file indicates if the installation is local.
        /// </summary>
        /// <param name="app_code"></param>
        /// <returns></returns>
        public static bool IsLocalInstallation(String app_code)
        {
            string physicalAppPath = HttpContext.Current.Request.PhysicalApplicationPath;

            return File.Exists(Path.Combine(physicalAppPath,"LOCAL-INSTALLATION"));
        }
    }
}

