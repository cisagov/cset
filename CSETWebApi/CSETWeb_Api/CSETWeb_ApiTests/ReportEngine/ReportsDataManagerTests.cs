using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.ReportEngine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.ReportEngine.Tests
{
    [TestClass()]
    public class ReportsDataManagerTests
    {
        [TestMethod()]
        public void getACETDeficiencesTest()
        {
            ReportsDataManager dataManager = new ReportsDataManager(2357);
            var stuff = dataManager.getACETDeficiences();
            Assert.IsTrue(stuff.Count > 0);
            
        }
    }
}