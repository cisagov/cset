using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessManagers.Tests
{
    [TestClass()]
    public class AssessmentManagerTests
    {
        [TestMethod()]
        public void GetAssessmentsForUserTest()
        {
            AssessmentManager manager = new AssessmentManager();
            var list =  manager.GetAssessmentsForUser(1);
            Assert.IsTrue(list.Count() > 0);

        }
    }
}