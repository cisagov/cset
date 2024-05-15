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
    internal class ConvertDatabase12180 : ConvertSqlDatabase
    {
        public ConvertDatabase12180(string path) : base(path)
        {
            myVersion = new Version("12.1.8.0");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>F
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12170_to_12180.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12170_to_12180_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.1.7.0 to 12.1.8.0: " + e.Message);
            }
        }
    }
}