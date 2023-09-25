//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Diagnostics;
using System.Data;
using UpgradeLibrary.Upgrade;
using CSETWeb_Api.Versioning;

namespace UpgradeLibrary.Upgrade
{
    /// <summary>
    /// Applies upgrades to the database.
    /// </summary>
    public class VersionUpgrader
    {
        /// <summary>
        /// 
        /// </summary>
        private Dictionary<string, ConvertSqlDatabase> converters = new Dictionary<string, ConvertSqlDatabase>();

        /// <summary>
        /// Constructor.
        /// </summary>
        public VersionUpgrader(string path)
        {
            ConvertDatabase901 convertDb901 = new ConvertDatabase901(path);
            converters.Add("9.0.0.0", convertDb901);
            converters.Add("9.0.1.0", new ConvertDatabase92(path));            
                //internal versions
                converters.Add("9.0.2.0", new ConvertDatabase92(path));                      
                converters.Add("9.0.3.0", new ConvertDatabase904(path));           
            converters.Add("9.0.4.0", new ConvertDatabase904NCUA(path));
            converters.Add("9.2.0.0", new ConvertDatabase921(path));
            converters.Add("9.2.1.0", new ConvertDatabase922(path));
            converters.Add("9.2.2.0", new ConvertDatabase923(path));
            converters.Add("9.2.3.0", new ConvertDatabase1000(path));            
            converters.Add("10.0.0.0", new ConvertDatabase1001(path));
            converters.Add("10.0.1.0", new ConvertDatabase101(path));
            converters.Add("10.1.0.0", new ConvertDatabase1011(path));
            //converters.Add("10.1.1", new ConvertDatabase1011Stub(path));
            converters.Add("10.1.1.0", new ConvertDatabase1012(path));
            converters.Add("10.1.2.0", new ConvertDatabase1020(path));
            converters.Add("10.2.0.0", new ConvertDatabase1021(path));
            converters.Add("10.2.1.0", new ConvertDatabase1030(path));
            converters.Add("10.3.0.0", new ConvertDatabase1031(path));
            converters.Add("10.3.1.0", new ConvertDatabase10311(path));
            converters.Add("10.3.1.1", new ConvertDatabase10312(path));
            converters.Add("10.3.1.2", new ConvertDatabase10313(path));
            converters.Add("10.3.1.3", new ConvertDatabase10314(path));
            converters.Add("10.3.1.4", new ConvertDatabase11000(path));
            converters.Add("11.0.0.0", new ConvertDatabase11010(path));
            converters.Add("11.0.1.0", new ConvertDatabase11012(path));
            converters.Add("11.0.1.2", new ConvertDatabase11013(path));
            converters.Add("11.0.1.3", new ConvertDatabase11100(path));
            converters.Add("11.1.0.0", new ConvertDatabase11200(path));
            converters.Add("11.2.0.0", new ConvertDatabase11210(path));
            converters.Add("11.2.1.0", new ConvertDatabase12000(path));
            converters.Add("12.0.0.0", new ConvertDatabase12001(path));
            converters.Add("12.0.0.1", new ConvertDatabase12002(path));
            converters.Add("12.0.0.2", new ConvertDatabase12003(path));
            converters.Add("12.0.0.3", new ConvertDatabase12004(path));
            converters.Add("12.0.0.4", new ConvertDatabase12005(path));
            converters.Add("12.0.0.5", new ConvertDatabase12006(path));
            converters.Add("12.0.0.6", new ConvertDatabase12007(path));
            converters.Add("12.0.0.7", new ConvertDatabase12008(path));
            converters.Add("12.0.0.8", new ConvertDatabase12009(path));
            converters.Add("12.0.0.9", new ConvertDatabase120010(path));
            converters.Add("12.0.0.10", new ConvertDatabase120011(path));
            converters.Add("12.0.0.11", new ConvertDatabase120012(path));
            converters.Add("12.0.0.12", new ConvertDatabase120013(path));
            converters.Add("12.0.0.13", new ConvertDatabase120014(path));
            converters.Add("12.0.0.14", new ConvertDatabase120015(path));
            converters.Add("12.0.0.15", new ConvertDatabase120016(path));
            converters.Add("12.0.0.16", new ConvertDatabase120017(path));
            converters.Add("12.0.0.17", new ConvertDatabase120018(path));
            converters.Add("12.0.0.18", new ConvertDatabase120019(path));
            converters.Add("12.0.0.19", new ConvertDatabase12012(path));
            converters.Add("12.0.1.2", new ConvertDatabase12013(path));
            converters.Add("12.0.1.3", new ConvertDatabase12014(path));
            converters.Add("12.0.1.4", new ConvertDatabase12015(path));
            converters.Add("12.0.1.5", new ConvertDatabase12016(path));
            converters.Add("12.0.1.6", new ConvertDatabase12017(path));
            converters.Add("12.0.1.7", new ConvertDatabase12018(path));
            converters.Add("12.0.1.8", new ConvertDatabase12019(path));
            converters.Add("12.0.1.9", new ConvertDatabase12020(path));
            converters.Add("12.0.2.0", new ConvertDatabase12021(path));
            converters.Add("12.0.2.1", new ConvertDatabase12022(path));
            converters.Add("12.0.2.2", new ConvertDatabase12023(path));
            converters.Add("12.0.2.3", new ConvertDatabase12024(path));
            converters.Add("12.0.2.4", new ConvertDatabase12025(path));
            converters.Add("12.0.2.5", new ConvertDatabase12026(path));
            converters.Add("12.0.2.6", new ConvertDatabase12027(path));
            converters.Add("12.0.2.7", new ConvertDatabase12028(path));
            converters.Add("12.0.2.8", new ConvertDatabase12029(path));
            converters.Add("12.0.2.9", new ConvertDatabase12030(path));
            converters.Add("12.0.3.0", new ConvertDatabase12031(path));
            converters.Add("12.0.3.1", new ConvertDatabase12032(path));

        }

        public void UpgradeOnly(Version currentVersion, string tempConnect)
        {
            upgradeDB(currentVersion, tempConnect);
        }

        public Version TestVersion(string connectionString)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlConnection.ClearAllPools();
                //drop into where ever you need to start and then upgrade all the way to the current version.
                //a couple of rules for if the upgrade was successful. 
                //1. the very last sql statement is the version upgrade
                //2. going from version to version is based on what is in the database not in the code                    
                conn.Open();
                return GetDBVersion(conn);
            }
        }

        private void upgradeDB(Version currentVersion, string localDBConnectionString) { 
            Version dbVersion;
            using (SqlConnection conn = new SqlConnection(localDBConnectionString))
            {
                SqlConnection.ClearAllPools();
                //drop into where ever you need to start and then upgrade all the way to the current version.
                //a couple of rules for if the upgrade was successful. 
                //1. the very last sql statement is the version upgrade
                //2. going from version to version is based on what is in the database not in the code                    
                conn.Open();
                dbVersion = GetDBVersion(conn);
            }

            while (dbVersion < currentVersion)
            {
                ConvertSqlDatabase converter = null;
                using (SqlConnection conn = new SqlConnection(localDBConnectionString))
                {
                    conn.Open();
                    if (converters.ContainsKey(dbVersion.ToString()))
                    {
                        converter = converters[dbVersion.ToString()];
                        converter.Execute(conn);
                    }
                    else
                    {
                        Debug.Assert(false, "Failed to find converter for version:" + dbVersion.ToString());
                        break;
                    }

                    dbVersion = GetDBVersion(conn);
                }

            }
            if (dbVersion > currentVersion)  //Assessmenet is newer than current
            {
                throw new DatabaseUpgradeException("This database is a newer version of CSET.  Please upgrade to CSET " +
                         dbVersion.ToString() + "or get a newer version of the upgrader");
            }
        }

        /// <summary>
        /// Reads the CSET version from the database.
        /// </summary>
        /// <param name="conn">I expect this to be open before I get it</param>
        /// <returns></returns>
        public Version GetDBVersion(SqlConnection conn)
        {
            DataTable versionTable = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT [Version_Id], [Cset_Version] FROM [CSET_VERSION]", conn);
            adapter.Fill(versionTable);

            string s = versionTable.Rows[0]["Cset_Version"].ToString();
            return VersionHandler.ConvertFromStringToVersion(s);
        }
    }
}
