//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.Helpers
{
    public interface IPasswordHash
    {
        bool ValidatePassword(string password, string hash, string salt);
        void HashPassword(string password, out string hash, out string salt);
        byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes);
        byte[] ConvertFromBase64String(string input);
    }
}