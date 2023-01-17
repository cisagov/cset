using System;
using Microsoft.Data.SqlClient;
using System.IO;
namespace UpgradeLibrary.Upgrade
{
    internal class ConvertDatabase120018 : ConvertSqlDatabase
    {
        public ConvertDatabase120018(string path) : base(path)
        {
            myVersion = new Version("12.0.0.18");
        }

        /// <summary>
        /// Runs the database update script
        /// </summary>
        /// <param name="conn"></param>
        public override void Execute(SqlConnection conn)
        {
            try
            {
                this.UpgradeToVersionLocalDB(conn, myVersion);
            }
            catch (Exception e)
            {
                throw new DatabaseUpgradeException("Error in upgrading database version 12.0.0.17 to 12.0.0.18: " + e.Message);
            }
        }
    }
}