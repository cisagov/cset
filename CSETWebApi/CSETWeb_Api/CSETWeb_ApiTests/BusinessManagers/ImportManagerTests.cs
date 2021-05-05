//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using CSETWebCore.DataLayer;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Tests
{
    [TestClass()]
    public class ImportManagerTests
    {
        [TestMethod()]
        public void ProcessCSETAssessmentImportTest()
        {
            foreach (string file in Directory.EnumerateFiles(@"C:\Test", "*.csetw", SearchOption.AllDirectories))
            {
                try
                {  
                    ImportManager manager = new ImportManager();
                    manager.ProcessCSETAssessmentImport(File.ReadAllBytes(file), 15);
                }catch(Exception e)
                {
                    Console.Write(e);
                }
            }
        }

        [TestMethod()]
        public void LaunchLegacyCSETProcessTest()
        {
            Assert.Fail();
        }
    }
}

