using System;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text.RegularExpressions;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Authentication;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using Microsoft.AspNetCore.Hosting;


namespace CSETWebCore.Helpers
{
    public class UserAuthentication : IUserAuthentication
    {
        private readonly IPasswordHash _password;
        private readonly IUserBusiness _userBusiness;
        private readonly ILocalInstallationHelper _localInstallationHelper;
        private readonly ITokenManager _transactionSecurity;
        private CSETContext _context;

        public UserAuthentication(IPasswordHash password, IUserBusiness userBusiness, 
            ILocalInstallationHelper localInstallationHelper, ITokenManager transactionSecurity, CSETContext context)
        {
            _password = password;
            _transactionSecurity = transactionSecurity;
            _userBusiness = userBusiness;
            _localInstallationHelper = localInstallationHelper;
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

                // Validate the supplied password against the hashed password and its salt
            bool success = _password.ValidatePassword(login.Password, loginUser.Password, loginUser.Salt);
            if (!success)
            {
                return null;
            }

            // Generate a token for this user
            string token = _transactionSecurity.GenerateToken(loginUser.UserId, login.TzOffset, -1, null, null, login.Scope);

            // Build response object
            LoginResponse resp = new LoginResponse
            {
                Token = token,
                UserId = loginUser.UserId,
                Email = login.Email,
                UserFirstName = loginUser.FirstName,
                UserLastName = loginUser.LastName,
                IsSuperUser = loginUser.IsSuperUser,
                ResetRequired = loginUser.PasswordResetRequired ?? true,
                ExportExtension = IOHelper.GetExportFileExtension(login.Scope),
                ImportExtensions = IOHelper.GetImportFileExtensions(login.Scope),
                LinkerTime = new BuildNumberHelper().GetLinkerTime()
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
        public LoginResponse AuthenticateStandalone(Login login, ITokenManager tokenManager)
        {
            int?  assessmentId = ((TokenManager)tokenManager).GetAssessmentId();
            
            assessmentId = assessmentId == 0 ? null : assessmentId;

            int userIdSO = 100;
            string primaryEmailSO = "";

            // Read the file system for the LOCAL-INSTALLATION file put there at install time
            if (!_localInstallationHelper.IsLocalInstallation())
            {
                return null;
            }

            using (CSETContext tmpcontext = new CSETContext()) {
                

                string name = null;
                
                name = Environment.UserName;
                name = string.IsNullOrWhiteSpace(name) ? "Local" : name;

                primaryEmailSO = name;
                //check for legacy default email for local installation and set to new standard
                var userOrg = tmpcontext.USERS.Where(x => x.PrimaryEmail == primaryEmailSO + "@myorg.org").FirstOrDefault();
                if (userOrg != null)
                {
                    string tmp = userOrg.PrimaryEmail.Split('@')[0];
                    userOrg.PrimaryEmail = tmp;
                    if (tmpcontext.USERS.Where(x => x.PrimaryEmail == tmp).FirstOrDefault() == null)
                        tmpcontext.SaveChanges();
                    primaryEmailSO = userOrg.PrimaryEmail;
                }
                else 
                { 
                    //check for legacy default local usernames (in the form HOSTNAME\USERNAME)
                    string regex = @"^.*(\\)" + primaryEmailSO + "$";
                    var allUsers = tmpcontext.USERS.ToList();
                    var legacyUser = allUsers.Where(x => Regex.Match(x.PrimaryEmail, regex).Success).FirstOrDefault();
                    if (legacyUser != null)
                    {
                        string tmp = legacyUser.PrimaryEmail.Split('\\')[1];
                        legacyUser.PrimaryEmail = tmp;
                        if (tmpcontext.USERS.Where(x => x.PrimaryEmail == tmp).FirstOrDefault() == null)
                            tmpcontext.SaveChanges();
                        primaryEmailSO = legacyUser.PrimaryEmail;
                    }
                }


                var user = tmpcontext.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefault();
                if (user == null)
                {
                    UserDetail ud = new UserDetail()
                    {
                        Email = primaryEmailSO,
                        FirstName = name,
                        LastName = ""
                    };
                    UserCreateResponse userCreateResponse = _userBusiness.CreateUser(ud,tmpcontext);

                    tmpcontext.SaveChanges();
                    //update the userid 1 to the new user
                    var tempu = tmpcontext.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefault();
                    if (tempu != null)
                        userIdSO = tempu.UserId;
                    _localInstallationHelper.determineIfUpgradedNeededAndDoSo(userIdSO,tmpcontext);
                }
                else
                {
                    userIdSO = user.UserId;
                }

                    if (string.IsNullOrEmpty(primaryEmailSO))
                {
                    return null;
                }


                // Generate a token for this user
                string token = _transactionSecurity.GenerateToken(userIdSO, login.TzOffset, -1, assessmentId, null, login.Scope);

                // Build response object
                LoginResponse resp = new LoginResponse
                {
                    Token = token,
                    Email = primaryEmailSO,
                    UserFirstName = name,
                    UserLastName = "",
                    IsSuperUser = false,
                    ResetRequired = false,
                    UserId = userIdSO,
                    ExportExtension = IOHelper.GetExportFileExtension(login.Scope),
                    ImportExtensions = IOHelper.GetImportFileExtensions(login.Scope),
                    LinkerTime = new BuildNumberHelper().GetLinkerTime()
                };


                return resp;
            }
        }        
    }
}