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
        int _assessmentId;

        private DBIO dbio = null;

        Dictionary<string, string> identityColumns = null;
        DataTable schema = null;

        XmlDocument xColumnRules = new XmlDocument();


        /// <summary>
        /// Maps old keys to new keys.
        /// </summary>
        Dictionary<string, Dictionary<int, int>> mapIdentity = new Dictionary<string, Dictionary<int, int>>();


        /// <summary>
        /// A list of any database errors that occurred.
        /// </summary>
        List<string> errors = new List<string>();

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentId"></param>
        public GenericImporter(int assessmentId)
        {
            this._assessmentId = assessmentId;
        }


        /// <summary>
        /// Process each table in the ColumnImportRules.xml document, converting JSON to a database INSERT or UPDATE query
        /// based on the data found in the JSON.
        /// </summary>
        public void SaveFromJson(string json)
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
            foreach (XmlNode xTable in tableList)
            {
                var tableName = xTable.Attributes["name"].Value;


                // find all objects for the target table and convert each to a database row
                var jObjs = oAssessment.SelectToken("$.j" + tableName);
                if (jObjs != null)
                {
                    foreach (var jObj in jObjs)
                    {
                        try
                        {
                            var idMap = UpdateDatabaseRow(jObj, xTable as XmlElement);

                            AddKeyMapping(tableName, idMap);
                        }
                        catch (Exception exc)
                        {
                            throw new Exception("CSET import data exception", exc);
                        }
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="jObj"></param>
        /// <param name="tableName"></param>
        private Tuple<int, int> UpdateDatabaseRow(JToken jObj, XmlElement xTable)
        {
            var tableName = xTable.Attributes["name"].Value;

            int oldIdentity = -1;
            int newIdentity = -1;

            List<string> columnNames = new List<string>();
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


                    // if the assessment ID was exported as 0, don't try to import this record.  The record is likely not valid.
                    if (colName.ToLower() == "assessment_id" && Convert.ToInt32(prop.Value) == 0)
                    {
                        return new Tuple<int, int>(-1, -1);
                    }


                    // set assessment ID
                    if (colName.ToLower() == "assessment_id"
                        || colName.ToLower() == "assessement_id"
                        || (tableName.ToLower() == "information" && colName.ToLower() == "id"))
                    {
                        prop.Value = _assessmentId;
                    }


                    // ignore any columns that we are supposed to ignore
                    var ruleIgnore = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='ignore']", tableName, colName));
                    if (ruleIgnore != null)
                    {
                        continue;
                    }

                    // handle null values as needed
                    if (prop.Value.Type == JTokenType.Null)
                    {
                        HandleNulls(xTable, tableName, colName, prop);
                    }

                    // convert dummy '0' ID values to null 
                    var ruleZeroToNull = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='zeroToNull']", tableName, colName));
                    if (ruleZeroToNull != null && Convert.ToInt32(prop.Value) == 0)
                    {
                        prop.Value = null;
                    }


                    // mapped ID
                    var ruleMappedID = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='useMap']", tableName, colName));
                    if (ruleMappedID != null)
                    {
                        var sourceTable = ruleMappedID.Attributes["sourcetable"]?.InnerText;

                        if (prop.Value.Type != JTokenType.Null)
                        {
                            int oldValue = Convert.ToInt32(prop.Value);

                            var d = mapIdentity[sourceTable];
                            if (d.ContainsKey(oldValue))
                            {
                                prop.Value = d[oldValue];
                            }
                            else
                            {
                                // we didn't find the old key - do nothing
                            }
                        }
                    }


                    // Add column names and values to collections used to build queries
                    columnNames.Add(colName);
                    Type t = dt.Columns[colName].DataType;
                    parms.Add(string.Format("@{0}", colName),
                        (prop.Value.Type == JTokenType.Null) ? System.DBNull.Value : Convert.ChangeType(prop.Value, t));
                }
            }


            string sql = "";
            if (xTable.SelectSingleNode("Rule[@action='overlay']") != null)
            {
                sql = BuildUpdateQuery(xTable, columnNames);
            }
            else
            {
                sql = BuildInsertQuery(xTable, columnNames);
            }

            try
            {
                newIdentity = dbio.Execute(sql, parms);
            }
            catch (Exception exc)
            {
                errors.Add(exc.Message);
            }
            return new Tuple<int, int>(oldIdentity, newIdentity);
        }


        /// <summary>
        /// Handle null values in the JSON in a variety of ways.
        /// </summary>
        /// <param name="xTable"></param>
        /// <param name="tableName"></param>
        /// <param name="colName"></param>
        /// <param name="prop"></param>
        private void HandleNulls(XmlElement xTable, string tableName, string colName, JProperty prop)
        {
            switch ((tableName + "|" + colName).ToLower())
            {
                case "answer|component_guid":
                    prop.Value = Guid.Empty;
                    break;
            }


            // default null dates
            var ruleDefaultDate = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='defaultDatetime']", tableName, colName));
            if (ruleDefaultDate != null)
            {
                prop.Value = DateTime.Now;
            }


            // convert a null into the specified value
            var ruleConvertNull = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='convertNullTo']", tableName, colName));
            if (ruleConvertNull != null)
            {
                prop.Value = ruleConvertNull.InnerText;
            }
        }


        /// <summary>
        /// Returns an INSERT query.
        /// </summary>
        /// <param name="xTable"></param>
        /// <param name="columnNames"></param>
        /// <returns></returns>
        private string BuildInsertQuery(XmlElement xTable, List<string> columnNames)
        {
            var tableName = xTable.Attributes["name"].Value;

            string columns = string.Join(",", columnNames);
            string values = string.Join(",", columnNames.Select(c => string.Format("@{0}", c)));
            return string.Format("INSERT INTO dbo.{0}({1}) VALUES ({2})", tableName, columns, values);
        }


        /// <summary>
        /// Returns an UPDATE query.
        /// This could be improved in the future, if we want to be able to update multi-column primary key tables.
        /// </summary>
        /// <param name="xTable"></param>
        /// <param name="columnNames"></param>
        /// <returns></returns>
        private string BuildUpdateQuery(XmlElement xTable, List<string> columnNames)
        {
            // assume that this 'overlay' table has a single-column primary key.  
            var keyColumns = xTable.SelectNodes("Column[@pk='true']");
            var keyColumnName = keyColumns[0].Attributes["name"].InnerText;

            var tableName = xTable.Attributes["name"].Value;

            List<string> assignmentList = new List<string>();
            for (int i = 0; i < columnNames.Count; i++)
            {
                assignmentList.Add(string.Format("{0} = {1}", columnNames[i], string.Format("@{0}", columnNames[i])));
            }
            string assignments = string.Join(",", assignmentList);
            return string.Format("UPDATE dbo.{0} SET {1} WHERE {2} = {3}", tableName, assignments, keyColumnName, _assessmentId);
        }


        /// <summary>
        /// Adds a mapping of old and new keys for a table.
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="idMap"></param>
        private void AddKeyMapping(string tableName, Tuple<int, int> idMap)
        {
            if (idMap.Item1 == -1 && idMap.Item2 == -1)
            {
                // No new identity key was created.  Nothing to do.
                return;
            }

            if (mapIdentity.ContainsKey(tableName))
            {
                mapIdentity[tableName].Add(idMap.Item1, idMap.Item2);
            }
            else
            {
                var d = new Dictionary<int, int>();
                d.Add(idMap.Item1, idMap.Item2);
                mapIdentity.Add(tableName, d);
            }
        }
    }
}
