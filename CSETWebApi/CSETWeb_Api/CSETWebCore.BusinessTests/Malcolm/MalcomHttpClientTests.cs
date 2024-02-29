using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CSETWebCore.Business.Malcolm.Tests
{
    [TestClass()]
    public class MalcomHttpClientTests
    {
        [TestMethod()]
        public void getMalcomDataTest()
        {
            Task.Run(() => TestMalcomHttpClient()).Wait();
        }

        private async void TestMalcomHttpClient()
        {
            MalcomHttpClient malcomHttp = new MalcomHttpClient();
            string test = await malcomHttp.getMalcomData("127.0.0.1");
            Assert.IsNotNull(test);
            Console.WriteLine(test);
        }
    }
}