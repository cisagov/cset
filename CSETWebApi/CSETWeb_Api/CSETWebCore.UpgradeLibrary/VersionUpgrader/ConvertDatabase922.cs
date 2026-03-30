//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using Microsoft.Data.SqlClient;

namespace UpgradeLibrary.Upgrade
{
    public class ConvertDatabase922 : ConvertSqlDatabase
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        public ConvertDatabase922(string path) : base(path)
        {
            myVersion = new Version("9.2.2");
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
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 9.2.1 file to 9.2.2: " + e.Message);
            }
        }
    }
}

