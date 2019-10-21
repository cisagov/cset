using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json;
using Newtonsoft.Json.Schema;
using Newtonsoft.Json.Serialization;
using Newtonsoft.Json.Linq;

namespace AutoExportToJson
{
    /// <summary>
    /// 
    /// </summary>
    public class ImportDbFromJson
    {
        private DBIO dbio = null;

        Dictionary<string, string> identityColumns = null;
        DataTable schema = null;

        XmlDocument xColumnRules = new XmlDocument();

        public void Go()
        {
            string exportJson = File.ReadAllText(@"c:\users\woodrk\downloads\Assess 0417 A.export.json");
            exportJson = File.ReadAllText(@"c:\users\woodrk\downloads\with_findings.json");
            JObject oAssessment = JObject.Parse(exportJson);

            dbio = new DBIO();

            identityColumns = dbio.GetIdentityColumnNames();
            schema = dbio.GetSchema();

            var assembly = Assembly.GetExecutingAssembly();
            using (Stream stream = assembly.GetManifestResourceStream("AutoExportToJson.ColumnImportRules.xml"))
            using (StreamReader reader = new StreamReader(stream))
            {
                string result = reader.ReadToEnd();
                xColumnRules.LoadXml(result);
            }



            // TEMP TEMP
            int assessmentId = 1011;


            var tableList = xColumnRules.SelectNodes("//Table");
            foreach (var xTable in tableList)
            {
                var tableName = (xTable as XmlElement).Attributes["name"].Value;

                // find all objects for the target table and convert each to a database row
                var jObjs = oAssessment.SelectToken("$.j" + tableName);
                if (jObjs != null)
                {
                    foreach (var jObj in jObjs)
                    {
                        CreateDbRow(assessmentId, jObj, tableName);
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="jObj"></param>
        /// <param name="tableName"></param>
        private void CreateDbRow(int assessmentId, JToken jObj, string tableName)
        {
            List<string> columnNamesForInsert = new List<string>();
            Dictionary<string, object> parms = new Dictionary<string, object>();


            DataTable dt = dbio.Select(string.Format("select * from {0} where 1 = 2", tableName), null);

            DataRow row = dt.NewRow();
            foreach (JToken token in jObj.Children<JToken>())
            {
                if (token.Type == JTokenType.Property)
                {
                    var prop = token as JProperty;

                    var colName = prop.Name;

                    // just in case a column no longer exists, don't try to set it
                    if (dt.Columns[colName] == null)
                    {
                        continue;
                    }


                    // skip identity column 
                    if (identityColumns.ContainsKey(tableName) 
                        && colName.Equals(identityColumns[tableName], StringComparison.InvariantCultureIgnoreCase))
                    {
                        continue;
                    }


                    // handle certain null values
                    if (prop.Value.Type == JTokenType.Null)
                    {
                        switch ((tableName + "|" + colName).ToLower())
                        {
                            case "answer|component_guid":
                                prop.Value = Guid.Empty;
                                break;
                        }
                    }


                    // set assessment ID
                    if (colName.ToLower() == "assessment_id"
                        || tableName.ToLower() == "information" && colName.ToLower() == "id")
                    {
                        prop.Value = assessmentId;
                    }


                    // ignore any columns that we are supposed to ignore
                    var ruleIgnore = xColumnRules.SelectSingleNode(string.Format("//Table[@name='{0}']/Column[@name='{1}']/Rule[@action='ignore']", tableName, colName));
                    if (ruleIgnore != null)
                    {
                        continue;
                    }

                    var ruleDefaultDate = xColumnRules.SelectSingleNode(string.Format("//Table[@name='{0}']/Column[@name='{1}']/Rule[@action='defaultDatetime']", tableName, colName));
                    if (prop.Value.Type == JTokenType.Null && ruleDefaultDate != null)
                    {
                        prop.Value = DateTime.Now;
                    }
    


                    columnNamesForInsert.Add(colName);
                    Type t = dt.Columns[colName].DataType;
                    parms.Add(string.Format("@{0}", colName),
                        (prop.Value.Type == JTokenType.Null) ? System.DBNull.Value : Convert.ChangeType(prop.Value, t));
                }
            }

            string columns = string.Join(",", columnNamesForInsert);
            string values = string.Join(",", columnNamesForInsert.Select(c => string.Format("@{0}", c)));
            String sqlCommandInsert = string.Format("INSERT INTO dbo.{0}({1}) VALUES ({2})", tableName, columns, values);


            dbio.Execute(sqlCommandInsert, parms);
        }


        /// <summary>
        /// Not functional yet.  Want to return an object.  Using switch statement in the calling method for now.
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <returns></returns>
        private JProperty GetDefaultValue(string tableName, string columnName)
        {
            var myColumnSchema = schema.Select(string.Format("table_name = '{0}' and column_name = '{1}'", tableName, columnName))[0];
            if (!(myColumnSchema["column_default"] is System.DBNull))
            {
                if (myColumnSchema["data_type"] as string == "uniqueidentifier")
                {
                    return new JProperty(columnName, Guid.Empty);
                }
            }

            return null;
        }
    }
}
