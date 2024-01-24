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
    public class ConvertDatabase1020 : ConvertSqlDatabase
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertDatabase1020(string path) : base(path)
        {
            myVersion = new Version("10.2.0.0");
        }


        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1012_to_1020.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1012_to_1020_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 10.1.2.0 to 10.2.0.0: " + e.Message);
            }
        }
    }
}