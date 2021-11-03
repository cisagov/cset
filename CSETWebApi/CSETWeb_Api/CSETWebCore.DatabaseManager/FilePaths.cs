using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace CSETWebCore.DatabaseManager
{
    public class FilePaths
    {
        public FilePaths(string connectionString, string DbName)
        {
            ConnectionString = connectionString;   
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
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
                catch (SqlException sqle)
                {
                    Console.Write(sqle);
                }
            }
        }

        /// <summary>
        /// Tries to find the CSETWeb database and get its version.
        /// </summary>
        /// <returns></returns>
        public static Version GetInstalledCSETWebDbVersion(string masterConnectionString, string connectionStringCSET, string newDBName)
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

        private static Version GetDBVersion(SqlConnection conn)
        {
            DataTable versionTable = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT [Version_Id], [Cset_Version] FROM [CSET_VERSION]", conn);
            adapter.Fill(versionTable);

            var version = new Version(versionTable.Rows[0]["Cset_Version"].ToString());
            return version;
        }

        public string CSETMDF
        {
            get; set;
        }
        public string CSETLDF
        {
            get; set;
        }    
        public string ConnectionString 
        {
            get; set;
        }
    }
}
