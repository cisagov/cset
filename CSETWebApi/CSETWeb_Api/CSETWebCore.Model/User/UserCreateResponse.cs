//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Contact
{
    public class UserCreateResponse
    {
        public int UserId { get; set; }
        public string PrimaryEmail { get; set; }
        public string TemporaryPassword { get; set; }
        public bool IsExisting { get; set; }
    }
}