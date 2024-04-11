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
    internal class ConvertDatabase12150 : ConvertSqlDatabase
    {
        public ConvertDatabase12150(string path) : base(path)
        {
            myVersion = new Version("12.1.5.0");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12140_to_12150.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12140_to_12150_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.1.4.0 to 12.1.5.0: " + e.Message);
            }
        }
    }
}