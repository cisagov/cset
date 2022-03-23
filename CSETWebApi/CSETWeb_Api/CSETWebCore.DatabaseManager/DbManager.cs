using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using UpgradeLibrary.Upgrade;
using System.Linq;
using log4net;
using System.Reflection;
using System.Xml;
using CSETWebCore.DataLayer.Model;
using System.Security.Cryptography;
using System.Diagnostics;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        private static readonly string LOG_CONFIG_FILE = @"log4net.config";
        private static ILog log;
        private readonly VersionUpgrader upgrader = new VersionUpgrader(Assembly.GetAssembly(typeof(DbManager)).Location);

        public DbManager(Version version, string clientCode, string applicationCode)
        {
            NewVersion = version;
            ClientCode = clientCode;
            ApplicationCode = applicationCode;

            // Configure logging
            XmlDocument log4netConfig = new XmlDocument();
            log4netConfig.Load(File.OpenRead(LOG_CONFIG_FILE));

            var repo = LogManager.CreateRepository(
                Assembly.GetEntryAssembly(), typeof(log4net.Repository.Hierarchy.Hierarchy));

            log4net.Config.XmlConfigurator.Configure(repo, log4netConfig["log4net"]);
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        /// <summary>
        /// Attempts to attach fresh database after local install, or upgrade from previous version of application if already installed.
        /// </summary>
        public void SetupDb()
        {
            if (IsLocalDB2019Installed())
            {
                InitialDbInfo localDb2019Info = new InitialDbInfo(CurrentMasterConnectionString, DatabaseCode);
                InitialDbInfo localDb2012Info = new InitialDbInfo(OldMasterConnectionString, DatabaseCode);
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string destDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                string destLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                if (!localDb2019Info.Exists)
                {
                    log.Info($"No previous {ApplicationCode} database found on LocalDB 2019 default instance...");

                    // Create the new version folder in local app data folder
                    Directory.CreateDirectory(Path.GetDirectoryName(destDBFile));
                    ResolveLocalDBVersion();

                    // No previous version of application found on LocalDB 2012
                    if (!localDb2012Info.Exists)
                    {
                        log.Info($"No previous {ApplicationCode} database found on LocalDB 2012 default instance...");
                        log.Info($"Attaching new {ApplicationCode} {NewVersion} database from installation source...");

                        AttachCleanDatabase(destDBFile, destLogFile);

                        // Verify that the database exists now
                        using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                        {
                            if (DatabaseExists(conn))
                            {
                                log.Info($"New {ApplicationCode} database is functioning");
                            }
                            else
                            {
                                log.Error("Database is not functioning");
                            }
                        }
                    }
                    // Another version of application prior to 11.0.0.0 installed, copying and upgrading Database
                    else
                    {
                        log.Info($"{ApplicationCode} {localDb2012Info.GetInstalledDBVersion()} database detected on LocalDB 2012 default instance. Copying database file and attempting upgrade... ");

                        KillProcess();
                        CopyDBAcrossServers(OldMasterConnectionString, CurrentMasterConnectionString);

                        try
                        {
                            upgrader.UpgradeOnly(NewVersion, CurrentDatabaseConnectionString);
                        }
                        catch (Exception e)
                        {
                            log.Error(e.Message);
                            // Attach clean database here if something goes wrong with database upgrade
                            ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);
                            AttachCleanDatabase(destDBFile, destLogFile);
                        }

                        // Verify that the database has been copied over and exists now
                        using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                        {
                            if (DatabaseExists(conn))
                            {
                                log.Info($"Copied {ApplicationCode} database is functioning");
                            }
                            else
                            {
                                log.Error("Database is not functioning after copy attempt");
                            }
                        }
                    }
                }
                else if (localDb2019Info.Exists && localDb2019Info.GetInstalledDBVersion() < NewVersion)
                {
                    log.Info($"{ApplicationCode} {localDb2019Info.GetInstalledDBVersion()} database detected on LocalDB 2019 default instance. Copying database file and attempting upgrade...");

                    // Create the new version folder in local app data folder
                    Directory.CreateDirectory(Path.GetDirectoryName(destDBFile));

                    CopyDBWithinServer(CurrentMasterConnectionString);

                    try
                    {
                        upgrader.UpgradeOnly(NewVersion, CurrentDatabaseConnectionString);
                    }
                    catch (Exception e)
                    {
                        log.Error(e.Message);
                        // Attach clean database here if something goes wrong with database upgrade
                        ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);
                        AttachCleanDatabase(destDBFile, destLogFile);
                    }

                    // Verify that the database has been copied over and exists now
                    using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                    {
                        if (DatabaseExists(conn))
                        {
                            log.Info($"Copied {ApplicationCode} database is functioning");
                        }
                        else
                        {
                            log.Error("Database is not functioning after copy attempt");
                        }
                    }
                }
            }
            else
            {
                log.Info($"SQL Server LocalDB 2019 installation not found... {ApplicationCode} {NewVersion} database setup aborted");
            }
        }

        /// <summary>
        /// Executes series of commands (stop, delete, and start) using sqllocaldb command line utility to resolve engine versioning bug.
        /// </summary>
        private void ResolveLocalDBVersion()
        {
            log.Info("Deleting and recreating localDB MSSQLLocalDB default instance..");
            var process = System.Diagnostics.Process.Start("CMD.exe", "/C sqllocaldb stop mssqllocaldb && sqllocaldb delete mssqllocaldb && sqllocaldb start mssqllocaldb");
            process.WaitForExit(10000); // wait up to 10 seconds 
        }

        /// <summary>
        /// Copies database mdf and ldf files from older sql server version, places them in user local app data folder,
        /// and attaches them in the newer version of sql server.
        /// </summary>
        /// <param name="oldConnectionString">Connection string for older version of sql server</param>
        /// <param name="newConnectionString">Connection string for current version of sql server</param>
        private void CopyDBAcrossServers(string oldConnectionString, string newConnectionString)
        {
            //get the file paths
            InitialDbInfo dbInfo = new InitialDbInfo(oldConnectionString, DatabaseCode);
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(OldMasterConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                //copy the files over
                File.Copy(dbInfo.MDF, newMDF, true);
                File.Copy(dbInfo.LDF, newLDF, true);

                //create and attach new 
                ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", newConnectionString);
            }
            catch (Exception e)
            {
                log.Error(e.Message);
            }
            finally
            {
                //reattach the original
                ExecuteNonQuery("EXEC sp_attach_db  @dbname = N'" + DatabaseCode + "', @FILENAME1 = '" + dbInfo.MDF + "', @FILENAME2 = '" + dbInfo.LDF + "'", oldConnectionString);
            }

        }

        /// <summary>
        /// Copies existing mdf and ldf files attached on localdb 2019 server to newer version appdata folder and reattaches (preparing for upgrade)
        /// </summary>
        /// <param name="connectionString">Connection string for the current version of sql server</param>
        private void CopyDBWithinServer(string connectionString)
        {
            //get the file paths
            InitialDbInfo dbInfo = new InitialDbInfo(connectionString, DatabaseCode);
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                //copy the files over
                File.Copy(dbInfo.MDF, newMDF, true);
                File.Copy(dbInfo.LDF, newLDF, true);

                //create and attach new 
                ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", connectionString);

            }
            catch (Exception e)
            {
                log.Error(e.Message);
            }
        }

        /// <summary>
        /// Copies the clean database that comes with installation package to desired location.
        /// </summary>
        /// <param name="destDBFile">The new location to copy the mdf file to</param>
        /// <param name="destLogFile">The new location to copy the ldf file to</param>
        private void CopyDBFromInstallationSource(string destDBFile, string destLogFile)
        {
            string websitedataDir = "Data";
            string sourceDirPath = Path.Combine(InitialDbInfo.GetExecutingDirectory().FullName);
            string sourcePath = Path.Combine(sourceDirPath, websitedataDir, DatabaseFileName);
            string sourceLogPath = Path.Combine(sourceDirPath, websitedataDir, DatabaseLogFileName);

            log.Info("Copying clean database file from " + sourcePath + " to " + destDBFile);
            try
            {
                File.Copy(sourcePath, destDBFile, true);
                File.Copy(sourceLogPath, destLogFile, true);
            }
            catch (Exception e)
            {
                log.Info(e.Message);
            }
        }

        /// <summary>
        /// Copies clean database files from installation source to desired location and attaches
        /// to sql server designated in CurrentMasterConnectionString.
        /// </summary>
        /// <param name="destDBFile">The location of the mdf file used for the attach</param>
        /// <param name="destLogFile">The location of the ldf file used for the attach</param>
        private void AttachCleanDatabase(string destDBFile, string destLogFile) 
        {
            CopyDBFromInstallationSource(destDBFile, destLogFile);
            ExecuteNonQuery(
                "IF NOT EXISTS(SELECT name \n" +
                "FROM master..sysdatabases \n" +
                "where name ='" + DatabaseCode + "') \n" +
                    "CREATE DATABASE " + DatabaseCode +
                    " ON(FILENAME = '" + destDBFile + "'),  " +
                    " (FILENAME = '" + destLogFile + "') FOR ATTACH; ",
                CurrentMasterConnectionString);
        }

        private static string EscapeString(string value)
        {
            return value.Replace("'", "''");
        }

        private void ForceCloseAndDetach(string masterConnectionString, string dbName)
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
                string cmdForceClose =
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
                log.Error(sqle.Message);
            }
        }

        // Kill processes if duplicate process running under another version (used to use CSETTrayApp).    
        private void KillProcess()
        {
            try
            {
                foreach (Process proc in Process.GetProcessesByName("CSETTrayApp"))
                {
                    proc.Kill();
                }

                foreach (Process process in Process.GetProcessesByName("iisexpress"))
                {
                    process.Kill();
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
            }
        }

        /// <summary>
        /// Checks if databse with name of this.DatabaseCode exists on the given connection
        /// </summary>
        /// <param name="conn"></param>
        /// <returns>True if database with provided DatabaseCode exists on given connection; false otherwise</returns>
        private bool DatabaseExists(SqlConnection conn)
        {
            try
            {
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT name \n" +
                "FROM master..sysdatabases \n" +
                "where name ='" + DatabaseCode + "'";
                SqlDataReader reader = cmd.ExecuteReader();
                return (reader.HasRows);
            }
            catch
            {
                return false;
            }
        }


        /// <summary>
        /// Checks registry for localdb 2019 (only works for Windows).
        /// </summary>
        /// <returns>true if localdb key is found in HKEY_LOCAL_MACHINE registry.</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Interoperability", "CA1416:Validate platform compatibility", Justification = "<Pending>")]
        private bool IsLocalDB2019Installed()
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

        private void ExecuteNonQuery(string sql, string connectionString)
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
                log.Error(sqle.Message);
            }
        }
        public Version NewVersion { get; }
        public string ClientCode { get; }
        public string ApplicationCode { get; }
        public string CurrentMasterConnectionString { get; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=25;MultipleActiveResultSets=True;";
        public string OldMasterConnectionString { get; } = @"data source=(LocalDB)\v11.0;Database=Master;integrated security=True;connect timeout=25;MultipleActiveResultSets=True;";
        public string DatabaseCode 
        {
            get 
            {
                if (ApplicationCode.Equals("CSET"))
                {
                    return ApplicationCode + "Web";
                }
                else if (ApplicationCode.Equals("CSET-CYOTE"))
                {
                    return "CYOTEWeb";
                }
                else 
                {
                    return ClientCode + "Web";
                }
            }
        }
        public string CurrentDatabaseConnectionString 
        {
            get { return @"data source=(LocalDB)\MSSQLLocalDB;initial catalog=" + DatabaseCode + ";integrated security=True;connect timeout=25;MultipleActiveResultSets=True;"; }
        } 
        public string OldDatabaseConnectionString 
        { 
            get { return @"data source=(localdb)\v11.0;initial catalog=" + DatabaseCode + ";Integrated Security = SSPI;connect timeout=25;MultipleActiveResultSets=True"; }
        }
        public string DatabaseFileName
        {
            get { return DatabaseCode + ".mdf"; }
        }
        public string DatabaseLogFileName
        {
            get { return DatabaseCode + "_log.ldf"; }
        }
    }
}
