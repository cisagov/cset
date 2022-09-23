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

namespace CSETWebCore.Helpers
{
    public class UserAccountSecurityManager
    {
        private readonly CSETContext _context;
        private readonly IUserBusiness _userBusiness;
        private readonly INotificationBusiness _notificationBusiness;

        private int passwordLengthMin = 8;
        private int passwordLengthMax = 25;

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
                UserCreateResponse userCreateResponse = _userBusiness.CreateUser(ud,_context);

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
                var history = new PASSWORD_HISTORY() { 
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
                var password = UniqueIdGenerator.Instance.GetBase32UniqueId(10);


#if DEBUG
                // set the password back to 'abc' for consistency/predictability when debugging
                if (user.PrimaryEmail == "a@b.com")
                {
                    password = "abc";
                }
#endif
                string hash;
                string salt;
                new PasswordHash().HashPassword(password, out hash, out salt);
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
        public bool ComplexityRulesMet(ChangePassword cp)
        {
            var pw = cp.NewPassword;


            // can't be in the last 24 passwords (PASSWORD-HISTORY)
            var user = _context.USERS.Where(x => x.PrimaryEmail == cp.PrimaryEmail).FirstOrDefault();
            if (user == null)
            {
                return false;
            }

            var listPasswordHistory = _context.PASSWORD_HISTORY.Where(x => x.UserId == user.UserId).OrderByDescending(y => y.Created).Take(24).ToList();
            var pwHash = new PasswordHash();
            foreach (var hist in listPasswordHistory)
            {
                var passwordFound = pwHash.ValidatePassword(pw, hist.Password, hist.Salt);
                if (passwordFound)
                {
                    return false;
                }
            }


            // length (8 to 25 characters)
            if (pw.Length < passwordLengthMin || pw.Length > passwordLengthMax)
            {
                return false;
            }

            // at least 2 numbers
            if (!Regex.IsMatch(pw, "[0-9].*[0-9]"))
            {
                return false;
            }

            // at least 1 lowercase letter
            if (!Regex.IsMatch(pw, "[a-z]"))
            {
                return false;
            }

            // at least 1 special character
            if (!Regex.IsMatch(pw, "[*.!@$%^&(){}\\[\\]:;<>,.?/~_+\\-=|]"))
            {
                return false;
            }



            return true;
        }
    }
}
