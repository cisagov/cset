using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.Malcolm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Malcolm.Tests
{
    [TestClass()]
    public class MalcomHttpClientTests
    {
        [TestMethod()]
        public async void getMalcomDataTest()
        {
            MalcomHttpClient malcomHttp = new MalcomHttpClient();
            string test = await malcomHttp.getMalcomData("127.0.0.1");
            Assert.IsNotNull(test);
            Console.WriteLine(test);
        }
    }
}