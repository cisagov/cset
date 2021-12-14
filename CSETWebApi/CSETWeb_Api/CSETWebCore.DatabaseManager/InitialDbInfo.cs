using System;
using System.Data;
using System.IO;
using System.Reflection;
using log4net;
using Microsoft.Data.SqlClient;

namespace CSETWebCore.DatabaseManager
{
    public class InitialDbInfo
    {
        public InitialDbInfo(string connectionString, string DbName)
        {
            ConnectionString = connectionString;
            Exists = true;
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "SELECT type_desc AS FileType, Physical_Name AS Location FROM sys.master_files mf INNER JOIN sys.databases db ON db.database_id = mf.database_id where db.name = '" + DbName+"'";

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        var type = reader.GetString(0);
                        var path = reader.GetString(1);
                        switch (type)
                        {
                            case "ROWS":
                                CSETMDF = path;
                                break;
                            case "LOG":
                                CSETLDF = path;
                                break;
                        }
                    }
                }

                if (CSETMDF == null || CSETLDF == null)
                    Exists = false;
            }
            catch
            {
                Exists = false;
            }
        }

        /// <summary>
        /// Tries to find the CSETWeb database and get its version.
        /// </summary>
        /// <returns></returns>
        public static Version GetInstalledCSETWebDbVersion(string masterConnectionString, string connectionStringCSET, string newDBName)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(masterConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "SELECT name FROM master..sysdatabases where name ='" + newDBName + "'";
                    SqlDataReader reader = cmd.ExecuteReader();
                    // If CSETWeb database does not exist return null
                    if (!reader.HasRows)
                    {
                        return null;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionStringCSET))
                {
                    conn.Open();

                    Version v = GetDBVersion(conn);
                    return v;
                }
            }
            catch 
            {
                return null;
            }
            
        }

        private static Version GetDBVersion(SqlConnection conn)
        {
            DataTable versionTable = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT [Version_Id], [Cset_Version] FROM [CSET_VERSION]", conn);
            adapter.Fill(versionTable);

            var version = new Version(versionTable.Rows[0]["Cset_Version"].ToString());
            return version;
        }

        public static DirectoryInfo GetExecutingDirectory()
        {
            string path = Assembly.GetAssembly(typeof(DbManager)).Location;
            return new FileInfo(path).Directory;
        }

        public string CSETMDF { get; private set; }
        public string CSETLDF { get; private set; }    
        public string ConnectionString { get; private set; }
        public bool Exists { get; private set; }
    }
}
