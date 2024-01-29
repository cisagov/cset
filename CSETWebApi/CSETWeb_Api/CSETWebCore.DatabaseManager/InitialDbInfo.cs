//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using Microsoft.Data.SqlClient;
using static CSETWebCore.Constants.Constants;

namespace CSETWebCore.DatabaseManager
{
    public class InitialDbInfo
    {
        /// <summary>
        /// Provides information about the existence of a database on a given sql connection
        /// </summary>
        /// <param name="connectionString"></param>
        /// <param name="databaseCode"></param>
        public InitialDbInfo(string connectionString, string databaseCode)
        {
            MasterConnectionString = Regex.Replace(connectionString, "initial catalog=.*;", "initial catalog=Master");
            ConnectionString = connectionString;
            DatabaseCode = databaseCode;
            Exists = true;

            try
            {
                using (SqlConnection conn = new SqlConnection(MasterConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "SELECT type_desc AS FileType, Physical_Name AS Location FROM sys.master_files mf INNER JOIN sys.databases db ON db.database_id = mf.database_id where db.name = '" + DatabaseCode + "'";

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        var type = reader.GetString(0);
                        var path = reader.GetString(1);
                        switch (type)
                        {
                            case "ROWS":
                                MDF = path;
                                break;
                            case "LOG":
                                LDF = path;
                                break;
                        }
                    }

                    reader.Close();

                    if (MDF == null || LDF == null)
                    {
                        Exists = false;
                    }
                    else if (!File.Exists(MDF) || !File.Exists(LDF))
                    {
                        cmd.CommandText = "EXEC sp_detach_db '" + DatabaseCode + "', 'true'";
                        cmd.ExecuteNonQuery();
                        Exists = false;
                    }
                }

            }
            catch (SqlException)
            {
                // We are only concerned here if SQL LocalDb 2022 (uses localdb2022_ConnectionString) is not accessible
                // (2012 & 2019 might not be installed, and that's ok--just assume the db does not exist)
                if (connectionString.Contains(LOCALDB_2022_CUSTOM_INSTANCE_NAME))
                {
                    throw;
                }

                Exists = false;
            }
        }

        /// <summary>
        /// Tries to find the web database and get its version.
        /// </summary>
        /// <returns></returns>
        public Version GetInstalledDBVersion()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "SELECT name FROM master..sysdatabases where name ='" + DatabaseCode + "'";
                    SqlDataReader reader = cmd.ExecuteReader();
                    // If CSETWeb database does not exist return null
                    if (!reader.HasRows)
                    {
                        return null;
                    }
                }

                string newConnectionString = ConnectionString.Replace("Master", DatabaseCode);

                using (SqlConnection conn = new SqlConnection(newConnectionString))
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

        private Version GetDBVersion(SqlConnection conn)
        {
            DataTable versionTable = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT [Version_Id], [Cset_Version] FROM [CSET_VERSION]", conn);
            adapter.Fill(versionTable);

            var version = new Version(versionTable.Rows[0]["Cset_Version"].ToString());
            return version;
        }

        public string MDF { get; }
        public string LDF { get; }
        public string MasterConnectionString { get; }
        public string ConnectionString { get; }
        public string DatabaseCode { get; }
        public bool Exists { get; }
    }
}
