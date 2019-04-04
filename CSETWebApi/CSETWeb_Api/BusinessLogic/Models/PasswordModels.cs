//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{

    public class ChangePassword
    {
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public string PrimaryEmail { get; set; }
    }

    public class SecurityQuestions
    {
        public string SecurityQuestion1 { get; set; }
        public string SecurityQuestion2 { get; set; }
    }

    public class PotentialQuestions
    {
        public int SecurityQuestionId { get; set; }
        public string SecurityQuestion { get; set; }
        public string Answer { get; set; }
    }

    public class SecurityQuestionAnswer
    {
        public string PrimaryEmail { get; set; }

        public string QuestionText { get; set; }
        public string AnswerText { get; set; }

        /// <summary>
        /// This must be explicitly sent by the front end because
        /// the user is not logged in, so there's no JWT at this point.
        /// </summary>
        public string AppCode { get; set; }
    }

    public class UserStatus
    {
        public string PrimaryEmail { get; set; }
        public int UserId { get; set; }
        public bool PasswordResetRequired { get; set; }
    }

    public class CreateUser
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public string saveEmail { get; set; }

        public string ConfirmEmail { get; set; }
        public int AssessmentRoleId { get; set; }
        public string SecurityQuestion1 { get; set; }
        public string SecurityQuestion2 { get; set; }
        public string SecurityAnswer1 { get; set; }
        public string SecurityAnswer2 { get; set; }

        /// <summary>
        /// This must be explicitly sent by the front end because
        /// the user is not logged in, so there's no JWT at this point.
        /// </summary>
        public string AppCode { get; set; }
    }
}


