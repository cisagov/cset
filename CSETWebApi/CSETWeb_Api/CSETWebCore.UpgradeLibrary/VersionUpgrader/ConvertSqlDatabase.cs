//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using Microsoft.Data.SqlClient;
using System.IO;
using System.Runtime.InteropServices;

namespace UpgradeLibrary.Upgrade
{
    public abstract class ConvertSqlDatabase : IConvertSqlDatabase
    {
        /// <summary>
        /// This version should be overridden in the constructor of all derived classes.
        /// </summary>
        protected Version myVersion = new Version("0.1");


        /// <summary>
        /// 
        /// </summary>
        protected string applicationPath;


        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertSqlDatabase(string path)
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                this.applicationPath = path;
            }
            else
                this.applicationPath = new FileInfo(path).Directory.FullName;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="conn"></param>
        public virtual void Execute(SqlConnection conn)
        {
            throw new Exception("This method must be overriden");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="file"></param>
        /// <param name="conn"></param>
        public virtual void RunFile(String file, SqlConnection conn)
        {
            String[] splits = new string[] { "\r\nGO", "\n\nGO", "\nGO\n", "\nGO" };
            String stringCommands = "";
            using (StreamReader sr = new StreamReader(file))
            {
                stringCommands = sr.ReadToEnd();
            }

            String[] commands = stringCommands.Split(splits, StringSplitOptions.None);


            SqlTransaction trans = conn.BeginTransaction(System.Data.IsolationLevel.ReadUncommitted);
            SqlCommand cmd = conn.CreateCommand();
            cmd.Transaction = trans;
            foreach (String scmd in commands)
            {
                if (!String.IsNullOrWhiteSpace(scmd))
                {
                    cmd.CommandText = scmd;
                    cmd.CommandTimeout = 120;
                    cmd.ExecuteNonQuery();
                }
            }
            cmd.Transaction.Commit();
        }

        /// <summary>
        /// This can upgrade aggregation or assessment to specific version.
        /// </summary>
        /// <param name="conn"></param>
        /// <param name="csetVersion"></param>
        public void UpgradeToVersionLocalDB(SqlConnection conn, Version csetVersion)
        {
            // RKW - convert version to decimal(18,4) for the Version_Id column......
            string upgradeCommand = string.Format("UPDATE CSET_VERSION SET Version_Id={0}, Cset_Version='{1}' WHERE Id = 1",
                CreateVersionId(csetVersion),
                csetVersion.ToString());

            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandText = upgradeCommand;
            cmd.ExecuteNonQuery();
        }

        public void UpgradeToVersionLocalDB(SqlConnection conn, Version csetVersion, String buildNumber)
        {
            string[] upgradeCommands = new string[] {
                "IF NOT EXISTS ( SELECT * FROM  sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[CSET_VERSION]') AND name = 'Build_Number')\n"+

                "ALTER TABLE[dbo].[CSET_VERSION] ADD [Build_Number] VARCHAR(500) NULL;",

                string.Format("UPDATE CSET_VERSION SET Version_Id={0}, Cset_Version='{1}', Build_Number='{2}' WHERE Id = 1",
                    CreateVersionId(csetVersion),
                    csetVersion.ToString(),
                    buildNumber)
            };
            foreach (String upgradeCommand in upgradeCommands)
            {
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = upgradeCommand;
                cmd.ExecuteNonQuery();
            }
        }



        /// <summary>
        /// Builds a decimal representation of the version number.
        /// </summary>
        /// <param name="v"></param>
        /// <returns></returns>
        public decimal CreateVersionId(Version v)
        {
            decimal major = v.Major;
            string parseString = "." + v.Minor.ToString("0") + (v.Build != -1 ? v.Build.ToString("0") : "") + (v.Revision != -1 ? v.Revision.ToString("0") : "");
            var decimalPortion = decimal.Parse(parseString);

            return major + decimalPortion;
        }
    }
}
