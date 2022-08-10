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
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.Helpers
{
    public class UserAuthentication : IUserAuthentication
    {
        private readonly IPasswordHash _password;
        private readonly IUserBusiness _userBusiness;
        private readonly ITokenManager _transactionSecurity;
        private readonly IHostingEnvironment _hostingEnvironment;
        private CSETContext _context;

        public UserAuthentication(IPasswordHash password, IUserBusiness userBusiness, 
            ITokenManager transactionSecurity, IHostingEnvironment hostingEnvironment, CSETContext context)
        {
            _password = password;
            _transactionSecurity = transactionSecurity;
            _userBusiness = userBusiness;
            _hostingEnvironment = hostingEnvironment;
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
            if (!IsLocalInstallation(login.Scope))
            {
                return null;
            }

            using (CSETContext context = new CSETContext()) {
                

                string name = null;
                
                name = Environment.UserName;
                name = string.IsNullOrWhiteSpace(name) ? "Local" : name;

                primaryEmailSO = name;
                //check for legacy default email for local installation and set to new standard
                var userOrg = await context.USERS.Where(x => x.PrimaryEmail == primaryEmailSO + "@myorg.org").FirstOrDefaultAsync();
                if (userOrg != null)
                {
                    string tmp = userOrg.PrimaryEmail.Split('@')[0];
                    userOrg.PrimaryEmail = tmp;
                    if (await context.USERS.Where(x => x.PrimaryEmail == tmp).FirstOrDefaultAsync() == null)
                        await context.SaveChangesAsync();
                    primaryEmailSO = userOrg.PrimaryEmail;
                }
                else 
                { 
                    //check for legacy default local usernames (in the form HOSTNAME\USERNAME)
                    string regex = @"^.*(\\)" + primaryEmailSO + "$";
                    var allUsers = await context.USERS.ToListAsync();
                    var legacyUser = allUsers.Where(x => Regex.Match(x.PrimaryEmail, regex).Success).FirstOrDefault();
                    if (legacyUser != null)
                    {
                        string tmp = legacyUser.PrimaryEmail.Split('\\')[1];
                        legacyUser.PrimaryEmail = tmp;
                        if (await context.USERS.Where(x => x.PrimaryEmail == tmp).FirstOrDefaultAsync() == null)
                            await context.SaveChangesAsync();
                        primaryEmailSO = legacyUser.PrimaryEmail;
                    }
                }


                var user = await context.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefaultAsync();
                if (user == null)
                {
                    UserDetail ud = new UserDetail()
                    {
                        Email = primaryEmailSO,
                        FirstName = name,
                        LastName = ""
                    };
                    UserCreateResponse userCreateResponse = await _userBusiness.CreateUser(ud,context);

                    await context.SaveChangesAsync();
                    //update the userid 1 to the new user
                    var tempu = await context.USERS.Where(x => x.PrimaryEmail == primaryEmailSO).FirstOrDefaultAsync();
                    if (tempu != null)
                        userIdSO = tempu.UserId;
                    await DetermineIfUpgradedNeededAndDoSo(userIdSO,context);
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

        private bool IsUpgraded = false;

        public async Task DetermineIfUpgradedNeededAndDoSo(int newuserID, CSETContext context)
        {
            //look to see if the localuser exists
            //if so then get that user id and changes all 
            if (!IsUpgraded)
            {
                var user = await context.USERS.Where(x => x.PrimaryEmail == "localuser").FirstOrDefaultAsync();
                if (user != null)
                {
                    var contacts = await context.ASSESSMENT_CONTACTS.Where(x => x.UserId == user.UserId).ToListAsync();
                    if(contacts.Any())
                        for (int i = 0; i < contacts.Count(); i++)
                            contacts[i].UserId = newuserID;
                    
                    context.ASSESSMENT_CONTACTS.UpdateRange(contacts);
                    await context.SaveChangesAsync();
                }
            }
            IsUpgraded = true;
        }

        /// <summary>
        /// Returns 'true' if the installation is 'local' (self-contained using Windows identity).
        /// The local installer will place an empty file (LOCAL-INSTALLATION) in the website folder
        /// and the existence of the file indicates if the installation is local.
        /// </summary>
        /// <param name="app_code"></param>
        /// <returns></returns>
        public bool IsLocalInstallation(String app_code)
        {
            string physicalAppPath = _hostingEnvironment.ContentRootPath;

            return File.Exists(Path.Combine(physicalAppPath, "LOCAL-INSTALLATION"));
        }


        
    }
}