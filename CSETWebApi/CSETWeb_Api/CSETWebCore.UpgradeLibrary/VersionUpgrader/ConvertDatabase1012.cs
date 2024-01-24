//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using Microsoft.Data.SqlClient;
using System.IO;

namespace UpgradeLibrary.Upgrade
{
    public class ConvertDatabase1012 : ConvertSqlDatabase
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertDatabase1012(string path) : base(path)
        {
            myVersion = new Version("10.1.2.0");
        }


        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012_answerTable.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012_data.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012_acet_answers.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012_data2.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1011_to_1012_data3.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 10.1.1.0 to 10.1.2.0: " + e.Message);
            }
        }
    }
}