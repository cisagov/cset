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
    internal class ConvertDatabase12001 : ConvertSqlDatabase
    {
        private string path;
        public ConvertDatabase12001(string path) : base(path)
        {
            myVersion = new Version("12.0.0.1");
            this.path = path;
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                Console.WriteLine("passed in path");
                Console.WriteLine(path);
                Console.WriteLine("application path");
                Console.WriteLine(this.applicationPath);
                if (String.IsNullOrWhiteSpace(this.applicationPath))
                {
                    this.applicationPath = path;
                }
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12000_to_12001.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, "VersionUpgrader", "SQL", "12000_to_12001_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.0.0.0 to 12.0.0.1: " + e.Message);
            }
        }
    }
}