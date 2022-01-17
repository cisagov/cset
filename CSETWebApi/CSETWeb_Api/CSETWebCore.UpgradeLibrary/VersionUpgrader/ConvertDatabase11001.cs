using System;
using Microsoft.Data.SqlClient;
using System.IO;
namespace UpgradeLibrary.Upgrade
{
    internal class ConvertDatabase11001: ConvertSqlDatabase
    {
        public ConvertDatabase11001(string path) : base(path)
        {
            myVersion = new Version("11.0.0.1");
        }
        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1100_to_1101.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch
            {
                throw new DatabaseUpgradeException("Error in upgrading assessment version 11.0.0.0 to 11.0.0.1");
            }
        }
    }
}
