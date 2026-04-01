////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Npgsql;
using NpgsqlTypes;
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


        public void BulkExecute(DataTable dataTable, string tableName)
        {
            var connStr = _context.ConnectionString;

            using (NpgsqlConnection connection = new NpgsqlConnection(connStr))
            {
                connection.Open();
                var cols = string.Join(",", dataTable.Columns.Cast<DataColumn>().Select(c => $"\"{c.ColumnName}\""));
                var copyCommand = $"COPY \"{tableName}\" ({cols}) FROM STDIN (FORMAT BINARY)";
                using var writer = connection.BeginBinaryImport(copyCommand);
                foreach (DataRow row in dataTable.Rows)
                {
                    writer.StartRow();
                    foreach (var item in row.ItemArray)
                        writer.Write(item == DBNull.Value ? DBNull.Value : item);
                }
                writer.Complete();
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

            using (NpgsqlConnection conn = new NpgsqlConnection(connStr))
            {
                conn.Open();

                NpgsqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = sql;
                cmd.CommandText += "; select LASTVAL();";

                cmd.Transaction = conn.BeginTransaction();

                try
                {
                    foreach (KeyValuePair<string, ObjectTypePair> pair in parms)
                    {
                        NpgsqlParameter parm = null;
                        switch (pair.Value.Type)
                        {
                            case 1: //normal type
                                parm = new NpgsqlParameter(pair.Key, pair.Value.ParmValue ?? DBNull.Value);
                                break;
                            case 2: //bytea
                                if ((pair.Value.ParmValue) == DBNull.Value)
                                {
                                    parm = new NpgsqlParameter(pair.Key, NpgsqlDbType.Bytea);
                                    parm.Value = DBNull.Value;
                                }
                                else
                                {
                                    byte[] bytes = (byte[])pair.Value.ParmValue;
                                    parm = new NpgsqlParameter(pair.Key, NpgsqlDbType.Bytea);
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
                        NpgsqlParameter parm = new NpgsqlParameter(key, parms[key] ?? DBNull.Value);
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
                 "SELECT table_schema, table_name, column_name FROM information_schema.columns "
               + "WHERE table_schema = 'public' AND column_default LIKE 'nextval%' "
               + "ORDER BY table_name";

            DataTable schema = Select(sql, null);
            foreach (DataRow row in schema.Rows)
            {
                dict.Add(row[1] as string, row[2] as string);
            }

            return dict;
        }
    }
}
