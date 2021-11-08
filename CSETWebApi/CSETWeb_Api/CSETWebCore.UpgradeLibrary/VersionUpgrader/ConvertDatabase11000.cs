using System;
using Microsoft.Data.SqlClient;
using System.IO;
namespace UpgradeLibrary.Upgrade
{
    internal class ConvertDatabase11000: ConvertSqlDatabase
    {
        public ConvertDatabase11000(string path) : base(path)
        {
            myVersion = new Version("11.0.0.0");
        }
        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                //RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1034_to_1100_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception ex)
            {
                throw new DatabaseUpgradeException("Error in upgrading assessment version 10.3.1.4 to 11.0.0.0");
            }
        }
    }
}
