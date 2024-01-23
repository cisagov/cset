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
    public class ConvertDatabase923 : ConvertSqlDatabase
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertDatabase923(string path) : base(path)
        {
            myVersion = new Version("9.2.3");
        }


        /// <summary>
        /// Runs the database update script to take 9.0.1 to 9.0.2.
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {

                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\922_to_923_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 9.2.2 file to 9.2.3: " + e.Message);
            }
        }
    }
}

