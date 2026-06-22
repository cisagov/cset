using System;
using System.Security.Cryptography;


namespace CSETAddUser
{
    internal class CreateUser
    {
        public const int SaltByteSize = 24;
        public const int HashByteSize = 20; // to match the size of the PBKDF2-HMAC-SHA-1 hash 
        public const int iterations = 1000;
        public USER EncryptPassword(USER user)
        {
            string hash;
            string salt;
            this.HashPassword(user.Password, out hash, out salt);
            user.Password = hash;
            user.Salt = salt;
            return user;
        }

        private void HashPassword(string password, out string hash, out string salt)
        {
            byte[] saltArray = new byte[SaltByteSize];
            RandomNumberGenerator rng = RandomNumberGenerator.Create();
            rng.GetBytes(saltArray);

            var hashArray = GetPbkdf2Bytes(password, saltArray, iterations, HashByteSize);

            hash = Convert.ToBase64String(hashArray);
            salt = Convert.ToBase64String(saltArray);
        }

        private byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes)
        {
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 10000, HashAlgorithmName.SHA512);
            pbkdf2.IterationCount = iterations;
            return pbkdf2.GetBytes(outputBytes);
        }
    }
}
