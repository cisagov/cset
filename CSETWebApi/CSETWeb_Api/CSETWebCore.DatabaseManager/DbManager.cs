using System;
using System.IO;
using Microsoft.Data.SqlClient;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        public DbManager(string csetVersion)
        {
            CSETVersion = csetVersion;
            Exists = true;
            using (SqlConnection conn = new SqlConnection(@"data source=(LocalDB)\MSSQLLocalDB;Database=" + DatabaseCode + ";integrated security=True;connect timeout=180;MultipleActiveResultSets=True;App=CSET;"))
            {
                try
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
                    Exists = false;
                }
            }
        }

        public String CSETMDF
        { get; set; }
        public String CSETLDF
        { get; set; }
        public bool Exists { get; private set; }
        public string CSETVersion { get; private set; }
        public string DatabaseCode { get; set; } = "CSETWeb";
        public string ClientCode { get; set; } = "DHS";
        public string ApplicationCode { get; set; } = "CSET";

        public void setupDb()
        {
            string databaseFileName = DatabaseCode + ".mdf";
            string databaseLogFileName = DatabaseCode + "_log.ldf";

            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string csetDestDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, CSETVersion, "database", databaseFileName);
            string csetDestLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, CSETVersion, "database", databaseLogFileName);

            string masterConnectionString = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=180;MultipleActiveResultSets=True;";

            if (!Exists)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(masterConnectionString))
                    {
                        conn.Open();
                        SqlCommand cmd = conn.CreateCommand();

                        string fixDBNameCommand = "if exists(SELECT name \n" +
                        "FROM master..sysdatabases \n" +
                        "where name ='" + DatabaseCode + "') \n" +
                        "select * from " + DatabaseCode + ".dbo.CSET_VERSION \n" +
                        "else\n" +
                        "CREATE DATABASE " + DatabaseCode +
                            " ON(FILENAME = '" + csetDestDBFile + "'),  " +
                            " (FILENAME = '" + csetDestLogFile + "') FOR ATTACH; ";


                        cmd.CommandText = fixDBNameCommand;
                        cmd.ExecuteNonQuery();

                        conn.Close();
                        SqlConnection.ClearPool(conn);
                    }
                }
                catch (SqlException sql)
                {
                    Console.WriteLine(sql);
                }
            }
        }
    }
}
