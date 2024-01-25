//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Security.Cryptography;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Creates a unique ID based on letters and numbers.  
    /// 0, 1, O and I are intentionally omitted giving 32 (2^5) symbols.
    /// 
    /// This code was inspired by:
    /// http://jopinblog.wordpress.com/2009/02/04/a-shorter-friendlier-guiduuid-in-net/
    /// </summary>
    public class UniqueIdGenerator
    {
        private static readonly UniqueIdGenerator _instance = new UniqueIdGenerator();
        private static char[] _charMap = {
            '2', '3', '4', '5', '6', '7', '8', '9',
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
            };

        /// <summary>
        /// Gets the one instance that exists for this class.
        /// </summary>
        public static UniqueIdGenerator Instance
        {
            get
            {
                return _instance;
            }
        }


        /// <summary>
        /// Private constructor.  Private so that the class will function as a singleton.  
        /// </summary>
        private UniqueIdGenerator()
        {
        }


        /// <summary>
        /// Fills the crypto service provider with a sequence of random values.
        /// </summary>
        /// <param name="bytes"></param>
        private void GetNext(byte[] bytes)
        {
            RandomNumberGenerator.Fill(bytes);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="numDigits"></param>
        /// <returns></returns>
        public string GetBase32UniqueId(int numDigits)
        {
            return GetBase32UniqueId(new byte[0], numDigits);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="basis"></param>
        /// <param name="numDigits"></param>
        /// <returns></returns>
        public string GetBase32UniqueId(byte[] basis, int numDigits)
        {
            string ret = null;

            int byteCount = 16;
            byte[] randBytes = new byte[byteCount - basis.Length];
            GetNext(randBytes);
            byte[] bytes = new byte[byteCount];
            Array.Copy(basis, 0, bytes, byteCount - basis.Length, basis.Length);
            Array.Copy(randBytes, 0, bytes, 0, randBytes.Length);

            ulong lo = (((ulong)BitConverter.ToUInt32(bytes, 8)) << 32) | BitConverter.ToUInt32(bytes, 12); // BitConverter.ToUInt64(bytes, 8);
            ulong hi = (((ulong)BitConverter.ToUInt32(bytes, 0)) << 32) | BitConverter.ToUInt32(bytes, 4);  // BitConverter.ToUInt64(bytes, 0);
            ulong mask = 0x1F;

            char[] chars = new char[26];
            int charIdx = 25;

            ulong work = lo;
            for (int i = 0; i < 26; i++)
            {
                if (i == 12)
                {
                    work = ((hi & 0x01) << 4) & lo;
                }
                else if (i == 13)
                {
                    work = hi >> 1;
                }
                byte digit = (byte)(work & mask);
                chars[charIdx] = _charMap[digit];
                charIdx--;
                work = work >> 5;
            }

            ret = new string(chars, 26 - numDigits, numDigits);

            return ret;
        }
    }
}

