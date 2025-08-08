//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text.RegularExpressions;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Authentication;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace CSETWebCore.Helpers
{
    public class UserAuthentication : IUserAuthentication
    {
        private readonly IPasswordHash _password;
        private readonly IUserBusiness _userBusiness;
        private readonly ILocalInstallationHelper _localInstallationHelper;
        private readonly ITokenManager _transactionSecurity;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IConfiguration _configuration;
        private CSETContext _context;

        public UserAuthentication(IPasswordHash password, IUserBusiness userBusiness,
            ILocalInstallationHelper localInstallationHelper, ITokenManager transactionSecurity,
            INotificationBusiness notificationBusiness, IConfiguration configuration,
            CSETContext context)
        {
            _password = password;
            _transactionSecurity = transactionSecurity;
            _userBusiness = userBusiness;
            _localInstallationHelper = localInstallationHelper;
            _notificationBusiness = notificationBusiness;
            _configuration = configuration;
            _context = context;
        }

        public LoginResponse Authenticate(Login login)
        {
            // Ensure that we have what we need
            if (login == null || string.IsNullOrEmpty(login.Email) || string.IsNullOrEmpty(login.Password))
            {
                return null;
            }

            USERS loginUser = null;

            // Read directly from the database; UserManager does not read password and salt, in order to keep them more private
            loginUser = _context.USERS.Where(x => x.PrimaryEmail == login.Email).FirstOrDefault();


            if (loginUser == null)
            {
                return null;
            }

            if (!loginUser.IsActive)
            {
                return null;
            }

            var roles = (from u in _context.USERS
                         join ur in _context.USER_ROLES on u.UserId equals ur.UserId
                         join r in _context.ROLES on ur.RoleId equals r.RoleId
                         where u.UserId == loginUser.UserId
                         select r.RoleName).ToList();

            List<PASSWORD_HISTORY> tempPasswords = _context.PASSWORD_HISTORY.Where(password => password.UserId == loginUser.UserId && password.Is_Temp).ToList();

            // Validate the supplied password against the hashed password and its salt
            bool passwordIsValid = _password.ValidatePassword(login.Password, loginUser.Password, loginUser.Salt);

            string tempPasswordUsed = null;

            // Validate against the user's temp passwords as well in case they forgot password and need to reset it.
            if (!passwordIsValid)
            {
                foreach (PASSWORD_HISTORY tempPassword in tempPasswords)
                {
                    // Include a trimmed alternative in case they accidentally copied a trailing space/linefeed from the temp password email.
                    if (_password.ValidatePassword(login.Password, tempPassword.Password, tempPassword.Salt) ||
                        _password.ValidatePassword(login.Password.TrimEnd((Environment.NewLine + " ").ToCharArray()), tempPassword.Password, tempPassword.Salt))
                    {
                        passwordIsValid = true;
                        tempPasswordUsed = tempPassword.Password;
                        break;
                    }
                }

                // Could not successfully authenticate with any temp password or actual password
                if (!passwordIsValid)
                {
                    return null;
                }
            }
            else
            {
                // We never require a password reset if the user is able to login with their official password that is stored in the USERS table
                loginUser.PasswordResetRequired = false;

                if (tempPasswords.Count > 0)
                {
                    UserAccountSecurityManager accountSecurityManager = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);

                    // Remove any existing temp passwords from history after a successful login with an official password
                    accountSecurityManager.CleanUpPasswordHistory(loginUser.UserId, true);
                }
            }


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
                IsFirstLogin = loginUser.IsFirstLogin,
                Roles = roles.Any() ? roles : ["USER"]
            };


            // The password is valid, but is it expired?
            string passwordHashUsed = tempPasswordUsed == null ? loginUser.Password : tempPasswordUsed;
            var isExpired = new PasswordExpiration().IsExpired(_context, loginUser.UserId, passwordHashUsed);
            if (isExpired)
            {
                resp.IsPasswordExpired = true;
                return resp;
            }

            // Generate a token for this user and add to the response
            string token = _transactionSecurity.GenerateToken(loginUser.UserId, null, login.TzOffset, -1, null, null, login.Scope);
            resp.Token = token;


            return resp;
        }


        /// <summary>
        /// Emulates credential authentication without requiring credentials.
        /// The Windows file system is consulted to see if a certain file was placed there
        /// during the stand-alone install process.  
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        public LoginResponse AuthenticateStandalone(Login login, ITokenManager tokenManager)
        {
            int? assessmentId = null;

            // Safely try to get assessment ID from token if one exists
            try
            {
                assessmentId = ((TokenManager)tokenManager).GetAssessmentId();
                assessmentId = assessmentId == 0 ? null : assessmentId;
            }
            catch
            {
                // If no valid token exists yet, assessmentId remains null
                assessmentId = null;
            }

            // Read the file system for the LOCAL-INSTALLATION file put there at install time
            if (!_localInstallationHelper.IsLocalInstallation())
            {
                // this is not a local install.  Return what we know about this user (if anything).
                if (tokenManager.Payload("userid") != null)
                {
                    var loginUser = _context.USERS.Where(x => x.UserId == int.Parse(tokenManager.Payload("userid"))).FirstOrDefault();

                    if (loginUser != null)
                    {
                        var respUser = new LoginResponse
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

                        return respUser;
                    }
                }

                return null;
            }

            string name = null;

            int userIdSO = 1;
            string primaryEmailSO = "";

            name = Environment.UserName;
            name = string.IsNullOrWhiteSpace(name) ? "Local" : name;
            primaryEmailSO = name;

            // Check for UserId = 1 directly
            var user = _context.USERS.Where(x => x.UserId == 1).FirstOrDefault();

            if (user == null)
            {
                // Create user with UserId = 1 if it doesn't exist
                UserDetail ud = new UserDetail()
                {
                    Email = primaryEmailSO,
                    FirstName = name,
                    LastName = ""
                };

                UserCreateResponse userCreateResponse = _userBusiness.CreateUser(ud, _context);
                _context.SaveChanges();

                // Get the newly created user and force UserId = 1
                var newUser = _context.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefault();
                if (newUser != null && newUser.UserId != 1)
                {
                    // Update the user to have UserId = 1
                    newUser.UserId = 1;
                    _context.SaveChanges();
                }

                _localInstallationHelper.determineIfUpgradedNeededAndDoSo(userIdSO, _context);
            }
            else
            {
                userIdSO = 1; // Always use UserId = 1
            }

            if (string.IsNullOrEmpty(primaryEmailSO))
            {
                return null;
            }


            // Generate a token for this user
            string token = _transactionSecurity.GenerateToken(userIdSO, null, login.TzOffset, -1, assessmentId, null, login.Scope);

            // Build response object
            var resp = new LoginResponse
            {
                Token = token,
                Email = primaryEmailSO,
                Lang = user == null ? "en" : user.Lang ?? "en",
                UserFirstName = name,
                UserLastName = "",
                IsSuperUser = false,
                ResetRequired = false,
                UserId = userIdSO,
                ExportExtension = IOHelper.GetExportFileExtension(login.Scope),
                ImportExtensions = IOHelper.GetImportFileExtensions(login.Scope),
                LinkerTime = new BuildNumberHelper().GetLinkerTime(),
                IsFirstLogin = user?.IsFirstLogin ?? false
            };


            return resp;
        }


        /// <summary>
        /// Generates a 10-character key for anonymous access.
        /// The alpha characters are all caps.
        /// </summary>
        /// <returns></returns>
        public string GenerateAccessKey()
        {
            var key = "";
            var keyIsUnique = false;

            while (!keyIsUnique)
            {
                key = UniqueIdGenerator.Instance.GetBase32UniqueId(10).ToUpper();
                if (_context.ACCESS_KEY.Count(x => x.AccessKey == key) == 0)
                {
                    keyIsUnique = true;
                }
            }

            var dbAK = new ACCESS_KEY()
            {
                AccessKey = key,
                GeneratedDate = DateTime.UtcNow
            };

            _context.ACCESS_KEY.Add(dbAK);
            _context.SaveChanges();

            return key;
        }


        /// <summary>
        /// Emulates credential authentication solely by providing
        /// a valid Access Key.
        /// </summary>
        /// <returns></returns>
        public LoginResponse AuthenticateAccessKey(AnonymousLogin login)
        {
            var ak = _context.ACCESS_KEY.FirstOrDefault(x => x.AccessKey == login.AccessKey);

            if (ak == null)
            {
                // supplied access key does not exist
                return null;
            }

            var resp = new LoginResponse()
            {
                ExportExtension = IOHelper.GetExportFileExtension(login.Scope),
                ImportExtensions = IOHelper.GetImportFileExtensions(login.Scope),
                LinkerTime = new BuildNumberHelper().GetLinkerTime()
            };

            // Generate a token for this user and add to the response
            string token = _transactionSecurity.GenerateToken(null, login.AccessKey, login.TzOffset, -1, null, null, login.Scope);
            resp.Token = token;

            return resp;
        }
    }
}