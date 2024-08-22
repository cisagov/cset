//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using UpgradeLibrary.Upgrade;
using System.Reflection;
using System.Diagnostics;
using NLog;
using MartinCostello.SqlLocalDb;
using static CSETWebCore.Constants.Constants;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        private static readonly Logger _logger = LogManager.GetLogger("DBManager");
        private readonly VersionUpgrader _upgrader = new VersionUpgrader(Assembly.GetAssembly(typeof(DbManager)).Location);

        public DbManager(Version version, string clientCode, string applicationCode)
        {
            NewVersion = version;
            ClientCode = clientCode;
            ApplicationCode = applicationCode;
            SetInstalledLocalDbVersions();
        }

        /* 
        * DBManager logic flow:
        * 
        * This method provides the core functionality for the database setup workflow.
        * It is called every time the compiled production web api code is executed.
        * 
        * Look to see if LocalDb2022 is installed.
        * If it's not, throw an error
        *
        * Check if INLLocalDb2022 instance is there, if not, create it. If it is, check for the existence of the application database.
        * If the database exists, check the CSET_VERSION table to see if it is up to date with the latest deployed assembly version.
        * If it is outdated, upgrade it. If not, we are done.
        * If there is no application database and neither a 2012 or a 2019 instance exists, attach the template database for fresh new install.
        * 
        * Then, check for a LocalDb2019 default instance and database. If exists, stop 2019, copy the db and attach the copy to the new INL2023 instance and attempt upgrade.
        * 
        * Then check for LocalDb2012 default instance and database. If exists, stop 2012, copy the db and attach the copy to the new INL2023 instance and attempt upgrade.
        *
        * Check if 2019/2012 is installed and if it is, get user acknowledgement that it's okay. Save user answer so it doesn't reappear
        * this message needs to show up and be acknowledge regardless of the upgrade status.
        * 
        */
        public void SetupDb()
        {
            try
            {
                //determine what state we are in.
                //then based on that state execute the appropriate upgrade logic

                if (LocalDb2022Installed)
                {
                    using (SqlLocalDbApi localDb = new SqlLocalDbApi())
                    {

                        // Create and start our custom localdb instance
                        ISqlLocalDbInstanceInfo instance = localDb.GetOrCreateInstance(LOCALDB_2022_CUSTOM_INSTANCE_NAME);
                        ISqlLocalDbInstanceManager manager = instance.Manage();

                        if (!instance.IsRunning)
                        {
                            manager.Start();
                        }
                    }

                    InitialDbInfo localDb2022Info = new InitialDbInfo(LocalDb2022ConnectionString, DatabaseCode);
                    InitialDbInfo localDb2019Info = null;
                    InitialDbInfo localDb2012Info = null;

                    if (LocalDb2019Installed) 
                    { 
                        localDb2019Info = new InitialDbInfo(LocalDb2019ConnectionString, DatabaseCode);
                    }

                    if (LocalDb2012Installed) 
                    { 
                        localDb2012Info = new InitialDbInfo(LocalDb2012ConnectionString, DatabaseCode);
                    }

                    string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                    string destDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                    string destLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                    // Create the new version folder in local app data folder. If it already exists, this call will do nothing and be harmless
                    Directory.CreateDirectory(Path.GetDirectoryName(destDBFile));

                    // If no DBs exist, we can do a clean install
                    if (!localDb2022Info.Exists && !(localDb2019Info?.Exists ?? false) && !(localDb2012Info?.Exists ?? false))
                    {
                        // Create a custom localdb instance for 2022
                        CleanInstallNoUpgrades(destDBFile, destLogFile, localDb2022Info);
                        return;
                    }

                    // If localdb2022 exists (our latest), check the CSET version and upgrade if needed
                    if (localDb2022Info.Exists)
                    {
                        if (localDb2022Info.GetInstalledDBVersion() < NewVersion)
                        {
                            UpgradeLocaldb2022(destDBFile, destLogFile, localDb2022Info);
                        }

                        return;
                    }

                    if (localDb2019Info?.Exists ?? false)
                    {
                        _logger.Info($"{ApplicationCode} {localDb2019Info.GetInstalledDBVersion()} database detected on LocalDB 2019 default instance. Copying database files and attempting upgrade... ");
                        UpgradeOldLocalDb(destDBFile, destLogFile, localDb2022Info, localDb2019Info);
                        return;
                    }

                    if (localDb2012Info?.Exists ?? false)
                    {
                        _logger.Info($"{ApplicationCode} {localDb2012Info.GetInstalledDBVersion()} database detected on LocalDB 2012 default instance. Copying database files and attempting upgrade... ");
                        UpgradeOldLocalDb(destDBFile, destLogFile, localDb2022Info, localDb2012Info);
                        return;
                    }
                }
                else
                {
                    throw new DatabaseSetupException($"SQL Server LocalDB 2022 installation not found... {ApplicationCode} {NewVersion} database setup aborted");
                }
            }
            catch (DatabaseSetupException e)
            {
                _logger.Error(e.Message);
                throw;
            }
            catch (Exception e)
            {
                DatabaseSetupException dbSetupException = new DatabaseSetupException("A fatal error occurred during the database setup process: " + e.Message, e);
                _logger.Error(dbSetupException.Message);
                throw dbSetupException;
            }
        }


        /// <summary>
        /// Perform a clean attach of master versioned database.
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        private void CleanInstallNoUpgrades(string destDBFile, string destLogFile, InitialDbInfo localDbInfo)
        {
            _logger.Info($"No previous {ApplicationCode} database found on LocalDB 2012 or 2019 default instances...");
            _logger.Info($"Attaching new {ApplicationCode} {NewVersion} database from installation source...");

            AttachCleanDatabase(destDBFile, destLogFile, localDbInfo);

            // Verify that the database exists now
            VerifyApplicationDatabaseFunctioning(localDbInfo);
        }


        /// <summary>
        /// Perform upgrade on a copy of existing application db found on localDb 2022.
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        /// <param name="localDbInfo"></param>
        private void UpgradeLocaldb2022(string destDBFile, string destLogFile, InitialDbInfo localDbInfo)
        {
            _logger.Info($"{ApplicationCode} {localDbInfo.GetInstalledDBVersion()} database detected on LocalDB 2022 default instance. Copying database file and attempting upgrade...");

            // Create the new version folder in local app data folder
            Directory.CreateDirectory(Path.GetDirectoryName(destDBFile));

            CopyDBWithinServer(localDbInfo);

            try
            {
                _upgrader.UpgradeOnly(NewVersion, localDbInfo.ConnectionString);
            }
            catch (DatabaseUpgradeException e)
            {
                _logger.Error(e.Message);
                // Attach clean database here if something goes wrong with database upgrade
                ForceCloseAndDetach(localDbInfo.MasterConnectionString, DatabaseCode);
                AttachCleanDatabase(destDBFile, destLogFile, localDbInfo);
            }

            // Verify that the database has been copied over and exists now
            VerifyApplicationDatabaseFunctioning(localDbInfo);
        }


        /// <summary>
        /// Take the source (our current db version) and upgrade it to the target (our latest db version)
        /// </summary>
        /// <param name="destDBFile"></param>
        /// <param name="destLogFile"></param>
        /// <param name="targetLocalDbInfo">The new info that we want to upgrade to</param>
        /// <param name="sourceLocalDbInfo">The old info that we're upgrading away from</param>
        private void UpgradeOldLocalDb(string destDBFile, string destLogFile, InitialDbInfo targetLocalDbInfo, InitialDbInfo sourceLocalDbInfo)
        {
            KillProcess();
            CopyDBAcrossServers(targetLocalDbInfo, sourceLocalDbInfo);

            try
            {
                _upgrader.UpgradeOnly(NewVersion, targetLocalDbInfo.ConnectionString);
            }
            catch (DatabaseUpgradeException e)
            {
                _logger.Error(e.Message);
                // Attach clean database here if something goes wrong with database upgrade
                ForceCloseAndDetach(sourceLocalDbInfo.MasterConnectionString, DatabaseCode);
                ForceCloseAndDetach(targetLocalDbInfo.MasterConnectionString, DatabaseCode);
                AttachCleanDatabase(destDBFile, destLogFile, targetLocalDbInfo);
            }

            // Verify that the database has been copied over and exists now
            VerifyApplicationDatabaseFunctioning(targetLocalDbInfo);
        }

        /// <summary>
        /// Wrapper for DatabaseExists function to include logging.
        /// </summary>
        private void VerifyApplicationDatabaseFunctioning(InitialDbInfo targetLocalDbInfo)
        {
            using (SqlConnection conn = new SqlConnection(targetLocalDbInfo.MasterConnectionString))
            {
                if (DatabaseExists(conn))
                {
                    _logger.Info($"Copied {ApplicationCode} database is functioning.");
                    DisplayOldLocalDbInstalledNotification(targetLocalDbInfo);
                }
                else
                {
                    DatabaseSetupException dbSetupException = new DatabaseSetupException($"{ApplicationCode} database is not functioning. No {DatabaseCode} database found after setup.");
                    throw dbSetupException;
                }
            }
        }

        private void DisplayOldLocalDbInstalledNotification(InitialDbInfo localdbInfo)
        {
            if (!ApplicationCode.Equals("ACET"))
            {
                if (LocalDb2019Installed || LocalDb2012Installed)
                {
                    var result = ExecuteScalarQuery("SELECT [Property_Value] FROM [GLOBAL_PROPERTIES] WHERE [Property] = 'AgreedToLocalDbNotification'", localdbInfo.ConnectionString);

                    if (result != null && ((string)result).ToLower().Equals("false"))
                    {
                        string oldLocalDbInstalledMessage = $"{(LocalDb2012Installed && LocalDb2019Installed ? "Old versions" : "An old version")} of SQL Server LocalDB " +
                            $"{(LocalDb2012Installed && LocalDb2019Installed ? "are" : "is")} still installed. {ApplicationCode} uses the latest version of LocalDB (2022); however, " +
                            $"{ApplicationCode} does not uninstall previous versions automatically. " +
                            "If you would like to remove an old version of LocalDB, you will have to do so manually: \r\n \r\n" +
                            $"{(LocalDb2019Installed ? LOCALDB_2019_REGISTRY_DISPLAY_NAME + "\r\n" : "")}" +
                            $"{(LocalDb2012Installed ? LOCALDB_2012_REGISTRY_DISPLAY_NAME : "")}";

                        _logger.Info(oldLocalDbInstalledMessage);
                        Console.WriteLine(oldLocalDbInstalledMessage);

                        ExecuteNonQuery("UPDATE [GLOBAL_PROPERTIES] SET [Property_Value] = 'True' WHERE [Property] = 'AgreedToLocalDbNotification'", localdbInfo.ConnectionString);
                    }
                }
            }
        }

        /// <summary>
        /// Copies database mdf and ldf files from older sql server version, places them in user local app data folder,
        /// and attaches them in the newer version of sql server.
        /// </summary>
        public void CopyDBAcrossServers(InitialDbInfo targetLocalDbInfo, InitialDbInfo sourceLocalDbInfo)
        {
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(sourceLocalDbInfo.ConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

                //copy the files over
                DoTheCopy(sourceLocalDbInfo.MDF, newMDF);
                DoTheCopy(sourceLocalDbInfo.LDF, newLDF);

                //create and attach new 
                ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", targetLocalDbInfo.MasterConnectionString);
            }
            finally
            {
                //reattach the original
                ExecuteNonQuery("EXEC sp_attach_db  @dbname = N'" + DatabaseCode + "', @FILENAME1 = '" + sourceLocalDbInfo.MDF + "', @FILENAME2 = '" + sourceLocalDbInfo.LDF + "'", sourceLocalDbInfo.MasterConnectionString);
            }

        }

        //this method will check to see if the files are already in place and if they
        //exist it will rename them first..  
        private void DoTheCopy(string source, string destination)
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

        /// <summary>
        /// Copies existing mdf and ldf files attached on localdb 2019 server to newer version appdata folder and reattaches (preparing for upgrade)
        /// This is only public for testing
        /// </summary>
        /// <param name="connectionString">Connection string for the current version of sql server</param>
        public void CopyDBWithinServer(InitialDbInfo dbInfo)
        {
            //force close on the source database and detach source db                
            ForceCloseAndDetach(dbInfo.MasterConnectionString, DatabaseCode);

            // Creating new paths for mdf and ldf files
            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseFileName);
            string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewVersion.ToString(), DatabaseLogFileName);

            //copy the files over
            DoTheCopy(dbInfo.MDF, newMDF);
            DoTheCopy(dbInfo.LDF, newLDF);

            //create and attach new 
            ExecuteNonQuery("CREATE DATABASE " + DatabaseCode + "  ON(FILENAME = '" + newMDF + "'), (FILENAME = '" + newLDF + "') FOR ATTACH;", dbInfo.MasterConnectionString);
        }

        /// <summary>
        /// Copies the clean database that comes with installation package to desired location.
        /// </summary>
        /// <param name="destDBFile">The new location to copy the mdf file to</param>
        /// <param name="destLogFile">The new location to copy the ldf file to</param>
        public void CopyDBFromInstallationSource(string destDBFile, string destLogFile)
        {
            string websitedataDir = "Data";
            string sourceDirPath = Path.Combine(GetExecutingDirectory().FullName);
            string sourcePath = Path.Combine(sourceDirPath, websitedataDir, DatabaseFileName);
            string sourceLogPath = Path.Combine(sourceDirPath, websitedataDir, DatabaseLogFileName);

            _logger.Info("Copying clean database file from " + sourcePath + " to " + destDBFile);
            DoTheCopy(sourcePath, destDBFile);
            DoTheCopy(sourceLogPath, destLogFile);
        }

        /// <summary>
        /// Copies clean database files from installation source to desired location and attaches
        /// to sql server designated by the InitialDbInfo object passed in.
        /// </summary>
        /// <param name="destDBFile">The location of the mdf file used for the attach</param>
        /// <param name="destLogFile">The location of the ldf file used for the attach</param>
        /// <param name="localDbInfo">initialDbInfo object containing connection information about the</param>
        private void AttachCleanDatabase(string destDBFile, string destLogFile, InitialDbInfo localDbInfo)
        {
            CopyDBFromInstallationSource(destDBFile, destLogFile);
            ExecuteNonQuery(
                "IF NOT EXISTS(SELECT name \n" +
                "FROM master..sysdatabases \n" +
                "where name ='" + DatabaseCode + "') \n" +
                    "CREATE DATABASE " + DatabaseCode +
                    " ON(FILENAME = '" + destDBFile + "'),  " +
                    " (FILENAME = '" + destLogFile + "') FOR ATTACH; ",
                localDbInfo.MasterConnectionString);
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
        /// Checks registry for localdb 2022 (only works for Windows).
        /// </summary>
        /// <returns>true if localdb key is found in HKEY_LOCAL_MACHINE registry.</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Interoperability", "CA1416:Validate platform compatibility", Justification = "<Pending>")]
        private void SetInstalledLocalDbVersions()
        {
            foreach (var item in Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall").GetSubKeyNames())
            {

                var programName = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + item).GetValue("DisplayName");

                if (Equals(programName, LOCALDB_2022_REGISTRY_DISPLAY_NAME))
                {
                    LocalDb2022Installed = true;
                }

                if (Equals(programName, LOCALDB_2019_REGISTRY_DISPLAY_NAME))
                {
                    LocalDb2019Installed = true;
                }

                if (Equals(programName, LOCALDB_2012_REGISTRY_DISPLAY_NAME))
                {
                    LocalDb2012Installed = true;
                }
            }
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
                _logger.Error(sqle.Message);
            }
        }

        /// <summary>
        /// Executes the query and returns the first column of the first row in the result set returned by the query.
        /// </summary>
        /// <param name="sql">the sql query to execute</param>
        /// <param name="connectionString"></param>
        /// <returns></returns>
        private object ExecuteScalarQuery(string sql, string connectionString)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = sql;
                    return cmd.ExecuteScalar();
                }
            }
            catch (SqlException sqle)
            {
                _logger.Error(sqle.Message);
                return null;
            }
        }

        public static DirectoryInfo GetExecutingDirectory()
        {
            string path = Assembly.GetAssembly(typeof(DbManager)).Location;
            return new FileInfo(path).Directory;
        }

        public Version NewVersion { get; }
        public string ClientCode { get; }
        public string ApplicationCode { get; }

        public string DatabaseCode
        {
            get
            {
                if (ApplicationCode.Equals("CSET") || ApplicationCode.Equals("CIE"))
                {
                    return ApplicationCode + "Web";
                }
                else if (ApplicationCode.Equals("CSET Renewables"))
                {
                    return "RENEWWeb";
                }
                else
                {
                    return ClientCode + "Web";
                }
            }
        }

        public bool LocalDb2022Installed { get; private set; } = false;
        public bool LocalDb2019Installed { get; private set; } = false;
        public bool LocalDb2012Installed { get; private set; } = false;
        public string LocalDb2022ConnectionString
        {
            // "INLLocalDb2022" is our custom localdb 2022 instance name, so we need to build it "custom".
            get { return @$"data source=(LocalDB)\{LOCALDB_2022_CUSTOM_INSTANCE_NAME};initial catalog={DatabaseCode};integrated security=SSPI;connect timeout=10;MultipleActiveResultSets=True;"; }
        }

        public string LocalDb2019ConnectionString
        {
            // "MSSQLLocalDB" is the default instance name for localdb2019
            get { return @$"data source=(LocalDB)\{LOCALDB_2019_DEFAULT_INSTANCE_NAME};initial catalog={DatabaseCode};integrated security=SSPI;connect timeout=5;MultipleActiveResultSets=True;"; }
        }

        public string LocalDb2012ConnectionString
        {
            // "v11.0" is the default instance name for localdb2012
            get { return @$"data source=(LocalDB)\{LOCALDB_2012_DEFAULT_INSTANCE_NAME};initial catalog={DatabaseCode};integrated security=SSPI;connect timeout=5;MultipleActiveResultSets=True;"; }
        }

        public string DatabaseFileName
        {
            get { return $"{DatabaseCode}{DB_EXTENSION}"; }
        }

        public string DatabaseLogFileName
        {
            get { return $"{DatabaseCode}_log{DB_LOG_EXTENSION}"; }
        }
    }
}
