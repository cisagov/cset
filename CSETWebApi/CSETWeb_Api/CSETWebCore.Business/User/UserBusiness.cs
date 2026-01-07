//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using DocumentFormat.OpenXml.Spreadsheet;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;

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

            var roles = _context.ROLES.FirstOrDefault(x => x.RoleName == "USER");
            var userRole = new USER_ROLES()
            {
                UserId = u.UserId,
                RoleId = roles.RoleId
            };

            _context.PASSWORD_HISTORY.Add(history);
            _context.USER_ROLES.Add(userRole);

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
        //public void UpdateUser(int userid, string PrimaryEmail, CreateUser user)
        //{
        //    var dbuser = _context.USERS.Where(x => x.UserId == userid).FirstOrDefault();
        //    TinyMapper.Map(user, dbuser);
        //    var details = _context.USER_DETAIL_INFORMATION.Where(x => x.PrimaryEmail == PrimaryEmail).FirstOrDefault();
        //    if (details != null)
        //    {
        //        TinyMapper.Map<CreateUser, USER_DETAIL_INFORMATION>(user, details);
        //    }

        //    _context.SaveChanges();
        //}


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





        /// <summary>
        /// 
        /// </summary>
        /// <param name="userDetail"></param>
        /// <returns></returns>
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
                Encryption = user.Encryption,
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


        /// <summary>
        /// Returns a formatted "full name" for a user.
        /// </summary>
        /// <param name="u"></param>
        /// <returns></returns>
        public static string FullName(USERS u)
        {
            return $"{u.FirstName} {u.LastName}".Trim();
        }


        public bool CheckEmailIsAvailable(int userId, string proposedEmail)
        {
            // check that we aren't trying to use an existing email address
            if (_context.USERS.Any(x => x.PrimaryEmail == proposedEmail && x.UserId != userId))
            {
                return false;
            }

            return true;
        }


        /// <summary>
        /// Returns a role for specific user.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string GetRole(int? userId)
        {
            var userRole = _context.USER_ROLES.FirstOrDefault(x => x.UserId == userId);

            // give the user a basic role if one has not been created
            if (userRole == null)
            {
                userRole = new USER_ROLES() {
                     UserId = (int)userId,
                     RoleId = Constants.Constants.ROLE_USER
                };

                _context.USER_ROLES.Add(userRole);
                _context.SaveChanges();
            }

            var role = _context.ROLES
                .Where(r => r.RoleId == userRole.RoleId)
                .FirstOrDefault();

            return role.RoleName;
        }


        /// <summary>
        /// Returns all users in the database.
        /// </summary>
        /// <returns></returns>
        public List<UserRole> GetUsers()
        {
            var resp = (from u in _context.USERS
                        join ur in _context.USER_ROLES on u.UserId equals ur.UserId
                        join r in _context.ROLES on ur.RoleId equals r.RoleId
                        select new UserRole
                        {
                            FirstName = u.FirstName,
                            LastName = u.LastName,
                            PrimaryEmail = u.PrimaryEmail,
                            RoleName = r.RoleName,
                            RoleId = r.RoleId,
                            UserId = u.UserId
                        }).ToList();

            return resp;
        }


        /// <summary>
        /// Returns all available roles.
        /// </summary>
        /// <returns></returns>
        public List<ROLES> GetAvailableRoles()
        {
            var roles = _context.ROLES.Select(x => new ROLES
            {
                RoleName = x.RoleName,
                RoleId = x.RoleId
            }).ToList();
            return roles;
        }


        /// <summary>
        /// Updates role for specific user.
        /// </summary>
        /// <param name="userId"></param>
        /// /// <param name="roleId"></param>
        /// <returns></returns>
        public void UpdateRole(int roleId, int? userId)
        {
            var userRole = _context.USER_ROLES.FirstOrDefault(x => x.UserId == userId);
            userRole.RoleId = roleId;
            _context.USER_ROLES.Update(userRole);
            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="user"></param>
        public void UpdateCurrentUser(CreateUser user)
        {
            var dbUser = _context.USERS.Where(x => x.UserId == user.UserId).FirstOrDefault();
            if (dbUser == null)
            {
                throw new Exception("No user exists for the specified ID.");
            }

            // check that we aren't trying to use an existing email address
            if (_context.USERS.Any(x => x.PrimaryEmail == user.PrimaryEmail && x.UserId != user.UserId))
            {
                throw new Exception("Email address belongs to another user");
            }


            dbUser.FirstName = user.FirstName;
            dbUser.LastName = user.LastName;
            dbUser.PrimaryEmail = user.PrimaryEmail;


            // update my name and email address on any ASSESSMENT_CONTACTS
            var myACs = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == user.UserId).ToList();
            foreach (var ac in myACs)
            {
                ac.FirstName = user.FirstName;
                ac.LastName = user.LastName;
                ac.PrimaryEmail = user.PrimaryEmail;
            }


            // update security questions/answers
            var sq = _context.USER_SECURITY_QUESTIONS.Where(x => x.UserId == user.UserId).FirstOrDefault();
            if (sq == null)
            {
                sq = new USER_SECURITY_QUESTIONS
                {
                    UserId = user.UserId
                };
                _context.USER_SECURITY_QUESTIONS.Add(sq);
                _context.SaveChanges();
            }

            sq.SecurityQuestion1 = NullIfEmpty(user.SecurityQuestion1);
            sq.SecurityAnswer1 = NullIfEmpty(user.SecurityAnswer1);
            sq.SecurityQuestion2 = NullIfEmpty(user.SecurityQuestion2);
            sq.SecurityAnswer2 = NullIfEmpty(user.SecurityAnswer2);

            // don't store a question or answer without its partner
            if (sq.SecurityQuestion1 == null || sq.SecurityAnswer1 == null)
            {
                sq.SecurityQuestion1 = null;
                sq.SecurityAnswer1 = null;
            }
            if (sq.SecurityQuestion2 == null || sq.SecurityAnswer2 == null)
            {
                sq.SecurityQuestion2 = null;
                sq.SecurityAnswer2 = null;
            }

            // delete or add/update the record
            if (sq.SecurityQuestion1 != null || sq.SecurityQuestion2 != null)
            {
                _context.USER_SECURITY_QUESTIONS.Update(sq);
            }
            else
            {
                // both questions are null -- remove the record                                                
                _context.USER_SECURITY_QUESTIONS.Remove(sq);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Returns null if the target string is empty or just spaces.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private string NullIfEmpty(string s)
        {
            if (s != null && s.Trim().Length == 0)
            {
                return null;
            }

            return s;
        }
    }
}