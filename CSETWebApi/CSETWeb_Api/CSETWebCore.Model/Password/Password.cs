//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 


namespace CSETWebCore.Model.Password
{
    public class ChangePassword
    {
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public string PrimaryEmail { get; set; }
        public string AppName { get; set; }
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
        public string AppName { get; set; }
    }

    public class UserStatus
    {
        public string PrimaryEmail { get; set; }
        public int UserId { get; set; }
        public bool PasswordResetRequired { get; set; }
    }
}

