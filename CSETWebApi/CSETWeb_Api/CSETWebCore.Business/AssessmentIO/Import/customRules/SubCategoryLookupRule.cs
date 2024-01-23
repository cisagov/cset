//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using CSETWebCore.Business.ImportAssessment;
using CSETWebCore.Helpers;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import.CustomRules
{
    class SubCategoryLookupRule : IImportAssessmentRule
    {
        private static Dictionary<string, string> oldToNewValues = new Dictionary<string, string>();
        private DBIO dBIO;

        static SubCategoryLookupRule()
        {
            oldToNewValues.Add("Integrated Info Security", "Integrated Information Security");
            oldToNewValues.Add("Info System Recovery", "Information System Recovery");
            oldToNewValues.Add("Info Protection", "Information Protection");
            oldToNewValues.Add("System Level Least Priviledges", "System Level Least Privileges");
        }
        private string DataExceptions(string value)
        {
            string newValue;
            if (String.IsNullOrWhiteSpace(value))
                return value;
            if (oldToNewValues.TryGetValue(value, out newValue))
            {
                return newValue;
            }
            return value;
        }


        public void ProcessRule(JToken jObj, XmlElement xTable, DBIO dBIO)
        {
            //we actually have a pair id so we don't need to
            //look it up
            //else look it up
            if (jObj.Value<int?>("Heading_Pair_Id") != 0)
            {
                return;
            }
            this.dBIO = dBIO;
            string ucat = jObj.Value<string>("Universal_Sub_Category");
            string qgh = jObj.Value<string>("Question_Group_Heading");
            //lookup the pairid and set it on the jObj
            DataTable dt = findValues(ucat, qgh);
            if (dt.Rows.Count == 0)
            {
                //process any values that we know
                ucat = DataExceptions(ucat);
                dt = findValues(ucat, qgh);

            }
            foreach (DataRow row in dt.Rows)
            {
                jObj["Heading_Pair_Id"] = row["Heading_Pair_Id"].ToString();
            }
        }

        private DataTable findValues(string ucat, string qgh)
        {
            string query = "SELECT [Heading_Pair_Id]" +
            "      ,[Question_Group_Heading]" +
            "      ,[Universal_Sub_Category]" +
            "      ,[Sub_Heading_Question_Description]" +
            "  FROM [vQUESTION_HEADINGS]" +
            " where Question_Group_Heading = '{0}' and Universal_Sub_Category = '{1}'";
            DataTable dt = dBIO.Select(string.Format(query, qgh, ucat), null);
            return dt;
        }

        //internal void ProcessRule(JToken jRow, XmlElement xTable, DBIO dbio)
        //{
        //    throw new NotImplementedException();
        //}
    }
}
