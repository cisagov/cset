////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System;
using System.Security.Cryptography;
using CSETWebCore.Helpers;

namespace CSETWebCore.Business.Tests.Helpers
{
    /// <summary>
    /// Unit tests for <see cref="PasswordHash"/>.
    ///
    /// These tests pin two things that must both hold after raising the PBKDF2
    /// work factor:
    ///   1. New hashes use the stronger, OWASP-aligned iteration count.
    ///   2. Password hashes created with the previous 1,000-iteration, bare-Base64
    ///      format continue to validate, so existing users are not locked out and
    ///      no database migration is required.
    /// </summary>
    public class PasswordHashTests
    {
        private const string Password = "Corr3ct-Horse-Battery-Staple!";

        [Fact]
        public void HashPassword_ThenValidate_Succeeds()
        {
            var pw = new PasswordHash();
            pw.HashPassword(Password, out string hash, out string salt);

            Assert.True(pw.ValidatePassword(Password, hash, salt));
        }

        [Fact]
        public void HashPassword_UsesVersionedFormat_WithCurrentIterationCount()
        {
            var pw = new PasswordHash();
            pw.HashPassword(Password, out string hash, out _);

            // Format is "$<iterations>$<base64>"
            string[] parts = hash.Split('$');
            Assert.Equal(3, parts.Length);
            Assert.Equal(string.Empty, parts[0]);
            Assert.Equal(PasswordHash.iterations, int.Parse(parts[1]));
            Assert.False(string.IsNullOrEmpty(parts[2]));
        }

        [Fact]
        public void ValidatePassword_WrongPassword_Fails()
        {
            var pw = new PasswordHash();
            pw.HashPassword(Password, out string hash, out string salt);

            Assert.False(pw.ValidatePassword(Password + "x", hash, salt));
        }

        [Fact]
        public void ValidatePassword_LegacyUnversionedHash_StillValidates()
        {
            // Reproduce a hash exactly as the previous implementation stored it:
            // bare Base64, 1,000 iterations, PBKDF2-HMAC-SHA512, 20-byte output,
            // 24-byte salt.
            byte[] saltBytes = new byte[PasswordHash.SaltByteSize];
            RandomNumberGenerator.Fill(saltBytes);

            byte[] legacyHashBytes = Rfc2898DeriveBytes.Pbkdf2(
                Password, saltBytes, 1000, HashAlgorithmName.SHA512, PasswordHash.HashByteSize);

            string legacyHash = Convert.ToBase64String(legacyHashBytes); // no "$1000$" prefix
            string salt = Convert.ToBase64String(saltBytes);

            var pw = new PasswordHash();
            Assert.True(pw.ValidatePassword(Password, legacyHash, salt));
            Assert.False(pw.ValidatePassword("not-the-password", legacyHash, salt));
        }

        [Fact]
        public void NeedsUpgrade_TrueForLegacy_FalseForNew()
        {
            byte[] saltBytes = new byte[PasswordHash.SaltByteSize];
            RandomNumberGenerator.Fill(saltBytes);
            byte[] legacyHashBytes = Rfc2898DeriveBytes.Pbkdf2(
                Password, saltBytes, 1000, HashAlgorithmName.SHA512, PasswordHash.HashByteSize);
            string legacyHash = Convert.ToBase64String(legacyHashBytes);

            var pw = new PasswordHash();
            pw.HashPassword(Password, out string newHash, out _);

            Assert.True(pw.NeedsUpgrade(legacyHash));
            Assert.False(pw.NeedsUpgrade(newHash));
        }

        [Theory]
        [InlineData("")]
        [InlineData("   ")]
        [InlineData(null)]
        public void ValidatePassword_BlankInputs_ReturnFalse(string blank)
        {
            var pw = new PasswordHash();
            pw.HashPassword(Password, out string hash, out string salt);

            Assert.False(pw.ValidatePassword(blank, hash, salt));
            Assert.False(pw.ValidatePassword(Password, blank, salt));
            Assert.False(pw.ValidatePassword(Password, hash, blank));
        }

        [Theory]
        [InlineData("$$abc")]              // empty iteration segment
        [InlineData("$notanumber$abc")]    // non-numeric iterations
        [InlineData("$210000$")]           // missing hash segment
        [InlineData("$-5$abcd")]           // non-positive iterations
        [InlineData("not-valid-base64!!")] // legacy segment that is not Base64
        public void ValidatePassword_MalformedHash_ReturnsFalseAndDoesNotThrow(string malformed)
        {
            var pw = new PasswordHash();
            pw.HashPassword(Password, out _, out string salt);

            bool result = pw.ValidatePassword(Password, malformed, salt);
            Assert.False(result);
        }
    }
}
