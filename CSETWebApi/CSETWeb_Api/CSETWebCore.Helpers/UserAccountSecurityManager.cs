//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.Password;
using CSETWebCore.Model.User;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Model.Auth;

namespace CSETWebCore.Helpers
{
    public class UserAccountSecurityManager
    {
        private readonly CSETContext _context;
        private readonly IUserBusiness _userBusiness;
        private readonly INotificationBusiness _notificationBusiness;

        // Password length limits
        public readonly int PasswordLengthMin = 13;
        public readonly int PasswordLengthMax = 25;

        // The number of old passwords that cannot be reused
        public readonly int NumberOfHistoricalPasswords = 24;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public UserAccountSecurityManager(CSETContext context, IUserBusiness userBusiness, INotificationBusiness notificationBusiness)
        {
            _context = context;
            _userBusiness = userBusiness;
            _notificationBusiness = notificationBusiness;
        }


        /// <summary>
        /// Creates a new user and sends them an email containing a temporary password.
        /// </summary>
        /// <param name="info"></param>
        /// <returns></returns>
        public bool CreateUserSendEmail(CreateUser info)
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
                _notificationBusiness.SendPasswordEmail(userCreateResponse.PrimaryEmail, info.FirstName, info.LastName, userCreateResponse.TemporaryPassword, info.AppCode);

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
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

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

                // update the user password
                user.Password = hash;
                user.Salt = salt;
                user.PasswordResetRequired = false;


                // log the password to history
                var history = new PASSWORD_HISTORY()
                {
                    Created = DateTime.UtcNow,
                    UserId = user.UserId,
                    Password = hash,
                    Salt = salt
                };
                _context.PASSWORD_HISTORY.Add(history);

                _context.SaveChanges();
                return true;
            }
            catch (Exception exc)
            {
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

                return false;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <param name="subject"></param>
        /// <param name="appCode"></param>
        /// <returns></returns>
        public bool ResetPassword(string email, string subject, string appCode)
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
                var password = UniqueIdGenerator.Instance.GetBase32UniqueId(6);

                // add complexity:  insert random lower case letter, digits and special character
                password = InsertRandom(password, "abcdefghijklmnopqrstuvwxyz", 1);
                password = InsertRandom(password, "01234567890", 2);
                password = InsertRandom(password, "*!@$%^&:;,.?/~_+-=|", 1);


#if DEBUG
                // set the password back to 'abc' for consistency/predictability when debugging
                if (user.PrimaryEmail == "a@b.com")
                {
                    password = "abc";
                }
#endif

                new PasswordHash().HashPassword(password, out string hash, out string salt);
                user.Password = hash;
                user.Salt = salt;

                _notificationBusiness.SendPasswordResetEmail(user.PrimaryEmail, user.FirstName, user.LastName, password, subject, appCode);

                _context.SaveChanges();

                return true;
            }
            catch (Exception exc)
            {
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

                return false;
            }
        }


        /// <summary>
        /// Inserts a number of characters randomly pulled from the choices string.
        /// </summary>
        private string InsertRandom(string s, string choices, int number)
        {
            for (int i = 1; i <= number; i++)
            {
                s = s.Insert(new Random().Next(1, s.Length), choices[new Random().Next(0, choices.Length)].ToString());
            }
            return s;
        }


        /// <summary>
        /// Returns a list of potential security questions.
        /// </summary>
        /// <returns></returns>
        public List<PotentialQuestions> GetSecurityQuestionList()
        {
            List<PotentialQuestions> questions =
                (from a in _context.SECURITY_QUESTION
                 select new PotentialQuestions()
                 {
                     SecurityQuestion = a.SecurityQuestion,
                     SecurityQuestionId = a.SecurityQuestionId
                 }).ToList<PotentialQuestions>();
            return questions;
        }


        /// <summary>
        /// Checks the proposed password to see if it meets the 
        /// complexity rules and has not been used in the past 24 passwords.
        /// </summary>
        /// <param name="pw"></param>
        /// <returns></returns>
        public PasswordComplexity ComplexityRulesMet(ChangePassword cp)
        {
            var pw = cp.NewPassword;
            var checkPassword = new PasswordComplexity();
            // can't be in the last 24 passwords (PASSWORD-HISTORY)
            checkPassword.PasswordNotReused = IsPasswordInHistory(cp) ? false : true;
            checkPassword.PasswordLengthMet =
                pw.Length < PasswordLengthMin || pw.Length > PasswordLengthMax ? false : true;
            checkPassword.PasswordContainsNumbers = !Regex.IsMatch(pw, "[0-9].*[0-9]") ? false : true;
            checkPassword.PasswordContainsLower = !Regex.IsMatch(pw, "[a-z]") ? false : true;
            checkPassword.PasswordContainsUpper = !Regex.IsMatch(pw, "[A-Z]") ? false : true;
            checkPassword.PasswordContainsSpecial =
                !Regex.IsMatch(pw, "[*.!@$%^&(){}\\[\\]:;<>,.?/~_+\\-=|]") ? false : true;
            checkPassword.PasswordLengthMin = PasswordLengthMin;
            checkPassword.PasswordLengthMax = PasswordLengthMax;
            checkPassword.NumberOfHistoricalPasswords = NumberOfHistoricalPasswords;

            return checkPassword;
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
    }
}
