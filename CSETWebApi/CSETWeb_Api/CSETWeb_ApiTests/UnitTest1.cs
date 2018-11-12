//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CSETWeb_ApiTests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            //set the hostname and port to the same as the new base return the new uri
            UriBuilder tmp = new UriBuilder("https://csetac.inl.gov:8080/");
            tmp.Port = -1;
            var clean = tmp.ToString();
            

            Console.WriteLine(tmp.ToString());

        }
    }
}


