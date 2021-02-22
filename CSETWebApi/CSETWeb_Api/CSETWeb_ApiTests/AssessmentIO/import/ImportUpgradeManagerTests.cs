using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using CSETWeb_Api.BusinessLogic.AssessmentIO.import;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Tests
{
    [TestClass()]
    public class ImportUpgradeManagerTests
    {
        [TestMethod()]
        public void UpgradeTest()
        {
            ImportUpgradeManager manager = new ImportUpgradeManager();
            String json = File.ReadAllText("TestItems\\Sample90Json.txt");
            manager.Upgrade(json);
        }
    }
}