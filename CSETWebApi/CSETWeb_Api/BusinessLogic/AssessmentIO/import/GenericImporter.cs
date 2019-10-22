using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using Newtonsoft.Json.Linq;

namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    public class GenericImporter
    {
        private DBIO dbio = null;

        Dictionary<string, string> identityColumns = null;
        DataTable schema = null;

        XmlDocument xColumnRules = new XmlDocument();


        Dictionary<string, Dictionary<int, int>> mapIdentity = new Dictionary<string, Dictionary<int, int>>();


        /// <summary>
        /// 
        /// </summary>
        public void SaveFromJson(int assessmentId, string json)
        {
            JObject oAssessment = JObject.Parse(json);

            dbio = new DBIO();

            identityColumns = dbio.GetIdentityColumnNames();
            schema = dbio.GetSchema();

            var assembly = Assembly.GetExecutingAssembly();
            using (Stream stream = assembly.GetManifestResourceStream("CSETWeb_Api.BusinessLogic.AssessmentIO.import.ColumnImportRules.xml"))
            using (StreamReader reader = new StreamReader(stream))
            {
                string result = reader.ReadToEnd();
                xColumnRules.LoadXml(result);
            }


            // process the tables defined in the XML in order
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
                        var idMap = CreateDbRow(assessmentId, jObj, tableName);
                        if (idMap.Item1 != -1 || idMap.Item2 != -1)
                        {
                            if (mapIdentity.ContainsKey(tableName))
                            {
                                mapIdentity[tableName].Add(idMap.Item1, idMap.Item2);
                            }
                            else
                            {
                                var d = new Dictionary<int, int>
                            {
                                { idMap.Item1, idMap.Item2 }
                            };
                                mapIdentity.Add(tableName, d);
                            }
                        }
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
        private Tuple<int, int> CreateDbRow(int assessmentId, JToken jObj, string tableName)
        {
            int oldIdentity = -1;
            int newIdentity = -1;

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
                        oldIdentity = Convert.ToInt32(prop.Value);
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
                        || colName.ToLower() == "assessement_id"
                        || (tableName.ToLower() == "information" && colName.ToLower() == "id"))
                    {
                        prop.Value = assessmentId;
                    }


                    // ignore any columns that we are supposed to ignore
                    var ruleIgnore = xColumnRules.SelectSingleNode(string.Format("//Table[@name='{0}']/Column[@name='{1}']/Rule[@action='ignore']", tableName, colName));
                    if (ruleIgnore != null)
                    {
                        continue;
                    }

                    // default null dates
                    var ruleDefaultDate = xColumnRules.SelectSingleNode(string.Format("//Table[@name='{0}']/Column[@name='{1}']/Rule[@action='defaultDatetime']", tableName, colName));
                    if (prop.Value.Type == JTokenType.Null && ruleDefaultDate != null)
                    {
                        prop.Value = DateTime.Now;
                    }

                    // mapped ID
                    var ruleMappedID = xColumnRules.SelectSingleNode(string.Format("//Table[@name='{0}']/Column[@name='{1}']/Rule[@action='useMap']", tableName, colName));
                    if (ruleMappedID != null)
                    {
                        prop.Value = mapIdentity[ruleMappedID.InnerText][Convert.ToInt32(prop.Value)];
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


            newIdentity = dbio.Execute(sqlCommandInsert, parms);
            return new Tuple<int, int>(oldIdentity, newIdentity);
        }
    }
}
