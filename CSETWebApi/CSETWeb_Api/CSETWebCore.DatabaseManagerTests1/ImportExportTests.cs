using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.DatabaseManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using CSETWebCore.DataLayer.Model;
using System.Net;
using log4net;
using Microsoft.Data.SqlClient;
using System.Data;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Diagnostics;
using UpgradeLibrary.Upgrade;

namespace CSETWebCore.DatabaseManager.Tests
{
    [TestClass()]
    public class ImportExportTests
    {
        [TestMethod()]
        public void ImportAllAssessmentsTest()
        {   
            string clientCode = "DHS";
            string appCode = "CSET";
            DbManager manager = new DbManager(new Version("12.0.0.16"),clientCode, appCode);
            //TODO finish this.
            //manager.CopyDBAcrossServers();
        }

        [TestMethod()]
        public void ExportAllAssessmentsTest()
        {
            //setup a copy file
            //setup a destination file
            string clientCode = "DHS";
            string appCode = "CSET";
            DbManager manager = new DbManager(new Version("12.0.0.16"), clientCode, appCode);
            //run the same test twice and make sure that the number increment works
            string mdf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWebTest.mdf";
            string ldf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWebTest_log.ldf";
            manager.CopyDBFromInstallationSource(mdf,ldf);
            manager.CopyDBFromInstallationSource(mdf, ldf);
            manager.CopyDBFromInstallationSource(mdf, ldf);
            manager.CopyDBFromInstallationSource(mdf, ldf);
        }

    }
}