//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using Microsoft.Data.SqlClient;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Database helper class.
    /// </summary>
    public class DBIO
    {
        private readonly CSETContext _context;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public DBIO(CSETContext context)
        {
            this._context = context;
        }


        /// <summary>
        /// Returns a DataTable with the results of the parameterized sql supplied.
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="parms"></param>
        /// <returns></returns>
        public DataTable Select(string sql, Dictionary<string, object> parms)
        {
            var connStr = _context.ConnectionString;

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


        public void BulkExecute(DataTable dataTable, string tableName)
        {
            var connStr = _context.ConnectionString;

            using (SqlConnection connection = new SqlConnection(connStr))
            {
                var transaction = connection.BeginTransaction();
                SqlBulkCopy bulkCopy = new SqlBulkCopy(connection, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.FireTriggers | SqlBulkCopyOptions.UseInternalTransaction
                    , transaction);

                // set the destination table name
                bulkCopy.DestinationTableName = tableName;
                connection.Open();
                // write the data in the "dataTable"
                bulkCopy.WriteToServer(dataTable);
                connection.Close();
            }
        }


        /// <summary>
        /// Executes a sql query.  Returns the identity, if any.
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="parms"></param>
        /// <returns></returns>
        public int Execute(string sql, Dictionary<string, ObjectTypePair> parms)
        {
            int modified = -1;

            var connStr = _context.ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandText += "; select SCOPE_IDENTITY();";

                cmd.Transaction = conn.BeginTransaction();

                try
                {
                    foreach (KeyValuePair<string, ObjectTypePair> pair in parms)
                    {
                        SqlParameter parm = null;
                        switch (pair.Value.Type)
                        {
                            case 1: //normal type
                                parm = new SqlParameter(pair.Key, pair.Value.ParmValue);
                                if (pair.Value.ParmValue == null)
                                {
                                    parm.Value = DBNull.Value;
                                }
                                break;
                            case 2: //varbinary
                                if ((pair.Value.ParmValue) == DBNull.Value)
                                {
                                    parm = new SqlParameter(pair.Key, SqlDbType.VarBinary, -1);
                                    parm.Value = DBNull.Value;
                                }
                                else
                                {
                                    byte[] bytes = (byte[])pair.Value.ParmValue;
                                    parm = new SqlParameter(pair.Key, SqlDbType.VarBinary, bytes.Length);
                                    parm.Value = bytes;
                                }
                                break;
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
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                    throw;
                }
                finally
                {
                    conn.Dispose();
                }
            }

            return modified;
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

            var connStr = _context.ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandText += "; select SCOPE_IDENTITY();";

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

                    object identityResponse = cmd.ExecuteScalar();
                    if (identityResponse != DBNull.Value)
                    {
                        modified = Convert.ToInt32(identityResponse);
                    }

                    cmd.Transaction.Commit();

                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                    throw;
                }
                finally
                {
                    conn.Dispose();
                }
            }

            return modified;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataTable GetSchema()
        {
            var connStr = _context.ConnectionString;

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
