using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
    public class ExportDbToJson
    {
        public void Go()
        {
            var dtAssessments = DBIO.Select("select * from assessments where assessment_id = @id", 
                new Dictionary<string, object> {
                { "@id", 3 }
            });


            JObject top = new JObject();
            


            var results = MakeObjects(dtAssessments);

            var children = new JArray();
            top.Add(new JProperty("children", children));
            foreach (var r in results)
            {
                children.Add(r);
            }
            

            var a = 1;

        }


        private List<JObject> MakeObjects(DataTable dt)
        {
            var l = new List<JObject>();

            foreach (DataRow row in dt.Rows)
            {
                JObject jObj = new JObject();
                foreach (DataColumn col in dt.Columns)
                {
                    jObj.Add(new JProperty(col.ColumnName, row[col.ColumnName]));
                }

                l.Add(jObj);
            }
            return l;
        }

    
    }
}
