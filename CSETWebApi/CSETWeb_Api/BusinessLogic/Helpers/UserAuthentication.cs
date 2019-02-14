//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
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
            string token = TransactionSecurity.GenerateToken(loginUser.UserId, login.TzOffset, -1, null);

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                Token = token,
                UserId = loginUser.UserId,
                Email = login.Email,
                UserFirstName = loginUser.FirstName,
                UserLastName = loginUser.LastName,
                IsSuperUser = loginUser.IsSuperUser,
                PasswordResetRequired = loginUser.PasswordResetRequired ?? true

            };

            return resp;
        }


        /// <summary>
        /// Emulates credential authentication without requiring credentials.
        /// The Windows Registry is consulted to see if a certain key was placed there
        /// during the stand-alone install process.  
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public static LoginResponse AuthenticateStandalone(Login login)
        {
            int userIdSO = 100;
            string primaryEmailSO = "";

            // Read the Registry for the user key put there at install time
            if (!IsLocalInstallation())
            {
                return null;
            }


            primaryEmailSO = "localuser@myorg.org";
            using (var db = new CSET_Context())
            {
                var user = db.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefault();
                if (user == null)
                {
                    UserManager um = new UserManager();
                    UserDetail ud = new UserDetail()
                    {
                        Email = primaryEmailSO,
                        FirstName = "Local",
                        LastName = "User"
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
            string token = TransactionSecurity.GenerateToken(userIdSO, login.TzOffset, -1, null);

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                Token = token,
                Email = primaryEmailSO,
                UserFirstName = "Local",
                UserLastName = "User",
                IsSuperUser = false,
                PasswordResetRequired = false
            };


            return resp;
        }


        /// <summary>
        /// Returns a boolean indicating if this API component is installed
        /// in a 'local' installation configuration (the Registry key exists).
        /// </summary>
        /// <returns></returns>
        public static bool IsLocalInstallation()
        {
            // Read the Registry for the user key put there at install time
            try
            {
                string subkey = "SOFTWARE\\DHS\\CSET 9.0";
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(subkey))
                {
                    if (key == null)
                    {
                        return false;
                    }

                    Object o = key.GetValue("LocalRunAsOpen");
                    if (o == null)
                    {
                        return false;
                    }

                    if (bool.Parse(o.ToString()))
                    {
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }

            return false;
        }
    }
}

