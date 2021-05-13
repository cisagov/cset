using System;
using System.Security.Cryptography;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Helpers
{
    public class PasswordHash : IPasswordHash
    {
        public const int SaltByteSize = 24;
        public const int HashByteSize = 20; // to match the size of the PBKDF2-HMAC-SHA-1 hash 
        public const int iterations = 1000;
        private readonly char[] Punctuations = "!@#$%^&*()_-+=[{]};:>|./?".ToCharArray();

        /// <summary>
        /// This version is used if the salt and hash are supplied in a single string 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="correctHash"></param>
        /// <returns></returns>
        public bool ValidatePassword(string password, string hash, string salt)
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
        public void HashPassword(string password, out string hash, out string salt)
        {
            var cryptoProvider = new RNGCryptoServiceProvider();
            byte[] saltArray = new byte[SaltByteSize];
            cryptoProvider.GetBytes(saltArray);

            var hashArray = GetPbkdf2Bytes(password, saltArray, iterations, HashByteSize);

            hash = Convert.ToBase64String(hashArray);
            salt = Convert.ToBase64String(saltArray);
        }

        public string GeneratePassword(int length, int numberOfNonAlphanumericCharacters)
        {
            if (length < 1 || length > 128)
            {
                throw new ArgumentException(nameof(length));
            }

            if (numberOfNonAlphanumericCharacters > length || numberOfNonAlphanumericCharacters < 0)
            {
                throw new ArgumentException(nameof(numberOfNonAlphanumericCharacters));
            }

            using (var rng = RandomNumberGenerator.Create())
            {
                var byteBuffer = new byte[length];

                rng.GetBytes(byteBuffer);

                var count = 0;
                var characterBuffer = new char[length];

                for (var iter = 0; iter < length; iter++)
                {
                    var i = byteBuffer[iter] % 87;

                    if (i < 10)
                    {
                        characterBuffer[iter] = (char) ('0' + i);
                    }
                    else if (i < 36)
                    {
                        characterBuffer[iter] = (char) ('A' + i - 10);
                    }
                    else if (i < 62)
                    {
                        characterBuffer[iter] = (char) ('a' + i - 36);
                    }
                    else
                    {
                        characterBuffer[iter] = Punctuations[i - 62];
                        count++;
                    }
                }

                if (count >= numberOfNonAlphanumericCharacters)
                {
                    return new string(characterBuffer);
                }

                int j;
                var rand = new Random();

                for (j = 0; j < numberOfNonAlphanumericCharacters - count; j++)
                {
                    int k;
                    do
                    {
                        k = rand.Next(0, length);
                    } while (!char.IsLetterOrDigit(characterBuffer[k]));

                    characterBuffer[k] = Punctuations[rand.Next(0, Punctuations.Length)];
                }

                return new string(characterBuffer);
            }
        }

        public byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes)
        {
            var pbkdf2 = new Rfc2898DeriveBytes(password, salt);
            pbkdf2.IterationCount = iterations;
            return pbkdf2.GetBytes(outputBytes);
        }

        public byte[] ConvertFromBase64String(string input)
        {
            if (String.IsNullOrWhiteSpace(input)) return null;
            try
            {
                string working = input.Replace('-', '+').Replace('_', '/'); ;
                while (working.Length % 4 != 0)
                {
                    working += '=';
                }
                return Convert.FromBase64String(working);
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}