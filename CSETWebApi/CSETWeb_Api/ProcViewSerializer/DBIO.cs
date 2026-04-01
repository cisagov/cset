//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using Npgsql;

namespace ProcViewSerializer
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

            using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
            {
                using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter())
                {
                    adapter.SelectCommand = new NpgsqlCommand(sql, conn);

                    if (parms != null)
                    {
                        foreach (var parm in parms)
                        {
                            adapter.SelectCommand.Parameters.Add(new NpgsqlParameter
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
            int modified = -1;

            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
            {
                conn.Open();

                NpgsqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandText += "; select LASTVAL();";

                cmd.Transaction = conn.BeginTransaction();

                try
                {
                    foreach (var key in parms.Keys)
                    {
                        NpgsqlParameter parm = new NpgsqlParameter(key, parms[key]);

                        if (parm.Value == null)
                        {
                            parm.Value = DBNull.Value;
                        }

                        cmd.Parameters.Add(parm);
                    }

                    object identityResponse = cmd.ExecuteScalar();
                    if (identityResponse != DBNull.Value)
                    {
                        modified = Convert.ToInt32(identityResponse);
                    }

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

            return modified;
        }


        public DataTable ExecuteProcedure(string procName, Dictionary<string, object> parms)
        {
            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
            {
                conn.Open();

                NpgsqlCommand cmd = new NpgsqlCommand(procName, conn);

                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                adapter.SelectCommand.CommandType = CommandType.StoredProcedure;

                if (parms != null)
                {
                    foreach (var parm in parms)
                    {
                        adapter.SelectCommand.Parameters.Add(new NpgsqlParameter
                        {
                            ParameterName = parm.Key,
                            Value = parm.Value
                        });
                    }
                }

                DataTable dt = new DataTable();
                adapter.Fill(dt);

                return dt;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataTable GetSchema()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;

            using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
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

