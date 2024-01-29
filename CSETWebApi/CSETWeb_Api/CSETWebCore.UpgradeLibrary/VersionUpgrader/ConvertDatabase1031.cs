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
    internal class ConvertDatabase1031 : ConvertSqlDatabase
    {
        public ConvertDatabase1031(string path) : base(path)
        {
            myVersion = new Version("10.3.1.0");
        }


        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {

                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1030_to_1031_data.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1030_to_1031_data2.sql"), conn);

                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 10.3.0.0 to 10.3.1.0: " + e.Message);
            }
        }
    }
}