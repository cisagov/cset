//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.Helpers
{
    public class PasswordHash
    {
        public const int SaltByteSize = 24;
        public const int HashByteSize = 20; // to match the size of the PBKDF2-HMAC-SHA-1 hash 
        public const int iterations = 1000;


        /// <summary>
        /// This version is used if the salt and hash are supplied in a single string 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="correctHash"></param>
        /// <returns></returns>
        public static bool ValidatePassword(string password, string hash, string salt)
        {
            var hashArray = Convert.FromBase64String(hash);
            var saltArray = Convert.FromBase64String(salt);

            var testHash = GetPbkdf2Bytes(password, saltArray, iterations, hashArray.Length);

            return BitConverter.ToString(hashArray).Equals(BitConverter.ToString(testHash));
        }


        /// <summary>
        /// Creates a new hash.  The hash and its salt are returned in the hash and salt arguments.
        /// </summary>
        /// <param name="password"></param>
        /// <returns></returns>
        public static void HashPassword(string password, out string hash, out string salt)
        {
            var cryptoProvider = new RNGCryptoServiceProvider();
            byte[] saltArray = new byte[SaltByteSize];
            cryptoProvider.GetBytes(saltArray);

            var hashArray = GetPbkdf2Bytes(password, saltArray, iterations, HashByteSize);

            hash = Convert.ToBase64String(hashArray);
            salt = Convert.ToBase64String(saltArray);
        }


        private static byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes)
        {
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt);
            pbkdf2.IterationCount = iterations;
            return pbkdf2.GetBytes(outputBytes);
        }
    }
}

