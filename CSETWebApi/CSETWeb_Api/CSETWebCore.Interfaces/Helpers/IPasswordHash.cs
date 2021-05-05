namespace CSETWebCore.Interfaces.Helpers
{
    public interface IPasswordHash
    {
        bool ValidatePassword(string password, string hash, string salt);
        void HashPassword(string password, out string hash, out string salt);
        string GeneratePassword(int length, int numberOfNonAlphanumericCharacters);
        byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes);
    }
}