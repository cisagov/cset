//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Auth
{

    public class PasswordResponse
    {
        public int PasswordLengthMin { get; set; }
        public int PasswordLengthMax { get; set; }
        public int NumberOfHistoricalPasswords { get; set; }
        public bool PasswordLengthMet { get; set; }
        public bool PasswordContainsNumbers { get; set; }
        public bool PasswordContainsLower { get; set; }
        public bool PasswordContainsUpper { get; set; }
        public bool PasswordContainsSpecial { get; set; }
        public bool PasswordNotReused { get; set; }

        public bool IsValid { get; set; }
        public string Message { get; set; }
    }
}