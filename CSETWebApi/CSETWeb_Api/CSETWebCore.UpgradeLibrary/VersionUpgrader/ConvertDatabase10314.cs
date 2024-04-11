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
    internal class ConvertDatabase10314 : ConvertSqlDatabase
    {
        public ConvertDatabase10314(string path) : base(path)
        {
            myVersion = new Version("10.3.1.4");
        }
        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1033_to_1034_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 10.3.1.3 to 10.3.1.4: " + e.Message);
            }
        }
    }
}
