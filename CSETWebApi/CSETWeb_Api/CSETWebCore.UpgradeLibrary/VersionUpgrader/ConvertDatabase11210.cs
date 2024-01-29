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
    internal class ConvertDatabase11210 : ConvertSqlDatabase
    {
        public ConvertDatabase11210(string path) : base(path)
        {
            myVersion = new Version("11.2.1.0");
        }
        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\11200_to_11210.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\11200_to_11210_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 11.2.0.0 to 11.2.1.0: " + e.Message);
            }
        }
    }
}
