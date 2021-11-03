using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using System.Data;
using UpgradeLibrary.Upgrade;
using System.Linq;
using log4net;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        private VersionUpgrader upgrader = new VersionUpgrader(System.Reflection.Assembly.GetAssembly(typeof(DbManager)).Location);
        private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public DbManager(Version csetVersion)
        {
            NewCSETVersion = csetVersion;
        }

        /// <summary>
        /// Attempts to attach fresh database after local install, or upgrade from previous version of CSET if already installed.
        /// </summary>
        public void SetupDb()
        {
            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string csetDestDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", DatabaseFileName);
            string csetDestLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", DatabaseLogFileName);

            if (LocalDb2019Installed)
            {
                ResolveLocalDbVersion();
                // No previous version of CSET found
                if (InstalledCSETVersion == null)
                {
                    ExecuteNonQuery(
                        "IF NOT EXISTS(SELECT name \n" +
                            "CREATE DATABASE " + DatabaseCode +
                            " ON(FILENAME = '" + csetDestDBFile + "'),  " +
                            " (FILENAME = '" + csetDestLogFile + "') FOR ATTACH; ",
                        CurrentMasterConnectionString);

                    // Verify that the database exists now
                    using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                    { 
                        if (ExistsCSETWebDatabase(conn))
                        {
                            Console.WriteLine("New CSET database is functioning");
                            log.Info("New CSET database is functioning");
                        }
                        else
                        {
                            Console.WriteLine("Error: database is not fuctioning");
                            log.Info("Error: database is not fuctioning");
                        }
                    }
                }
                // Another version of CSET installed, copying and upgrading Database
                else
                {
                    CopyDbAcrossServers(OldMasterConnectionString, CurrentMasterConnectionString);

                    string newInstallPath = Path.GetDirectoryName(csetDestDBFile);
                    Directory.CreateDirectory(newInstallPath);

                    upgrader.ApplyVersionUpgradesToDatabase(
                            new Version(NewCSETVersion.ToString()),
                            newInstallPath,
                            CurrentCSETConnectionString);
                    upgrader.UpgradeOnly(InstalledCSETVersion, CurrentCSETConnectionString);

                    // Verify that the database has been copied over and exists now
                    using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                    {
                        if (ExistsCSETWebDatabase(conn))
                        {
                            Console.WriteLine("Copied CSET Database is functioning");
                            log.Info("Copied CSET database is functioning");
                        }
                        else
                        {
                            Console.WriteLine("Error: database is not fuctioning after copy attempt");
                            log.Info("Error: database is not fuctioning after copy attempt");
                        }
                    }

                }
            }
            else 
            {
                log.Info("SQL Server LocalDB 2019 installation not found... database setup for CSET version" + NewCSETVersion + "incomplete.");
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

        public void CopyDbAcrossServers(string oldConnectionString, string newConnectionString)
        {
            //get the file paths
            FilePaths filePaths = new FilePaths(oldConnectionString, DatabaseCode);
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(OldMasterConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), "database", DatabaseLogFileName);

                //copy the files over
                File.Copy(filePaths.CSETMDF, newMDF, true);
                File.Copy(filePaths.CSETLDF, newLDF, true);

                //create and attach new 
                ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", newConnectionString);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                log.Error(e.Message);
            }
            finally
            {
                //reattach the original
                ExecuteNonQuery("EXEC sp_attach_db  @dbname = N'" + DatabaseCode + "', @FILENAME1 = '" + filePaths.CSETMDF + "', @FILENAME2 = '" + filePaths.CSETLDF + "'", oldConnectionString);
            }

        }

        public void UpdateVersionString(string connectionString, string newVersion)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    string decimalVersion = ReplaceLastOccurrence(newVersion, ".", "");
                    cmd.CommandText = "UPDATE [dbo].[CSET_VERSION] SET Version_Id = '" + decimalVersion + "',[Cset_Version] = '" + newVersion + "'";
                    cmd.ExecuteNonQuery();
                }
                catch (SqlException sqle)
                {
                    Console.Write(sqle.Message);
                    log.Error(sqle.Message);
                }
            }
        }

        public static string EscapeString(String value)
        {
            return value.Replace("'", "''");
        }

        public void ForceCloseAndDetach(string masterConnectionString, string dbName)
        {
            using (SqlConnection conn = new SqlConnection(masterConnectionString))
            {
                ForceClose(conn, dbName);
                conn.Close();
            }
        }

        private static void ForceClose(SqlConnection conn, string dbName)
        {
            try
            {
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
                log.Error(sqle.Message);
            }
        }

        /// <summary>
        /// Connection should be open before calling me.
        /// </summary>
        /// <param name="conn"></param>
        /// <returns>True if CSET database exists on given connection; false otherwise</returns>
        public bool ExistsCSETWebDatabase(SqlConnection conn)
        {
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandText = "SELECT name \n" +
            "FROM master..sysdatabases \n" +
            "where name ='" + DatabaseCode + "'";
            SqlDataReader reader = cmd.ExecuteReader();

            return (reader.HasRows);
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

        private string ReplaceLastOccurrence(string Source, string Find, string Replace)
        {
            int Place = 0;
            String result = Source;
            while (result.Count(f => (f == '.')) > 1)
            {
                Place = result.LastIndexOf(Find);
                result = result.Remove(Place, Find.Length).Insert(Place, Replace);
            }
            return result;
        }

        public void ExecuteNonQuery(string sql, string connectionString)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException sqle)
            {
                Console.WriteLine(sqle.Message);
                log.Error(sqle.Message);
            }
        }

        public bool LocalDb2019Installed 
        {
            get { return IsLocalDb2019Installed(); } 
        }
        public Version NewCSETVersion { get; private set; }
        public Version InstalledCSETVersion 
        {
            get { return FilePaths.GetInstalledCSETWebDbVersion(OldMasterConnectionString, CurrentCSETConnectionString, DatabaseCode); } 
        }
        public string DatabaseCode { get; private set; } = "CSETWeb";
        public string ClientCode { get; private set; } = "DHS";
        public string ApplicationCode { get; private set; } = "CSET";
        public string DatabaseFileName 
        {
            get { return DatabaseCode + ".mdf"; }
        }
        public string DatabaseLogFileName
        {
            get { return DatabaseCode + "_log.ldf"; }
        }
        public string CurrentCSETConnectionString { get; private set; }
        public string OldCSETConnectionString { get; private set; } = @"data source=(localdb)\v11.0;initial catalog = CSETWeb;persist security info = True;Integrated Security = SSPI;connect timeout=5;MultipleActiveResultSets=True";
        public string CurrentMasterConnectionString { get; private set; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
        public string OldMasterConnectionString { get; private set; } = @"data source=(LocalDB)\v11.0;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
    }
}
