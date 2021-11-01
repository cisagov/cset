using System;
using System.IO;
using Microsoft.Win32;
using Microsoft.Data.SqlClient;
using CSETWebCore.DataLayer.Model;

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
                    CopyCSETData();
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

        /// <summary>
        /// Copys user data from previously installed version of CSET
        /// </summary>
        private void CopyCSETData()
        {
            TransferData.TransferEntities<USERS>();
            TransferData.TransferEntities<ASSESSMENTS>();
            TransferData.TransferEntities<ASSESSMENT_CONTACTS>();
            TransferData.TransferEntities<ANSWER>();
            TransferData.TransferEntities<DOCUMENT_FILE>();
            TransferData.TransferEntities<DOCUMENT_ANSWERS>();
            TransferData.TransferEntities<MATURITY_DOMAIN_REMARKS>();
            TransferData.TransferEntities<AVAILABLE_STANDARDS>();
            TransferData.TransferEntities<STANDARD_SELECTION>();
            TransferData.TransferEntities<ASSESSMENT_SELECTED_LEVELS>();
            TransferData.TransferEntities<ASSESSMENT_IRP>();
            TransferData.TransferEntities<ASSESSMENT_IRP_HEADER>();
            TransferData.TransferEntities<AVAILABLE_MATURITY_MODELS>();
            TransferData.TransferEntities<INFORMATION>();
            TransferData.TransferEntities<GENERAL_SAL>();
            TransferData.TransferEntities<DEMOGRAPHICS>();
            TransferData.TransferEntities<ASSESSMENTS_REQUIRED_DOCUMENTATION>();
            TransferData.TransferEntities<DIAGRAM_CONTAINER>();
            TransferData.TransferEntities<ASSESSMENT_DIAGRAM_COMPONENTS>();
            TransferData.TransferEntities<FINDING>();
            TransferData.TransferEntities<FINDING_CONTACT>();
            TransferData.TransferEntities<SETS>();
            TransferData.TransferEntities<SET_FILES>();
            TransferData.TransferEntities<FINDING>();
            TransferData.TransferEntities<FINDING_CONTACT>();
        }
    }
}
