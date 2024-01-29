//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Runtime.InteropServices;
using System.Security;
using System.Text;

namespace CSETWebCore.CryptoBuffer
{
    public class ColumnSetEncryption
    {
        private String Password;
        private string Salt;

        public ColumnSetEncryption(String password, String salt)
        {
            this.Password = password;
            this.Salt = salt;
        }



        public String Encrypt(String value)
        {
            String pass = Password;
            EncryptionBuffer encBuffer = new EncryptionBuffer(pass, Salt, SymmetricCryptoAlgorithm.AES_192_CBC);
            encBuffer.AddData(Encoding.Unicode.GetBytes(value), true);
            return Convert.ToBase64String(encBuffer.GetData());
        }


        public string Decrypt(string cypherText)
        {
            String pass = Password;
            DecryptionBuffer decBuffer = new DecryptionBuffer(pass, Salt, SymmetricCryptoAlgorithm.AES_192_CBC);
            if (cypherText.Contains(" "))
                return cypherText;
            decBuffer.AddData(Convert.FromBase64String(cypherText), true);
            byte[] decryptedBytes = decBuffer.GetData();
            return Encoding.Unicode.GetString(decryptedBytes);
        }
        public string convertToUNSecureString(SecureString secstrPassword)
        {
            IntPtr unmanagedString = IntPtr.Zero;
            try
            {
                unmanagedString = Marshal.SecureStringToGlobalAllocUnicode(secstrPassword);
                return Marshal.PtrToStringUni(unmanagedString);
            }
            finally
            {
                Marshal.ZeroFreeGlobalAllocUnicode(unmanagedString);
            }
        }
    }
}