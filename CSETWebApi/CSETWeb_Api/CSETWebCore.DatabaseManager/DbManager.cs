using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using System.Data;
using UpgradeLibrary.Upgrade;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        private VersionUpgrader _upgrader = new VersionUpgrader(System.Reflection.Assembly.GetAssembly(typeof(DbManager)).Location);

        public DbManager(Version csetVersion)
        {
            NewCSETVersion = csetVersion;
            InstalledCSETVersion = GetInstalledCSETWebDbVersion();
            DbExists = true;
            if (IsLocalDb2019Installed())
            {
                LocalDb2019Installed = true;
                CurrentCSETConnectionString = @"data source=(LocalDB)\MSSQLLocalDB;Database=" + DatabaseCode + ";integrated security=True;connect timeout=5;MultipleActiveResultSets=True;App=CSET;";
                using (SqlConnection conn = new SqlConnection(CurrentCSETConnectionString))
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
                        DbExists = false;
                    }
                }
            }
            else
            {
                LocalDb2019Installed = false;
                DbExists = false;
            }
        }



        /// <summary>
        /// Attempts to attach fresh database after local install, or upgrade from previous version of CSET if already installed.
        /// </summary>
        public void SetupDb()
        {
            string databaseFileName = DatabaseCode + ".mdf";
            string databaseLogFileName = DatabaseCode + "_log.ldf";

            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string csetDestDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", databaseFileName);
            string csetDestLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", databaseLogFileName);
            
            if (LocalDb2019Installed && !DbExists)
            {
                // No previous version of CSET found
                if (InstalledCSETVersion == null)
                {
                    try
                    {
                        ResolveLocalDbVersion();
                        using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
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
                // Another version of CSET installed, copying and upgrading Database
                else
                { 
                    //TODO: Copy and upgrade older CSET DB
                }
                
            }
        }

        /// <summary>
        /// Executes series of commands (stop, delete, and start) using sqllocaldb command line utility to resolve engine versioning bug.
        /// </summary>
        private void ResolveLocalDbVersion()
        {
            var process = System.Diagnostics.Process.Start("CMD.exe", "/C sqllocaldb stop mssqllocaldb && sqllocaldb delete mssqllocaldb && sqllocaldb start mssqllocaldb");
            //TODO: Add logging
            process.WaitForExit(10000); // wait up to 10 seconds 
        }

        /// <summary>
        /// Tries to find the CSETWeb database from previous install and get its version.
        /// </summary>
        /// <returns>The version of already installed CSET application</returns>
        private Version GetInstalledCSETWebDbVersion()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(OldMasterConnectionString))
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

                using (SqlConnection conn = new SqlConnection(OldCSETConnectionString))
                {
                    conn.Open();
                    return GetDBVersion(conn);
                }
            }
            catch 
            {
                return null;
            }
        }

        /// <summary>
        /// Gets the installed version of CSET from its corresponding database
        /// </summary>
        /// <param name="conn">sql connection to retrieve CSET version from database</param>
        /// <returns>CSET version from db specified in connection string</returns>
        private Version GetDBVersion(SqlConnection conn)
        {
            DataTable versionTable = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT [Version_Id], [Cset_Version] FROM [CSET_VERSION]", conn);
            adapter.Fill(versionTable);

            var version = new Version(versionTable.Rows[0]["Cset_Version"].ToString());
            return version;
        }

        public static string EscapeString(String value)
        {
            return value.Replace("'", "''");
        }

        private static void ForceClose(SqlConnection conn, string dbName)
        {
            try
            {
                //connect to the database 
                //and restore the database to the current mdf and log files.
                String cmdForceClose =
                    "Use Master; \n"
                    + "DECLARE @SQL varchar(max) \n"
                    + "Declare @id int  \n"
                    + "select @id = DB_ID('" + EscapeString(dbName) + "') from Master..SysProcesses \n"
                    + "if (@id is not null)  \n"
                    + "begin \n"
                    + "	SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';' \n"
                    + "	FROM MASTER..SysProcesses \n"
                    + "	WHERE DBId = DB_ID('" + EscapeString(dbName) + "') AND SPId <> @@SPId \n"
                    + "--print @sql \n"
                    + "	EXEC(@SQL) \n"
                    + "EXEC sp_detach_db  @dbname = N'" + dbName + "'"
                    + "end  \n";
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = cmdForceClose;
                cmd.ExecuteNonQuery();
            }
            catch (SqlException sqle)
            {
                Console.WriteLine(sqle.Message);
            }
        }

        /// <summary>
        /// Checks registry for localdb 2019 (only works for Windows).
        /// </summary>
        /// <returns>true if localdb key is found in HKEY_LOCAL_MACHINE registry.</returns>
        private bool IsLocalDb2019Installed() 
        {
            foreach (var item in Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames())
            {

                var programName = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + item).GetValue("DisplayName");

                if (Equals(programName, "Microsoft SQL Server 2019 LocalDB "))
                {
                    return true;
                }
            }
            return false;
        }

        public String CSETMDF
        { get; set; }
        public String CSETLDF
        { get; set; }
        public bool DbExists { get; private set; }
        public bool LocalDb2019Installed { get; private set; }
        public Version NewCSETVersion { get; private set; }
        public Version InstalledCSETVersion { get; private set; }
        public string DatabaseCode { get; set; } = "CSETWeb";
        public string ClientCode { get; set; } = "DHS";
        public string ApplicationCode { get; set; } = "CSET";
        public string CurrentCSETConnectionString { get; private set; }
        public string OldCSETConnectionString { get; private set; } = @"data source=(localdb)\v11.0;initial catalog = CSETWeb;persist security info = True;Integrated Security = SSPI;connect timeout=5;MultipleActiveResultSets=True";
        public string CurrentMasterConnectionString { get; private set; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
        public string OldMasterConnectionString { get; private set; } = @"data source=(LocalDB)\v11.0;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";


    }
}
