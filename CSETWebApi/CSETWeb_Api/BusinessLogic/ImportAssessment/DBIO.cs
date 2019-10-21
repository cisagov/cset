using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    /// <summary>
    /// Database helper class.
    /// </summary>
    public class DBIO
    {
        /// <summary>
        /// Returns a DataTable with the results of the parameterized sql supplied.
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="parms"></param>
        /// <returns></returns>
        public DataTable Select(string sql, Dictionary<string, object> parms)
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
                            adapter.SelectCommand.Parameters.Add(new SqlParameter
                            {
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

        /// <summary>
        /// Executes a sql query.  Returns the identity, if any.
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="parms"></param>
        /// <returns></returns>
        public int Execute(string sql, Dictionary<string, object> parms)
        {
            int rows = 0;

            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.Transaction = conn.BeginTransaction();

                try
                {
                    foreach (var key in parms.Keys)
                    {
                        SqlParameter parm = new SqlParameter(key, parms[key]);

                        if (parm.Value == null)
                        {
                            parm.Value = DBNull.Value;
                        }

                        cmd.Parameters.Add(parm);
                    }

                    rows = cmd.ExecuteNonQuery();

                    cmd.Transaction.Commit();

                }
                catch (Exception exc1)
                {
                    throw exc1;
                }
                finally
                {
                    conn.Dispose();
                }
            }

            return rows;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataTable GetSchema()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                DataTable metaDataTable = conn.GetSchema("Columns");
                return metaDataTable;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public Dictionary<string, string> GetIdentityColumnNames()
        {
            var dict = new Dictionary<string, string>();

            const string sql =
                 "select TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS "
               + "where TABLE_SCHEMA = 'dbo' and COLUMNPROPERTY(object_id(TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 "
               + "order by TABLE_NAME";


            DataTable schema = Select(sql, null);
            foreach (DataRow row in schema.Rows)
            {
                dict.Add(row[1] as string, row[2] as string);
            }

            return dict;
        }
    }
}
