using System;
using Microsoft.Data.SqlClient;
using System.IO;
namespace UpgradeLibrary.Upgrade
{
    internal class ConvertDatabase10313: ConvertSqlDatabase
    {
        public ConvertDatabase10313(string path) : base(path)
        {
            myVersion = new Version("10.3.1.3");
        }
        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                RunFile(Path.Combine(this.applicationPath, @"VersionUpgrader\SQL\1032_to_1033_data.sql"), conn);
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch
            {
                throw new DatabaseUpgradeException("Error in upgrading assessment version 10.3.1.2 to 10.3.1.3");
            }
        }
    }
}
