//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.IO;

namespace ProcViewSerializer
{
    public class Serializer
    {
        DBIO dbio = new DBIO();
        string basePath = "";


        /// <summary>
        /// Constructor.
        /// </summary>
        public Serializer()
        {
            this.basePath = ConfigurationManager.AppSettings["Destination Path"];
        }


        /// <summary>
        /// Discovers all stored procedures and views in the database and saves each to a file.
        /// </summary>
        public void Go()
        {
            string sql = "SELECT DISTINCT " +
               "o.name AS Object_Name, o.type_desc " +
               "FROM sys.sql_modules m " +
               "INNER JOIN " +
               "sys.objects o " +
               "ON m.object_id = o.object_id " +
               "WHERE type_desc in ('VIEW', 'SQL_STORED_PROCEDURE', 'SQL_TABLE_VALUED_FUNCTION', 'SQL_TRIGGER') " +
               "order by type_desc, object_name";

            var dtObjects = dbio.Select(sql, null);

            foreach (DataRow row in dtObjects.Rows)
            {
                SaveToFile(row["Object_Name"].ToString(), row["type_desc"].ToString());
            }
        }


        /// <summary>
        /// Reads the content of the procedure or view and saves it as a file.
        /// </summary>
        /// <param name="procName"></param>
        private void SaveToFile(string procName, string objectType)
        {
            List<string> lines = new List<string>();

            Dictionary<string, object> parms = new Dictionary<string, object>
            {
                { "@objname", procName }
            };

            foreach (DataRow row in dbio.ExecuteProcedure("sp_helptext", parms).Rows)
            {
                lines.Add(row["Text"].ToString().TrimEnd("\n\r".ToCharArray()));
            }

            string fileType = "";
            string filePath = this.basePath;
            switch (objectType)
            {
                case "VIEW":
                    filePath = Path.Combine(this.basePath, "Views");
                    fileType = "view";
                    break;
                case "SQL_STORED_PROCEDURE":
                    filePath = Path.Combine(this.basePath, "Stored Procedures");
                    fileType = "proc";
                    break;
                case "SQL_TABLE_VALUED_FUNCTION":
                    filePath = Path.Combine(this.basePath, "Functions");
                    fileType = "func";
                    break;
                case "SQL_TRIGGER":
                    filePath = Path.Combine(this.basePath, "Triggers");
                    fileType = "trigger";
                    break;
            }

            string fileName = Path.Combine(filePath, procName + "." + fileType + ".sql");
            Directory.CreateDirectory(filePath);

            File.WriteAllLines(fileName, lines);
        }
    }
}
