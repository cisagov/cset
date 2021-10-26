using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using CSETWebCore.DataLayer;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;

namespace CSETWebCore.DatabaseManager
{
    public class DbManager
    {

        public DbManager(string csetVersion)
        {
            CSETVersion = csetVersion;
            DbExists = true;
            if (IsLocalDb2019Installed())
            {
                LocalDbInstalled = true;
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
                LocalDbInstalled = false;
                DbExists = false;
            }
        }

        public String CSETMDF
        { get; set; }
        public String CSETLDF
        { get; set; }
        public bool DbExists { get; private set; }
        public bool LocalDbInstalled { get; private set; }
        public string CSETVersion { get; private set; }
        public string DatabaseCode { get; set; } = "CSETWeb";
        public string ClientCode { get; set; } = "DHS";
        public string ApplicationCode { get; set; } = "CSET";
        public string CurrentCSETConnectionString { get; private set; }
        public string OldCSETConnectionString { get; private set; } = @"data source=(localdb)\v11.0;initial catalog = CSETWeb;persist security info = True;Integrated Security = SSPI;connect timeout=5;MultipleActiveResultSets=True";
        public string MasterConnectionString { get; private set; } = @"data source=(LocalDB)\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=5;MultipleActiveResultSets=True;";

        /// <summary>
        /// Attempts to attach fresh database after local install, as well as transfer assessments from previous version of CSET.
        /// </summary>
        public void SetupDb()
        {
            string databaseFileName = DatabaseCode + ".mdf";
            string databaseLogFileName = DatabaseCode + "_log.ldf";

            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string csetDestDBFile = Path.Combine(appdatas, ClientCode, ApplicationCode, CSETVersion, "database", databaseFileName);
            string csetDestLogFile = Path.Combine(appdatas, ClientCode, ApplicationCode, CSETVersion, "database", databaseLogFileName);

            if (LocalDbInstalled && !DbExists)
            {
                try
                {
                    ResolveLocalDbVersion();
                    // migrating users and assessments from previous localally installed version of CSET
                    AddUsers(GetPreviousVersionUsers());
                    AddAssessments(GetPreviousVersionAssessments());
                    using (SqlConnection conn = new SqlConnection(MasterConnectionString))
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

        /// <summary>
        /// Executes series of commands (stop, delete, and start) using sqllocaldb command line utility to resolve engine versioning bug.
        /// </summary>
        private void ResolveLocalDbVersion()
        {
            var process = System.Diagnostics.Process.Start("CMD.exe", "/C sqllocaldb stop mssqllocaldb && sqllocaldb delete mssqllocaldb && sqllocaldb start mssqllocaldb");
            process.WaitForExit(10000); // wait up to 10 seconds 
        }

        /// <summary>
        /// Adds assessments to CSETWeb SQL Server localdb 2019 default instance.
        /// </summary>
        /// <param name="assessments">Assessments to be added</param>
        private void AddAssessments(List<ASSESSMENTS> assessments)
        {
            if (assessments != null && assessments.Count != 0) 
            {
                using (CSETContext context = new CSETContext())
                {
                    using (var transaction = context.Database.BeginTransaction()) 
                    {
                        context.ASSESSMENTS.AddRange(assessments);
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT ASSESSMENTS ON;");
                        context.SaveChanges();
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT ASSESSMENTS OFF;");
                        transaction.Commit();
                    } 
                }
            }
        }

        /// <summary>
        /// Adds users to CSETWeb SQL Server localdb 2019 default instance.
        /// </summary>
        /// <param name="users">Users to be added</param>
        private void AddUsers(List<USERS> users)
        {
            if (users != null && users.Count != 0)
            {
                using (CSETContext context = new CSETContext())
                {
                    using (var transaction = context.Database.BeginTransaction())
                    {
                        context.USERS.AddRange(users);
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT USERS ON;");
                        context.SaveChanges();
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT USERS OFF;");
                        transaction.Commit();
                    }
                }
            }
        }

        /// <summary>
        /// Retrieves all assessments from previous version of CSET (< 11.0.0.0).
        /// </summary>
        /// <returns>List of Assessments from previous version of CSET (using localdb v11.0). Null if no previous version of CSET is installed.</returns>
        private List<ASSESSMENTS> GetPreviousVersionAssessments() 
        {
            var contextOptions = new DbContextOptionsBuilder<CsetwebContext>()
                .UseSqlServer(OldCSETConnectionString)
                .Options;

            try
            {
                using (CSETContext context = new CSETContext(contextOptions))
                {
                    return context.ASSESSMENTS.ToList();
                }
            }
            catch 
            {
                // no database from previous version of CSET found, just return null
                return null;
            }
        }

        /// <summary>
        /// Retrieves all assessments from previous version of CSET (< 11.0.0.0).
        /// </summary>
        /// <returns>List of Assessments from previous version of CSET (using localdb v11.0). Null if no previous version of CSET is installed.</returns>
        private List<USERS> GetPreviousVersionUsers()
        {
            var contextOptions = new DbContextOptionsBuilder<CsetwebContext>()
                .UseSqlServer(OldCSETConnectionString)
                .Options;

            try
            {
                using (CSETContext context = new CSETContext(contextOptions))
                {
                    return context.USERS.ToList();
                }
            }
            catch
            {
                // no database from previous version of CSET found, just return null
                return null;
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
    }
}
