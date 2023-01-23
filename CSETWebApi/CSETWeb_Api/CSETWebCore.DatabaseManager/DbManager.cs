//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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
            try
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
                        // ResolveLocalDBVersion();

                        // No previous version of application found on LocalDB 2012
                        // NCUA wants to ignore older versions that use LocalDB 2012
                        if (ClientCode.Equals("NCUA") || !localDb2012Info.Exists)
                        {
                            CleanInstallNoUpgrades(destDBFile, destLogFile);
                        }
                        // Another version of application prior to 11.0.0.0 installed, copying and upgrading Database
                        else
                        {
                            UpgradeLocalDb2012To2019(destDBFile, destLogFile, localDb2012Info);
                        }
                    }
                    else if (localDb2019Info.Exists && localDb2019Info.GetInstalledDBVersion() < NewVersion)
                    {
                        UpgradeLocaldb2019(destDBFile, destLogFile, localDb2019Info);
                    }
                }
                else
                {
                    throw new DatabaseSetupException($"SQL Server LocalDB 2019 installation not found... {ApplicationCode} {NewVersion} database setup aborted");
                }
            }
            catch (DatabaseSetupException e)
            {
                log.Error(e.Message);
                throw;
            }
            catch (Exception e)
            {
                DatabaseSetupException dbSetupException = new DatabaseSetupException("A fatal error occurred during the database setup process: " + e.Message, e);
                log.Error(dbSetupException.Message);
                throw dbSetupException;
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
        /// Perform a clean attach of master versioned database.
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        private void CleanInstallNoUpgrades(string destDBFile, string destLogFile)
        {
            log.Info($"No previous {ApplicationCode} database found on LocalDB 2012 and 2019 default instances...");
            log.Info($"Attaching new {ApplicationCode} {NewVersion} database from installation source...");

            AttachCleanDatabase(destDBFile, destLogFile);

            // Verify that the database exists now
            VerifyApplicationDatabaseFunctioning();
        }


        /// <summary>
        /// Perform upgrade on a copy of existing application db found on localDb 2019.
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        /// <param name="localDb2019Info"></param>
        private void UpgradeLocaldb2019(string destDBFile, string destLogFile, InitialDbInfo localDb2019Info)
        {
            log.Info($"{ApplicationCode} {localDb2019Info.GetInstalledDBVersion()} database detected on LocalDB 2019 default instance. Copying database file and attempting upgrade...");

            // Create the new version folder in local app data folder
            Directory.CreateDirectory(Path.GetDirectoryName(destDBFile));

            CopyDBWithinServer(localDb2019Info);

            try
            {
                upgrader.UpgradeOnly(NewVersion, CurrentDatabaseConnectionString);
            }
            catch (DatabaseUpgradeException e)
            {
                log.Error(e.Message);
                // Attach clean database here if something goes wrong with database upgrade
                ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);
                AttachCleanDatabase(destDBFile, destLogFile);
            }

            // Verify that the database has been copied over and exists now
            VerifyApplicationDatabaseFunctioning();
        }

        /// <summary>
        /// Most complex case; make a copy of localDb 2012 db, attach copy to localDb2019 instance, and attempt upgrade.
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        /// <param name="localDb2012Info"></param>
        private void UpgradeLocalDb2012To2019(string destDBFile, string destLogFile, InitialDbInfo localDb2012Info)
        {
            log.Info($"{ApplicationCode} {localDb2012Info.GetInstalledDBVersion()} database detected on LocalDB 2012 default instance. Copying database files and attempting upgrade... ");

            KillProcess();
            CopyDBAcrossServers(localDb2012Info);

            try
            {
                upgrader.UpgradeOnly(NewVersion, CurrentDatabaseConnectionString);
            }
            catch (DatabaseUpgradeException e)
            {
                log.Error(e.Message);
                // Attach clean database here if something goes wrong with database upgrade
                ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);
                AttachCleanDatabase(destDBFile, destLogFile);
            }

            // Verify that the database has been copied over and exists now
            VerifyApplicationDatabaseFunctioning();
        }

        /// <summary>
        /// Wrapper for DatabaseExists function to include logging.
        /// </summary>
        private void VerifyApplicationDatabaseFunctioning()
        {
            using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
            {
                if (DatabaseExists(conn))
                {
                    log.Info($"Copied {ApplicationCode} database is functioning.");
                }
                else
                {
                    DatabaseSetupException dbSetupException = new DatabaseSetupException($"{ApplicationCode} database is not functioning. No {DatabaseCode} database found after setup.");
                    throw dbSetupException;
                }
            }
        }

        /// <summary>
        /// Copies database mdf and ldf files from older sql server version, places them in user local app data folder,
        /// and attaches them in the newer version of sql server.
        /// </summary>
        public void CopyDBAcrossServers(InitialDbInfo localDb2012Info)
        {
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(OldMasterConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                //copy the files over
                DoTheCopy(localDb2012Info.MDF, newMDF);
                DoTheCopy(localDb2012Info.LDF, newLDF);

                //create and attach new 
                ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", CurrentMasterConnectionString);
            }
            finally
            {
                //reattach the original
                ExecuteNonQuery("EXEC sp_attach_db  @dbname = N'" + DatabaseCode + "', @FILENAME1 = '" + localDb2012Info.MDF + "', @FILENAME2 = '" + localDb2012Info.LDF + "'", OldMasterConnectionString);
            }

        }

        //this method will check to see if the files are already in place and if they
        //exist it will rename them first..  
        //if the rename fails it will throw an 
        private void DoTheCopy(string source, string destination)
        {
            try
            {
                if (File.Exists(destination))
                {
                    int i = 0;
                    while (File.Exists(destination + i))
                    {
                        i++;
                    }

                    File.Move(destination, destination + i);
                }
                File.Copy(source, destination, false);
            }
            catch (IOException ioe)
            {
                throw new ApplicationException("My Custom message", ioe);
            }
        }

        /// <summary>
        /// Copies existing mdf and ldf files attached on localdb 2019 server to newer version appdata folder and reattaches (preparing for upgrade)
        /// This is only public for testing
        /// </summary>
        /// <param name="connectionString">Connection string for the current version of sql server</param>
        public void CopyDBWithinServer(InitialDbInfo dbInfo)
        {
            //force close on the source database and detach source db                
            ForceCloseAndDetach(CurrentMasterConnectionString, DatabaseCode);

            // Creating new paths for mdf and ldf files
            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
            string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

            //copy the files over
            DoTheCopy(dbInfo.MDF, newMDF);
            DoTheCopy(dbInfo.LDF, newLDF);

            //create and attach new 
            ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", CurrentMasterConnectionString);
        }

        /// <summary>
        /// Copies the clean database that comes with installation package to desired location.
        /// </summary>
        /// <param name="destDBFile">The new location to copy the mdf file to</param>
        /// <param name="destLogFile">The new location to copy the ldf file to</param>
        public void CopyDBFromInstallationSource(string destDBFile, string destLogFile)
        {
            string websitedataDir = "Data";
            string sourceDirPath = Path.Combine(InitialDbInfo.GetExecutingDirectory().FullName);
            string sourcePath = Path.Combine(sourceDirPath, websitedataDir, DatabaseFileName);
            string sourceLogPath = Path.Combine(sourceDirPath, websitedataDir, DatabaseLogFileName);

            log.Info("Copying clean database file from " + sourcePath + " to " + destDBFile);
            DoTheCopy(sourcePath, destDBFile);
            DoTheCopy(sourceLogPath, destLogFile);
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

        public void AttachTest(string dbname, string destDBFile, string destLogFile)
        {
            ExecuteNonQuery(
              "IF NOT EXISTS(SELECT name \n" +
              "FROM master..sysdatabases \n" +
              "where name ='" + dbname + "') \n" +
                  "CREATE DATABASE " + dbname +
                  " ON(FILENAME = '" + destDBFile + "'),  " +
                  " (FILENAME = '" + destLogFile + "') FOR ATTACH; ",
              CurrentMasterConnectionString);
        }

        private static string EscapeString(string value)
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


        // Kill processes if duplicate process running under another version (used to use CSETTrayApp).    
        private void KillProcess()
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

        /// <summary>
        /// Checks if databse with name of this.DatabaseCode exists on the given connection
        /// </summary>
        /// <param name="conn"></param>
        /// <returns>True if database with provided DatabaseCode exists on given connection; false otherwise</returns>
        private bool DatabaseExists(SqlConnection conn)
        {
            conn.Open();
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandText = "SELECT name \n" +
            "FROM master..sysdatabases \n" +
            "where name ='" + DatabaseCode + "'";
            SqlDataReader reader = cmd.ExecuteReader();
            return reader.HasRows;
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
        public static string CurrentMasterConnectionString { get; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=20;MultipleActiveResultSets=True;";
        public static string OldMasterConnectionString { get; } = @"data source=(LocalDB)\v11.0;Database=Master;integrated security=True;connect timeout=10;MultipleActiveResultSets=True;";
        public string DatabaseCode
        {
            get
            {
                if (ApplicationCode.Equals("CSET"))
                {
                    return ApplicationCode + "Web";
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
