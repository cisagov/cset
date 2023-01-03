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
            string mdf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWeb.mdf";
            string ldf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWeb_log.ldf";
            string conString = "Server=(localdb)\\mssqllocaldb;Integrated Security=true;AttachDbFileName=" + mdf;
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();

                cmd.CommandText = "INSERT INTO [dbo].[ASSESSMENT_CONTACTS]\r\n           " +
                    "([Assessment_Id]\r\n\t\t    " +
                    ",[PrimaryEmail]\r\n           " +
                    ",[FirstName]\r\n           " +
                    ",[LastName]\r\n           " +
                    ",[Invited]\r\n           " +
                    ",[AssessmentRoleId]\r\n           " +
                    ",[UserId])\r\n" +
                    "select distinct e.* from assessment_contacts d right join (\r\n" +
                        "select a.assessment_id,c.* from assessments a, (\r\n" +
                        "SELECT \r\n       " +
                        "[PrimaryEmail]\r\n      " +
                        ",[FirstName]\r\n      " +
                        ",[LastName]\r\n      " +
                        ",[Invited]\r\n      " +
                        ",[AssessmentRoleId]\r\n      " +
                        ",[UserId]\t  \r\n  " +
                        "FROM [dbo].[ASSESSMENT_CONTACTS]\r\n  " +
                        "where assessment_contact_id = 31331\r\n" +
                    ") c ) e on d.assessment_id=e.assessment_id and d.userid = e.userid\r\n" +
                    "where d.assessment_id is null";

                cmd.CommandText = "select Assessment_Id from ASSESSMENTS where AssessmentCreatorId ;";
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.NextResult())
                {
                    Assert.IsNotNull(reader.GetString(2));
                }
                manager.CopyDBFromInstallationSource(mdf, ldf);
            }
        }

    }
}