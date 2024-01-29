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
    internal class ConvertDatabase12005 : ConvertSqlDatabase
    {
        public ConvertDatabase12005(string path) : base(path)
        {
            myVersion = new Version("12.0.0.5");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12004_to_12005.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12004_to_12005_data.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12004_to_12005_data2.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12004_to_12005_data3.sql"), conn);

                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.0.0.4 to 12.0.0.5: " + e.Message);
            }
        }
    }
}