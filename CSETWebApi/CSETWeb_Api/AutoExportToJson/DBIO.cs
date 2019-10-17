using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoExportToJson
{
    /// <summary>
    /// 
    /// </summary>
    public class DBIO
    {
        /// <summary>
        /// Returns a DataTable with the results of the parameterized sql supplied.
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="parms"></param>
        /// <returns></returns>
        public static DataTable Select(string sql, Dictionary<string, object> parms)
        {
            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter())
                {
                    adapter.SelectCommand = new SqlCommand(sql, conn);

                    if (parms != null)
                    {
                        foreach (var parm in parms)
                        {
                            adapter.SelectCommand.Parameters.Add(new SqlParameter {
                                ParameterName = parm.Key,
                                Value = parm.Value
                            });
                        }
                    }

                    DataSet dataset = new DataSet();
                    adapter.Fill(dataset);
                    return dataset.Tables[0];
                }
            }
        }
    }
}
