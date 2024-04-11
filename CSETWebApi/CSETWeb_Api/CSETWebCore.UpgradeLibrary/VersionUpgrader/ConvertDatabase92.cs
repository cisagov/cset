//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using System.IO;

namespace UpgradeLibrary.Upgrade
{
    public class ConvertDatabase92 : ConvertSqlDatabase
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertDatabase92(string path) : base(path)
        {
            myVersion = new Version("9.2.0");
        }


        /// <summary>
        /// Runs the database update script to take 9.0.1 to 9.0.2.
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                // apply update scripts
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\901_to_920.sql"), conn);
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\901_to_920_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 9.0.1 to 9.2: " + e.Message);
            }
        }
    }
}

