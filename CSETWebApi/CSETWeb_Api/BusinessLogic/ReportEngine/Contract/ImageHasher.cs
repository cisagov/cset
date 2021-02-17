//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

namespace CSET_Main.ReportEngine.Contract
{
    public class ImageHasher
    {
        private static SHA1CryptoServiceProvider hasher = new SHA1CryptoServiceProvider();


        public static byte[] Hash(byte[] bytesToHash)
        {
            return hasher.ComputeHash(bytesToHash);
        }
    }
}


