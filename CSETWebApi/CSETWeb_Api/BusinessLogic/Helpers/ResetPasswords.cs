//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic;
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWeb_Api.Helpers
{
    public class UserAccountSecurityManager
    {
        private CSET_Context db = new CSET_Context();

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
                UserManager um = new UserManager();
                UserDetail ud = new UserDetail()
                {
                    UserId = info.UserId,
                    Email = info.PrimaryEmail,
                    FirstName = info.FirstName,
                    LastName = info.LastName
                };
                UserCreateResponse userCreateResponse = um.CreateUser(ud);

                db.USER_SECURITY_QUESTIONS.Add(new USER_SECURITY_QUESTIONS()
                {
                    UserId = userCreateResponse.UserId,
                    SecurityQuestion1 = info.SecurityQuestion1,
                    SecurityQuestion2 = info.SecurityQuestion2,
                    SecurityAnswer1 = info.SecurityAnswer1,
                    SecurityAnswer2 = info.SecurityAnswer2
                });

                db.SaveChanges();
                
                // Send the new temp password to the user
                NotificationManager nm = new NotificationManager(info.AppCode);
                nm.SendPasswordEmail(userCreateResponse.PrimaryEmail, info.FirstName, info.LastName, userCreateResponse.TemporaryPassword);

                return true;
            }
            catch (ApplicationException app)
            {
                throw new CSETApplicationException("This account already exists. Please request a new password using the Forgot Password link if you have forgotten your password.", app);
            }
            catch (DbUpdateException due)
            {
                throw new CSETApplicationException("This account already exists. Please request a new password using the Forgot Password link if you have forgotten your password.", due);
            }
            catch (Exception e)
            {
                return false;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="changePass"></param>
        /// <returns></returns>
        public async Task<bool> ChangePassword(ChangePassword changePass)
        {
            try
            {
                var user = db.USERS.Where(x => x.PrimaryEmail == changePass.PrimaryEmail).FirstOrDefault();
                var info = db.USER_DETAIL_INFORMATION.Where(x => x.PrimaryEmail == user.PrimaryEmail).FirstOrDefault();
                
                //if(!PasswordHash.ValidatePassword(changePass.CurrentPassword, user.Password, user.Salt))
                //{
                //    return false;
                //}
                string hash;
                string salt;
                PasswordHash.HashPassword(changePass.NewPassword, out hash, out salt);
                user.Password = hash;
                user.Salt = salt;
                user.PasswordResetRequired = false;
                await db.SaveChangesAsync();
                return true;
            }
            catch (Exception e)
            {
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
        public async Task<bool> ResetPassword(string email, string subject, string appCode) {
            /**
             * get the user and make sure they exist
             * set the reset password flag
             * generate the new password
             * send the email 
             * return 
             */
            try
            {
                var user = db.USERS.Where(x => x.PrimaryEmail == email).FirstOrDefault();
//                var info = db.USER_DETAIL_INFORMATION.Where(x => x.PrimaryEmail == email).FirstOrDefault();

                user.PasswordResetRequired = true;
                String password = System.Web.Security.Membership.GeneratePassword(10, 1);
#if DEBUG
                // set the password back to 'abc' for consistency/predictability when debugging
                if (user.PrimaryEmail == "a@b.com")
                    password = "abc";
#endif
                string hash;
                string salt;
                PasswordHash.HashPassword(password, out hash,out salt);
                user.Password = hash;
                user.Salt = salt;


                NotificationManager nm = new NotificationManager(appCode);
                nm.SendPasswordResetEmail(user.PrimaryEmail, user.FirstName, user.LastName, password, subject);
                

                await db.SaveChangesAsync();
                return true;
            }catch(Exception e)
            {
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
                (from a in db.SECURITY_QUESTION
                select new PotentialQuestions()
                {
                    SecurityQuestion = a.SecurityQuestion,
                    SecurityQuestionId = a.SecurityQuestionId
                }).ToList<PotentialQuestions>();
            return questions;
        }
    }
}

