//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.Password;
using CSETWebCore.Model.User;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Model.Auth;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace CSETWebCore.Helpers
{
    public class UserAccountSecurityManager
    {
        private readonly CSETContext _context;
        private readonly IUserBusiness _userBusiness;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IConfiguration _configuration;

        // Password length limits
        public readonly int PasswordLengthMin = 13;
        public readonly int PasswordLengthMax = 50;

        // The number of old passwords that cannot be reused
        public readonly int NumberOfHistoricalPasswords = 24;

        private readonly TranslationOverlay _overlay;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public UserAccountSecurityManager(
            CSETContext context,
            IUserBusiness userBusiness,
            INotificationBusiness notificationBusiness,
            IConfiguration configuration)
        {
            _context = context;
            _userBusiness = userBusiness;
            _notificationBusiness = notificationBusiness;
            _configuration = configuration;

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// Creates a new user.  If sendEmail = true, it sends them an email 
        /// containing a temporary password.
        /// 
        /// When CSET is in "beta/test mode", this method is called with sendEmail = false.
        /// This prevents the user from logging in before an administrator 
        /// has a chance to approve the user's access first.
        /// </summary>
        /// <param name="info">User details</param>
        /// <param name="sendEmail">Indicates if the temp password email should be sent immediately</param>
        /// <returns></returns>
        public bool CreateUser(CreateUser info, bool sendEmail)
        {
            try
            {
                // Create the USER and USER_DETAIL_INFORMATION records for this new user
                var ud = new UserDetail()
                {
                    UserId = (int)info.UserId,
                    Email = info.PrimaryEmail,
                    FirstName = info.FirstName,
                    LastName = info.LastName
                };
                UserCreateResponse userCreateResponse = _userBusiness.CreateUser(ud, _context);

                _context.USER_SECURITY_QUESTIONS.Add(new USER_SECURITY_QUESTIONS()
                {
                    UserId = userCreateResponse.UserId,
                    SecurityQuestion1 = info.SecurityQuestion1,
                    SecurityQuestion2 = info.SecurityQuestion2,
                    SecurityAnswer1 = info.SecurityAnswer1,
                    SecurityAnswer2 = info.SecurityAnswer2
                });

                _context.SaveChanges();

                // Send the new temp password to the user
                if (sendEmail)
                {
                    _notificationBusiness.SendPasswordEmail(userCreateResponse.PrimaryEmail, info.FirstName, info.LastName, userCreateResponse.TemporaryPassword, info.AppName);
                }

                return true;
            }
            catch (ApplicationException app)
            {
                throw new Exception("This account already exists. Please request a new password using the Forgot Password link if you have forgotten your password.", app);
            }
            catch (DbUpdateException due)
            {
                throw new Exception("This account already exists. Please request a new password using the Forgot Password link if you have forgotten your password.", due);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return false;
            }
        }


        /// <summary>
        /// Changes the user's password and logs the new password in PASSWORD_HISTORY.
        /// 
        /// NOTE:  This method should not be called without first validating the password's 
        /// suitability against the password policy rules.
        /// </summary>
        /// <param name="changePass"></param>
        /// <returns></returns>
        public bool ChangePassword(ChangePassword changePass)
        {
            try
            {
                var user = _context.USERS.Where(x => x.PrimaryEmail == changePass.PrimaryEmail).FirstOrDefault();
                var info = _context.USER_DETAIL_INFORMATION.Where(x => x.PrimaryEmail == user.PrimaryEmail).FirstOrDefault();

                new PasswordHash().HashPassword(changePass.NewPassword, out string hash, out string salt);

                // update the password on the USERS record
                user.Password = hash;
                user.Salt = salt;
                user.PasswordResetRequired = false;


                // log the password to history
                var history = new PASSWORD_HISTORY()
                {
                    Created = DateTime.UtcNow,
                    UserId = user.UserId,
                    Is_Temp = false,
                    Password = hash,
                    Salt = salt
                };
                _context.PASSWORD_HISTORY.Add(history);

                _context.SaveChanges();

                // clean up
                CleanUpPasswordHistory(user.UserId, true);

                return true;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return false;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <param name="subject"></param>
        /// <param name="appName"></param>
        /// <returns></returns>
        public bool ResetPassword(string email, string subject, string appName)
        {
            /**
             * get the user and make sure they exist
             * set the reset password flag
             * generate the new password
             * send the email 
             * return 
             */
            try
            {
                var user = _context.USERS.Where(x => x.PrimaryEmail == email).FirstOrDefault();

                user.PasswordResetRequired = true;

                // generate a temp password
                var password = _userBusiness.CreateTempPassword();


#if DEBUG
                // set the password back to 'abc' for consistency/predictability when debugging
                if (user.PrimaryEmail == "a@b.com")
                {
                    password = "abc";
                }
#endif

                new PasswordHash().HashPassword(password, out string hash, out string salt);


                // log the temp password to history
                var history = new PASSWORD_HISTORY()
                {
                    Created = DateTime.UtcNow,
                    UserId = user.UserId,
                    Is_Temp = true,
                    Password = hash,
                    Salt = salt
                };
                _context.PASSWORD_HISTORY.Add(history);


                _context.SaveChanges();


                CleanUpPasswordHistory(user.UserId, false);


                // send the notification email
                _notificationBusiness.SendPasswordResetEmail(user.PrimaryEmail, user.FirstName, user.LastName, password, subject, appName);

                return true;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return false;
            }
        }


        /// <summary>
        /// Keeps the last 24 password history records and deletes the rest.
        /// </summary>
        /// <param name="userId"></param>
        public void CleanUpPasswordHistory(int userId, bool deleteTemps)
        {
            // delete temps
            if (deleteTemps)
            {
                var tempsHistory = _context.PASSWORD_HISTORY.Where(x => x.UserId == userId && x.Is_Temp).ToList();
                _context.PASSWORD_HISTORY.RemoveRange(tempsHistory);
            }


            // only keep the last 24 entries
            var last24 = _context.PASSWORD_HISTORY.Where(x => x.UserId == userId)
                .OrderByDescending(x => x.Created)
                .Take(24).ToList().Select(x => x.Created);

            // build a list of any extraneous entries prior to the last 24 and delete them
            var deleteThese = _context.PASSWORD_HISTORY.Where(x => x.UserId == userId && !last24.Contains(x.Created)).ToList();
            _context.PASSWORD_HISTORY.RemoveRange(deleteThese);


            _context.SaveChanges();
        }


        /// <summary>
        /// Returns a list of potential security questions.
        /// </summary>
        /// <returns></returns>
        public List<PotentialQuestions> GetSecurityQuestionList(string lang)
        {
            List<PotentialQuestions> questions =
                (from a in _context.SECURITY_QUESTION
                 select new PotentialQuestions()
                 {
                     SecurityQuestion = a.SecurityQuestion,
                     SecurityQuestionId = a.SecurityQuestionId
                 }).ToList<PotentialQuestions>();

            foreach (var item in questions)
            {
                item.SecurityQuestion = _overlay.GetValue("SECURITY_QUESTION", item.SecurityQuestionId.ToString(), lang)?.Value 
                    ?? item.SecurityQuestion;  
            }

            return questions;
        }


        /// <summary>
        /// Checks the proposed password to see if it meets the 
        /// complexity rules and has not been used in the past 24 passwords.
        /// </summary>
        /// <param name="pw"></param>
        /// <returns></returns>
        public PasswordResponse ComplexityRulesMet(ChangePassword cp)
        {
            var resp = new PasswordResponse
            {
                PasswordLengthMin = PasswordLengthMin,
                PasswordLengthMax = PasswordLengthMax,
                NumberOfHistoricalPasswords = NumberOfHistoricalPasswords
            };


            // check to see if configured to bypass policy (for development)
            var bypassSection = _configuration.GetSection("BypassPasswordComplexityRules");
            bool.TryParse(bypassSection.Value, out bool bypass);
            if (bypass)
            {
                resp.PasswordLengthMet = true;
                resp.PasswordContainsLower = true;
                resp.PasswordContainsUpper = true;
                resp.PasswordContainsNumbers = true;
                resp.PasswordContainsSpecial = true;
                resp.PasswordNotReused = true;
                resp.IsValid = true;
                return resp;
            }


            var pw = cp.NewPassword;

            // can't be in the last 24 passwords (PASSWORD-HISTORY)
            resp.PasswordNotReused = IsPasswordInHistory(cp) ? false : true;
            resp.PasswordLengthMet =
                pw.Length < PasswordLengthMin || pw.Length > PasswordLengthMax ? false : true;
            resp.PasswordContainsNumbers = !Regex.IsMatch(pw, "[0-9].*[0-9]") ? false : true;
            resp.PasswordContainsLower = !Regex.IsMatch(pw, "[a-z]") ? false : true;
            resp.PasswordContainsUpper = !Regex.IsMatch(pw, "[A-Z]") ? false : true;
            resp.PasswordContainsSpecial =
                !Regex.IsMatch(pw, "[*.!@$%^&(){}\\[\\]:;<>,.?/~_+\\-=|]") ? false : true;

            return resp;
        }


        /// <summary>
        /// Looks at the most recent 24 historical passwords and tests the 
        /// proposed new password against them to see if it has been used before.
        /// 
        /// TODO: clean up any history records outside of the most recent 24.
        /// </summary>
        /// <param name="pw"></param>
        /// <param name="cp"></param>
        /// <returns></returns>
        private bool IsPasswordInHistory(ChangePassword cp)
        {
            var user = _context.USERS.Where(x => x.PrimaryEmail == cp.PrimaryEmail).First();
            var pwHash = new PasswordHash();

            var listPasswordHistory = _context.PASSWORD_HISTORY.Where(x => x.UserId == user.UserId)
                .OrderByDescending(y => y.Created)
                .Take(NumberOfHistoricalPasswords)
                .ToList();

            foreach (var hist in listPasswordHistory)
            {
                var passwordFound = pwHash.ValidatePassword(cp.NewPassword, hist.Password, hist.Salt);
                if (passwordFound)
                {
                    return true;
                }
            }

            return false;
        }


        /// <summary>
        /// Checks the proposed email address against an "allowlist" file.
        /// - If the file does not exist, all email addresses are approved.
        /// - The only wildcard character supported is an asterisk (*).
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public bool EmailIsAllowed(string email, IWebHostEnvironment _hostingEnvironment)
        {
            var allowPath = Path.Combine(_hostingEnvironment.ContentRootPath, "ALLOWLIST.txt");

            // no allowlist file exists - all emails are allowed
            if (!File.Exists(allowPath))
            {
                return true;
            }

            var patternDefined = false;

            var allowlist = File.ReadAllLines(allowPath).ToList<string>();
            foreach (var line in allowlist)
            {
                var l = line.Trim().ToLower();

                // blank lines and comment lines are ignored
                if (l == "" || l.StartsWith("#") || l.StartsWith("--"))
                {
                    continue;
                }

                patternDefined = true;

                // Convert the email pattern for regex comparison
                l = l.Replace(".", @"\.").Replace("*", ".+");

                if (Regex.IsMatch(email.ToLower(), l))
                {
                    return true;
                }
            }

            // We matched none of the defined patterns
            if (patternDefined)
            {
                NLog.LogManager.GetCurrentClassLogger().Info($"Signup rejected - allowlist prohibited signup for {email}");
                return false;
            }

            // no patterns were defined
            return true;
        }
    }
}
