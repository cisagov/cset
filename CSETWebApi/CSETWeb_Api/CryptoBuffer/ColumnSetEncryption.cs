//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security;
using System.Text;
using System.Threading.Tasks;

namespace CryptoBuffer
{
    /// <summary>
    /// A convenience class for encrypting an entityframework list of object and columns
    /// 
    /// instantiate an encryptor, with password, salt
    /// then call encrypt for decrypt for each individual piece. 
    /// 
    /// </summary>
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


