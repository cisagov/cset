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

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {
        private static readonly string LOG_CONFIG_FILE = @"log4net.config";
        private VersionUpgrader upgrader = new VersionUpgrader(Assembly.GetAssembly(typeof(DbManager)).Location);
        private static ILog log;

        public DbManager(Version csetVersion)
        {
            NewCSETVersion = csetVersion;

            // Configure logging
            XmlDocument log4netConfig = new XmlDocument();
            log4netConfig.Load(File.OpenRead(LOG_CONFIG_FILE));

            var repo = LogManager.CreateRepository(
                Assembly.GetEntryAssembly(), typeof(log4net.Repository.Hierarchy.Hierarchy));

            log4net.Config.XmlConfigurator.Configure(repo, log4netConfig["log4net"]);
            log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }

        /// <summary>
        /// Attempts to attach fresh database after local install, or upgrade from previous version of CSET if already installed.
        /// </summary>
        public void SetupDb()
        {
            if (LocalDb2019Installed)
            {
                InitialDbInfo dbInfo = new InitialDbInfo(CurrentMasterConnectionString, DatabaseCode);
                if (!dbInfo.Exists)
                {
                    string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                    string csetDestDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), DatabaseFileName);
                    string csetDestLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), DatabaseLogFileName);

                    // Create the new version folder in local app data folder
                    Directory.CreateDirectory(Path.GetDirectoryName(csetDestDBFile));
                    ResolveLocalDbVersion();

                    // No previous version of CSET found
                    if (InstalledCSETVersion == null)
                    {
                        CopyDB(csetDestDBFile, csetDestLogFile);
                        ExecuteNonQuery(
                            "IF NOT EXISTS(SELECT name \n" +
                            "FROM master..sysdatabases \n" +
                            "where name ='" + DatabaseCode + "') \n" +
                                "CREATE DATABASE " + DatabaseCode +
                                " ON(FILENAME = '" + csetDestDBFile + "'),  " +
                                " (FILENAME = '" + csetDestLogFile + "') FOR ATTACH; ",
                            CurrentMasterConnectionString);

                        SetInstallationTable();

                        // Verify that the database exists now
                        using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                        {
                            if (ExistsCSETWebDatabase(conn))
                            {
                                log.Info("New CSET database is functioning");
                            }
                            else
                            {
                                log.Info("Error: database is not fuctioning");
                            }
                        }
                    }
                    // Another version of CSET installed, copying and upgrading Database
                    else
                    {
                        CopyDbAcrossServers(OldMasterConnectionString, CurrentMasterConnectionString);

                        try
                        {
                            upgrader.UpgradeOnly(NewCSETVersion, CurrentCSETConnectionString);

                        }
                        catch (Exception e)
                        {
                            log.Error(e.Message);
                        }

                        // Verify that the database has been copied over and exists now
                        using (SqlConnection conn = new SqlConnection(CurrentMasterConnectionString))
                        {
                            if (ExistsCSETWebDatabase(conn))
                            {
                                log.Info("Copied CSET database is functioning");
                            }
                            else
                            {
                                log.Info("Error: database is not fuctioning after copy attempt");
                            }
                        }
                    }
                }
            }
            else 
            {
                log.Info("SQL Server LocalDB 2019 installation not found... unable to run CSET " + NewCSETVersion);
            }
        }

        /// <summary>
        /// Executes series of commands (stop, delete, and start) using sqllocaldb command line utility to resolve engine versioning bug.
        /// </summary>
        private void ResolveLocalDbVersion()
        {
            log.Info("Deleting and recreating localDB MSSQLLocalDB default instance..");
            var process = System.Diagnostics.Process.Start("CMD.exe", "/C sqllocaldb stop mssqllocaldb && sqllocaldb delete mssqllocaldb && sqllocaldb start mssqllocaldb");
            process.WaitForExit(10000); // wait up to 10 seconds 
        }

        public void CopyDbAcrossServers(string oldConnectionString, string newConnectionString)
        {
            //get the file paths
            InitialDbInfo dbInfo = new InitialDbInfo(oldConnectionString, DatabaseCode);
            try
            {
                //force close on the source database and detach source db                
                ForceCloseAndDetach(OldMasterConnectionString, DatabaseCode);

                // Creating new paths for mdf and ldf files
                string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string newMDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), DatabaseFileName);
                string newLDF = Path.Combine(appdatas, ClientCode, ApplicationCode, NewCSETVersion.ToString(), DatabaseLogFileName);

                //copy the files over
                File.Copy(dbInfo.CSETMDF, newMDF, true);
                File.Copy(dbInfo.CSETLDF, newLDF, true);

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
                ExecuteNonQuery("EXEC sp_attach_db  @dbname = N'" + DatabaseCode + "', @FILENAME1 = '" + dbInfo.CSETMDF + "', @FILENAME2 = '" + dbInfo.CSETLDF + "'", oldConnectionString);
            }

        }

        private void CopyDB(string csetDestDBFile, string csetDestLogFile)
        {
            string websitedataDir = "Data";
            string sourceDirPath = Path.Combine(InitialDbInfo.GetExecutingDirectory().FullName);

            if (!File.Exists(csetDestDBFile))
            {
                log.Info("Control Database doesn't exist at location: " + csetDestDBFile);
                string sourcePath = Path.Combine(sourceDirPath, websitedataDir, DatabaseFileName);
                string sourceLogPath = Path.Combine(sourceDirPath, websitedataDir, DatabaseLogFileName);
            
                log.Info("copying database file over from " + sourcePath + " to " + csetDestDBFile);
                try
                {
                    File.Copy(sourcePath, csetDestDBFile, true);
                    File.Copy(sourceLogPath, csetDestLogFile, true);
                }
                catch(Exception e) 
                {
                    log.Info(e.Message);
                }
            }
            else
                log.Info("Not necessary to copy the database");
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
                    log.Error(sqle.Message);
                }
            }
        }

        public static string EscapeString(string value)
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

        /// <summary>
        /// Checks if databse with name of this.DatabaseCode exists on the given connection
        /// </summary>
        /// <param name="conn"></param>
        /// <returns>True if CSET database exists on given connection; false otherwise</returns>
        public bool ExistsCSETWebDatabase(SqlConnection conn)
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
                log.Error(sqle.Message);
            }
        }

        /// <summary>
        /// Creates a JWT_Secret in DB to be used for tokens.
        /// A unique 'installation ID' is also created and stored. Does nothing if secret has already been set in DB.
        /// </summary>
        /// <returns></returns>
        public void SetInstallationTable()
        {
            using (CSETContext context = new CSETContext())
            {
                var inst = context.INSTALLATION.FirstOrDefault();
                if (inst != null)
                {
                    return;
                }

                // This is the first run of CSET -- generate a new secret and installation identifier
                string newSecret = null;
                string newInstallID = null;

                var byteArray = new byte[(int)Math.Ceiling(130 / 2.0)];
                using (var rng = new RNGCryptoServiceProvider())
                {
                    rng.GetBytes(byteArray);
                    newSecret = String.Concat(Array.ConvertAll(byteArray, x => x.ToString("X2")));
                }

                newInstallID = Guid.NewGuid().ToString();


                // Store the new secret and installation ID
                var installRec = new INSTALLATION
                {
                    JWT_Secret = newSecret,
                    Generated_UTC = DateTime.UtcNow,
                    Installation_ID = newInstallID
                };
                context.INSTALLATION.Add(installRec);
                context.SaveChanges();
            }
        }

        public Version NewCSETVersion { get; private set; }
        public string DatabaseCode { get; private set; } = "CSETWeb";
        public string ClientCode { get; private set; } = "DHS";
        public string ApplicationCode { get; private set; } = "CSET";
        public string CurrentCSETConnectionString { get; private set; } = @"data source=(LocalDB)\MSSQLLocalDB;initial catalog=CSETWeb;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
        public string OldCSETConnectionString { get; private set; } = @"data source=(localdb)\v11.0;initial catalog = CSETWeb;Integrated Security = SSPI;connect timeout=5;MultipleActiveResultSets=True";
        public string CurrentMasterConnectionString { get; private set; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
        public string OldMasterConnectionString { get; private set; } = @"data source=(LocalDB)\v11.0;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";
        public bool LocalDb2019Installed 
        {
            get { return IsLocalDb2019Installed(); } 
        }
        public Version InstalledCSETVersion 
        {
            get { return InitialDbInfo.GetInstalledCSETWebDbVersion(OldMasterConnectionString, OldCSETConnectionString, DatabaseCode); } 
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
