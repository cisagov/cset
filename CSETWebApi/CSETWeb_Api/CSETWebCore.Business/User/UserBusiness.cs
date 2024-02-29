//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.User
{
    public class UserBusiness : IUserBusiness
    {
        private CSETContext _context;
        private IPasswordHash _password;

        public UserBusiness(CSETContext context, IPasswordHash password)
        {
            _context = context;
            _password = password;
        }


        /// <summary>
        /// Creates a new USER record.  Generates a temporary password and 
        /// returns it as part of the response.  
        /// If a User already exists for the specified email, an exception is throw
        /// please check for existence before calling this if you do not intent 
        /// to create a user.
        /// </summary>
        /// <returns></returns>
        public UserCreateResponse CreateUser(UserDetail userDetail, CSETContext tmpContext)
        {
            // see if this user already exists
            UserDetail existingUser = this.GetUserDetail(userDetail.Email);
            if (existingUser != null)
            {
                // USER ALREADY EXISTS ... return what we already have
                // NO we better return an error so that someone cannot just overwrite the account
                // prompt them to recover the password if the account already exists
                throw new ApplicationException("This user already exists. To recover a password user the forgot password link on the login page.");
            }


            // create new records for USER and USER_DETAIL_INFORMATION
            var u = new USERS()
            {
                PrimaryEmail = userDetail.Email,
                FirstName = userDetail.FirstName,
                LastName = userDetail.LastName,
                IsSuperUser = false,
                PasswordResetRequired = true,
                IsActive = true
            };

            // default the new user to NOT active if CSET Online is running in beta mode
            if (new CSETGlobalProperties(_context).GetBoolProperty("IsCsetOnlineBeta") ?? false)
            {
                u.IsActive = false;
            }

            tmpContext.USERS.Add(u);


            try
            {
                tmpContext.SaveChanges();
            }
            catch (Microsoft.EntityFrameworkCore.DbUpdateException ex)
            {
                Microsoft.Data.SqlClient.SqlException sqlException = (Microsoft.Data.SqlClient.SqlException)ex.InnerException;
                if (sqlException.Number != 2627)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"Exception thrown in UserBusiness.  sqlExceptionNumber = {sqlException.Number}");

                    throw;
                }
                NLog.LogManager.GetCurrentClassLogger().Error(ex);
                tmpContext.USERS.Remove(u);
            }

            string password = CreateTempPassword();

            new PasswordHash().HashPassword(password, out string hash, out string salt);

            // log the temp password to history
            var history = new PASSWORD_HISTORY()
            {
                Created = DateTime.UtcNow,
                UserId = u.UserId,
                Is_Temp = true,
                Password = hash,
                Salt = salt
            };
            _context.PASSWORD_HISTORY.Add(history);

            UserCreateResponse resp = new UserCreateResponse
            {
                UserId = u.UserId == 0 ? 1 : u.UserId,
                PrimaryEmail = u.PrimaryEmail,
                TemporaryPassword = password
            };

            return resp;
        }


        /// <summary>
        /// Note that for now we are limiting the number of questions to two.
        /// </summary>
        /// <param name="userid">THIS VALUE SHOULD NEVER COME FROM THE POST OR URL ONLY THE AUTHTOKEN</param>
        /// <param name="user"></param>
        public void UpdateUser(int userid, string PrimaryEmail, CreateUser user)
        {
            var dbuser = _context.USERS.Where(x => x.UserId == userid).FirstOrDefault();
            TinyMapper.Map(user, dbuser);
            var details = _context.USER_DETAIL_INFORMATION.Where(x => x.PrimaryEmail == PrimaryEmail).FirstOrDefault();
            if (details != null)
                TinyMapper.Map<CreateUser, USER_DETAIL_INFORMATION>(user, details);

            /**
             * Some things to think about
             * they have existing questions and are updating them
             * they don't have existing questions and are reusing and existing provided question
             * they are giving us a new custom question
             */

            // RKW - 9-May-2018 - Commenting out the question logic until we know if we are doing it or not
            #region Security Question Logic
            //List<int> processedQuestions = new List<int>();
            //Dictionary<int, USER_SECURITY_QUESTIONS> existingQuestions = (from a in db.USER_SECURITY_QUESTIONS
            //                                           join b in db.SECURITY_QUESTION on a.SecurityQuestionID equals b.SecurityQuestionId
            //                                           where a.UserId == userid
            //                                           select a
            //                                           ).ToDictionary(x => x.SecurityQuestionID, x => x);
            //USER_SECURITY_QUESTIONS question;
            //if(existingQuestions.TryGetValue(user.CustomQuestion.SecurityQuestionId, out question))
            //{
            //    question.SecurityAnswer = user.CustomQuestion.Answer;
            //    processedQuestions.Add(user.CustomQuestion.SecurityQuestionId);
            //}
            //else
            //{
            //    SECURITY_QUESTION sq= new SECURITY_QUESTION()
            //    {
            //        SecurityQuestion = user.CustomQuestion.SecurityQuestion,
            //        IsCustomQuestion = true
            //    };
            //    db.USER_SECURITY_QUESTIONS.Add(new USER_SECURITY_QUESTIONS()
            //    {
            //        SecurityAnswer = user.CustomQuestion.Answer,
            //        SECURITY_QUESTION = sq,
            //        UserId = userid
            //    });
            //    db.SECURITY_QUESTION.Add(sq);
            //}
            //if(existingQuestions.TryGetValue(user.SelectedQuestion.SecurityQuestionId,out question))
            //{
            //    question.SecurityAnswer = user.SelectedQuestion.Answer;
            //    processedQuestions.Add(user.SelectedQuestion.SecurityQuestionId);
            //}
            //else
            //{
            //    db.USER_SECURITY_QUESTIONS.Add(new USER_SECURITY_QUESTIONS()
            //    {
            //        SecurityQuestionID = user.SelectedQuestion.SecurityQuestionId,
            //        SecurityAnswer = user.SelectedQuestion.Answer,
            //        UserId = userid
            //    });
            //}
            ////remove all the others;
            //foreach(KeyValuePair<int,USER_SECURITY_QUESTIONS> pair in existingQuestions)
            //{
            //    if (!processedQuestions.Contains(pair.Key))
            //    {
            //        db.USER_SECURITY_QUESTIONS.Remove(pair.Value);
            //    }                        
            //}
            #endregion

            _context.SaveChanges();

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public UserDetail GetUserDetail(string email)
        {

            var result = _context.USERS.Where(x => x.PrimaryEmail == email).FirstOrDefault();

            if (result == null)
            {
                return null;
            }

            UserDetail u = new UserDetail
            {
                UserId = result.UserId,
                Email = result.PrimaryEmail,
                IsSuperUser = result.IsSuperUser,
                PasswordResetRequired = result.PasswordResetRequired,
                FirstName = result.FirstName,
                LastName = result.LastName,
                IsActive = result.IsActive
            };

            return u;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public CreateUser GetUserInfo(int? userId)
        {
            var user = _context.USERS.Where(x => x.UserId == userId).FirstOrDefault();

            //no chance we can't find the user
            if (user == null)
            {
                return null;
            }

            CreateUser cu = new CreateUser();
            TinyMapper.Bind<USERS, CreateUser>();
            TinyMapper.Map(user, cu);
            cu.ConfirmEmail = cu.PrimaryEmail;

            //we have a user do we have question?
            var question = _context.USER_SECURITY_QUESTIONS.Where(x => x.UserId == userId).FirstOrDefault();
            if (question != null)
            {
                cu.SecurityQuestion1 = question.SecurityQuestion1;
                cu.SecurityAnswer1 = question.SecurityAnswer1;
                cu.SecurityQuestion2 = question.SecurityQuestion2;
                cu.SecurityAnswer2 = question.SecurityAnswer2;
            }

            return cu;
        }

        public UserCreateResponse CheckUserExists(UserDetail userDetail)
        {
            UserDetail existingUser = this.GetUserDetail(userDetail.Email);
            UserCreateResponse resp = new UserCreateResponse();
            if (existingUser != null)
            {
                resp.IsExisting = true;
                resp.UserId = existingUser.UserId;
                resp.PrimaryEmail = userDetail.Email;
            }
            else
            {
                resp.IsExisting = false;
            }
            return resp;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public UserDetail GetUserDetail(int userId)
        {
            var user = _context.USERS.Where(x => x.UserId == userId).FirstOrDefault();

            if (user == null)
            {
                return null;
            }

            UserDetail ud = new UserDetail
            {
                UserId = user.UserId,
                Email = user.PrimaryEmail,
                FirstName = user.FirstName,
                LastName = user.LastName,
                IsSuperUser = user.IsSuperUser,
                PasswordResetRequired = user.PasswordResetRequired,
                IsActive = user.IsActive,
                PreventEncrypt = user.PreventEncrypt,
                CisaAssessorWorkflow = user.CisaAssessorWorkflow,
                Lang = user.Lang
            };

            return ud;

        }


        /// <summary>
        /// Inserts a number of characters randomly pulled from the choices string.
        /// </summary>
        public string InsertRandom(string s, string choices, int number)
        {
            for (int i = 1; i <= number; i++)
            {
                s = s.Insert(new Random().Next(1, s.Length), choices[new Random().Next(0, choices.Length)].ToString());
            }
            return s;
        }


        /// <summary>
        /// Generates a temporary password with some complexity.
        /// </summary>
        /// <returns></returns>
        public string CreateTempPassword()
        {
            // generate a temp password
            var password = UniqueIdGenerator.Instance.GetBase32UniqueId(10);

            // add complexity:  insert random lower case letter, digits and special character
            password = InsertRandom(password, "abcdefghijklmnopqrstuvwxyz", 1);
            password = InsertRandom(password, "0123456789", 2);
            password = InsertRandom(password, "*!@$%^&:;,.?/~_+-=|", 1);

            return password;
        }
    }
}