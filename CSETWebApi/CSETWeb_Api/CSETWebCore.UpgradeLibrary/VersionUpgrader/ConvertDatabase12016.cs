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
    internal class ConvertDatabase12016 : ConvertSqlDatabase
    {
        public ConvertDatabase12016(string path) : base(path)
        {
            myVersion = new Version("12.0.1.6");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12015_to_12016.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12015_to_12016_data.sql"), conn);

                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.0.1.5 to 12.0.1.6: " + e.Message);
            }
        }
    }
}