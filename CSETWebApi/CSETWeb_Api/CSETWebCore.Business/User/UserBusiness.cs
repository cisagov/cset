using System;
using System.Linq;
using CSETWebCore.DataLayer;
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
        public UserCreateResponse CreateUser(UserDetail userDetail)
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


            // generate and hash a temporary password 
            string temporaryPassword = _password.GeneratePassword(10, 2);
            string hashedPassword;
            string salt;
            _password.HashPassword(temporaryPassword, out hashedPassword, out salt);


            // create new records for USER and USER_DETAIL_INFORMATION

            var u = new USERS()
            {
                PrimaryEmail = userDetail.Email,
                FirstName = userDetail.FirstName,
                LastName = userDetail.LastName,
                Password = hashedPassword,
                Salt = salt,
                IsSuperUser = false,
                PasswordResetRequired = true
            };
            _context.USERS.Add(u);
            _context.SaveChanges();

            UserCreateResponse resp = new UserCreateResponse
            {
                UserId = u.UserId == 0 ? 1 : u.UserId,
                PrimaryEmail = u.PrimaryEmail,
                TemporaryPassword = temporaryPassword
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
                PasswordResetRequired = result.PasswordResetRequired ?? true,
                FirstName = result.FirstName,
                LastName = result.LastName
            };

            return u;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public CreateUser GetUserInfo(int userId)
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
            using (var db = new CSETContext())
            {
                var user = db.USERS.Where(x => x.UserId == userId).FirstOrDefault();

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
                    PasswordResetRequired = user.PasswordResetRequired ?? true
                };

                return ud;
            }
        }
    }
}