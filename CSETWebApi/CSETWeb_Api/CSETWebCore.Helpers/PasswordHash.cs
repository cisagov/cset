////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System;
using System.Security.Cryptography;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Helpers
{
    public class PasswordHash : IPasswordHash
    {
        public const int SaltByteSize = 24;
        public const int HashByteSize = 20; // to match the size of the PBKDF2-HMAC-SHA-1 hash

        /// <summary>
        /// PBKDF2 work factor used when creating new password hashes.
        ///
        /// 210,000 is the OWASP-recommended minimum for PBKDF2-HMAC-SHA512
        /// (OWASP Password Storage Cheat Sheet, 2023). The previous value of
        /// 1,000 iterations offered almost no protection against offline
        /// brute-force / GPU cracking of a leaked USERS table.
        ///
        /// Existing hashes were created with <see cref="LegacyIterations"/> and
        /// stored as a bare Base64 string with no embedded work factor. To stay
        /// backward compatible without a database migration, new hashes are
        /// stored in a self-describing format ("$&lt;iterations&gt;$&lt;base64&gt;")
        /// and <see cref="ValidatePassword"/> reads the work factor from the
        /// stored value, defaulting to <see cref="LegacyIterations"/> for hashes
        /// that predate this format.
        /// </summary>
        public const int iterations = 210000;

        /// <summary>
        /// Work factor used by password hashes created before the versioned
        /// hash format was introduced. Such hashes are stored as a bare Base64
        /// string with no "$iterations$" prefix.
        /// </summary>
        private const int LegacyIterations = 1000;

        /// <summary>
        /// Separator for the self-describing hash format "$&lt;iterations&gt;$&lt;base64&gt;".
        /// </summary>
        private const char HashSegmentSeparator = '$';

        private readonly char[] Punctuations = "!@#$%^&*()_-+=[{]};:>|./?".ToCharArray();

        /// <summary>
        /// This version is used if the salt and hash are supplied in a single string
        /// </summary>
        /// <param name="password"></param>
        /// <param name="hash"></param>
        /// <param name="salt"></param>
        /// <returns></returns>
        public bool ValidatePassword(string password, string hash, string salt)
        {
            if (string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(hash) || string.IsNullOrWhiteSpace(salt))
            {
                return false;
            }

            if (!TryParseStoredHash(hash, out int iterationCount, out byte[] hashArray))
            {
                return false;
            }

            byte[] saltArray;
            try
            {
                saltArray = Convert.FromBase64String(salt);
            }
            catch (FormatException)
            {
                return false;
            }

            var testHash = GetPbkdf2Bytes(password, saltArray, iterationCount, hashArray.Length);

            // Use a constant-time comparison to avoid leaking hash-match progress
            // through timing (the previous BitConverter/String.Equals compare was
            // not constant time).
            return CryptographicOperations.FixedTimeEquals(hashArray, testHash);
        }


        /// <summary>
        /// Creates a new hash.  The hash and its salt are returned in the hash and salt arguments.
        /// The returned hash is stored in the self-describing "$&lt;iterations&gt;$&lt;base64&gt;"
        /// format so its work factor can be raised again in the future without breaking
        /// verification of previously stored hashes.
        /// </summary>
        /// <param name="password"></param>
        /// <param name="hash"></param>
        /// <param name="salt"></param>
        public void HashPassword(string password, out string hash, out string salt)
        {
            byte[] saltArray = new byte[SaltByteSize];
            RandomNumberGenerator.Fill(saltArray);

            var hashArray = GetPbkdf2Bytes(password, saltArray, iterations, HashByteSize);

            hash = FormatHash(iterations, hashArray);
            salt = Convert.ToBase64String(saltArray);
        }

        /// <summary>
        /// Returns true when the supplied stored hash was created with a weaker work
        /// factor than the current <see cref="iterations"/> value (or uses the legacy
        /// unversioned format). Callers can use this to transparently re-hash a
        /// password with the stronger work factor after a successful login.
        /// </summary>
        public bool NeedsUpgrade(string hash)
        {
            if (!TryParseStoredHash(hash, out int iterationCount, out _))
            {
                return false;
            }

            return iterationCount < iterations;
        }

        public byte[] GetPbkdf2Bytes(string password, byte[] salt, int iterations, int outputBytes)
        {
            return Rfc2898DeriveBytes.Pbkdf2(password, salt, iterations, HashAlgorithmName.SHA512, outputBytes);
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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return null;
            }
        }

        /// <summary>
        /// Formats a raw hash and its work factor into the self-describing
        /// "$&lt;iterations&gt;$&lt;base64&gt;" storage format.
        /// </summary>
        private static string FormatHash(int iterationCount, byte[] hashBytes)
        {
            return $"{HashSegmentSeparator}{iterationCount}{HashSegmentSeparator}{Convert.ToBase64String(hashBytes)}";
        }

        /// <summary>
        /// Parses a stored hash value, extracting the PBKDF2 work factor and the raw
        /// hash bytes. Supports both the versioned "$&lt;iterations&gt;$&lt;base64&gt;"
        /// format and the legacy bare-Base64 format (assumed to use
        /// <see cref="LegacyIterations"/>). Returns false if the value cannot be parsed.
        /// </summary>
        private static bool TryParseStoredHash(string storedHash, out int iterationCount, out byte[] hashBytes)
        {
            iterationCount = LegacyIterations;
            hashBytes = null;

            string encodedHash = storedHash;

            if (storedHash.Length > 0 && storedHash[0] == HashSegmentSeparator)
            {
                // Expected shape: "$<iterations>$<base64>" -> ["", "<iterations>", "<base64>"]
                string[] parts = storedHash.Split(HashSegmentSeparator);
                if (parts.Length != 3
                    || !int.TryParse(parts[1], out iterationCount)
                    || iterationCount <= 0
                    || string.IsNullOrEmpty(parts[2]))
                {
                    return false;
                }

                encodedHash = parts[2];
            }

            try
            {
                hashBytes = Convert.FromBase64String(encodedHash);
            }
            catch (FormatException)
            {
                return false;
            }

            return hashBytes.Length > 0;
        }
    }
}
