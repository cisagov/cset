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
    internal class ConvertDatabase12020 : ConvertSqlDatabase
    {
        public ConvertDatabase12020(string path) : base(path)
        {
            myVersion = new Version("12.0.2.0");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12019_to_12020.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12019_to_12020_data.sql"), conn);

                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.0.1.9 to 12.0.2.0: " + e.Message);
            }
        }
    }
}