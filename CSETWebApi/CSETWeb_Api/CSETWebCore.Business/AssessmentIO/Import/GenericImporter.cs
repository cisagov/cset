//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Import.CustomRules;
using CSETWebCore.Helpers;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Xml;


namespace CSETWebCore.Business.AssessmentIO.Import
{
    public class GenericImporter
    {
        int _assessmentId;

        private DBIO dbio = null;

        private static Type byteArray;

        static GenericImporter()
        {
            System.Byte[] b = new Byte[0];
            byteArray = b.GetType();
        }

        Dictionary<string, string> identityColumns = null;
        DataTable schema = null;


        /// <summary>
        /// 
        /// </summary>
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
        /// 
        /// </summary>
        private Dictionary<string, DataTable> tableStructures = new Dictionary<string, DataTable>();


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentId"></param>
        public GenericImporter(int assessmentId)
        {
            this._assessmentId = assessmentId;
        }


        /// <summary>
        /// Adds identity mapping that happened outside of this class.
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="map"></param>
        public void SetManualIdentityMaps(Dictionary<string, Dictionary<int, int>> map)
        {
            foreach (string tableName in map.Keys)
            {
                mapIdentity.Add(tableName, map[tableName]);
            }
        }


        /// <summary>
        /// Process each table in the ColumnImportRules.xml document, converting JSON to a database INSERT or UPDATE query
        /// based on the data found in the JSON.
        /// </summary>
        public void SaveFromJson(string json, DataLayer.Model.CSETContext context)
        {
            JObject oAssessment = JObject.Parse(json);

            dbio = new DBIO(context);

            identityColumns = dbio.GetIdentityColumnNames();
            schema = dbio.GetSchema();

            var assembly = Assembly.GetExecutingAssembly();
            using (Stream stream = assembly.GetManifestResourceStream("CSETWebCore.Business.AssessmentIO.Import.ColumnImportRules.xml"))
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


                // find all objects for the target table and convert each to a query
                // send the whole batch off
                // select out all the id's and add to mapping
                //
                var jRowsForTable = oAssessment.SelectToken("$.j" + tableName);
                if (jRowsForTable != null)
                {
                    //get all the 
                    foreach (var jRow in jRowsForTable)
                    {
                        if (!jRow.HasValues)
                        {
                            continue;
                        }
                        try
                        {
                            var idMap = UpdateDatabaseRow(jRow, xTable as XmlElement);

                            AddKeyMapping(tableName, idMap);
                        }
                        catch (Exception exc)
                        {
                            NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                            throw new Exception("CSET import data exception", exc);
                        }
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="jRow"></param>
        /// <param name="tableName"></param>
        private Tuple<int, int> UpdateDatabaseRow(JToken jRow, XmlElement xTable)
        {
            var tableName = xTable.Attributes["name"].Value;

            int oldIdentity = -1;
            int newIdentity = -1;

            List<string> columnNames = new List<string>();
            Dictionary<string, ObjectTypePair> parms = new Dictionary<string, ObjectTypePair>();


            DataTable dt;
            if (!tableStructures.TryGetValue(tableName, out dt))
            {
                dt = dbio.Select(string.Format("select * from {0} where 1 = 2", tableName), null);
                tableStructures.Add(tableName, dt);
            }
            else
            {
                dt.Rows.Clear();
            }


            DataRow row = dt.NewRow();
            var jColumns = jRow.Children<JToken>().ToList();
            // for (var i = 0; i < jColumns.Count(); i++)
            foreach (var jColumn in jColumns)
            {
                if (jColumn.Type == JTokenType.Property)
                {
                    var prop = jColumn as JProperty;

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


                    // process custom rules
                    var ruleCustom = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='custom']", tableName, colName));
                    if (ruleCustom != null)
                    {
                        switch (ruleCustom.Attributes["name"].InnerText)
                        {
                            case "SubCategoryLookupRule":
                                SubCategoryLookupRule sublookup = new SubCategoryLookupRule();
                                sublookup.ProcessRule(jRow, xTable, dbio);
                                break;
                        }
                    }


                    // ignore any columns that we are supposed to ignore
                    var ruleIgnore = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='ignore']", tableName, colName));
                    if (ruleIgnore != null)
                    {
                        continue;
                    }

                    // ignore importing any specified columns if they already have matching value in database
                    var ruleIgnoreIfExists = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='ignoreIfExists']", tableName, colName));
                    if (ruleIgnoreIfExists != null)
                    {
                        bool columnValueExists = CheckColumnValueExistence(colName, tableName, jRow, dbio);
                        if (columnValueExists)
                        {
                            continue;
                        }
                    }


                    // handle null values as needed
                    if (prop.Value.Type == JTokenType.Null)
                    {
                        HandleNulls(xTable, tableName, colName, prop);
                    }
                    // convert dummy '0' ID values to null 
                    var ruleZeroToNull = xTable.SelectSingleNode(string.Format("Column[@name='{1}']/Rule[@action='zeroToNull']", tableName, colName));
                    if(prop.Value.HasValues)
                    if (ruleZeroToNull != null && prop.Value != null && Convert.ToInt32(prop.Value ?? 0) == 0)
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
                    int valueType = 1;

                    if (t == byteArray)
                    {
                        valueType = 2;
                    }
                    parms.Add(string.Format("@{0}", colName),
                        new ObjectTypePair()
                        {
                            ParmValue = (prop.Value.Type == JTokenType.Null) ? System.DBNull.Value : Convert.ChangeType(prop.Value, t),
                            Type = valueType
                        });
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

        private bool CheckColumnValueExistence(string colName, string tableName, JToken jObj, DBIO dbio)
        {
            string query = "SELECT [{0}]" +
            "  FROM [{1}]" +
            " where {0} = '{2}'";
            DataTable dt = dbio.Select(string.Format(query, colName, tableName, jObj[colName]), null);

            if (dt.Rows.Count > 0)
            {
                return true;
            }

            return false;
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
