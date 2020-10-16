using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

namespace Snickler.EFCore
{
    public static class EFExtensions
    {
        /// <summary>
        /// Creates an initial DbCommand object based on a stored procedure name
        /// </summary>
        /// <param name="context">target database context</param>
        /// <param name="storedProcName">target procedure name</param>
        /// <param name="prependDefaultSchema">Prepend the default schema name to <paramref name="storedProcName"/> if explicitly defined in <paramref name="context"/></param>
        /// <param name="commandTimeout">Command timeout in seconds. Default is 30.</param>
        /// <returns></returns>
        public static DbCommand LoadStoredProc(this DbContext context, string storedProcName, bool prependDefaultSchema = true, short commandTimeout = 300)
        {
            var cmd = context.Database.GetDbConnection().CreateCommand();

            cmd.CommandTimeout = commandTimeout;

            if (prependDefaultSchema)
            {
                var schema = context.Model.GetEntityTypes().ToList();
                var schemaName = context.Model.GetEntityTypes().ToList()
                    .Select(e=>e.GetDefaultSchema());
                if (schemaName != null)
                {
                    storedProcName = $"{schemaName.FirstOrDefault()}.{storedProcName}";
                }
            }

            cmd.CommandText = storedProcName;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            return cmd;
        }

        /// <summary>
        /// Creates a DbParameter object and adds it to a DbCommand
        /// </summary>
        /// <param name="cmd"></param>
        /// <param name="paramName"></param>
        /// <param name="paramValue"></param>
        /// <returns></returns>
        public static DbCommand WithSqlParam(this DbCommand cmd, string paramName, object paramValue, Action<DbParameter> configureParam = null)
        {
            if (string.IsNullOrEmpty(cmd.CommandText) && cmd.CommandType != System.Data.CommandType.StoredProcedure)
                throw new InvalidOperationException("Call LoadStoredProc before using this method");

            var param = cmd.CreateParameter();
            param.ParameterName = paramName;
            param.Value = (paramValue != null ? paramValue : DBNull.Value);
            configureParam?.Invoke(param);
            cmd.Parameters.Add(param);
            return cmd;
        }

        /// <summary>
        /// Creates a DbParameter object and adds it to a DbCommand
        /// </summary>
        /// <param name="cmd"></param>
        /// <param name="paramName"></param>
        /// <param name="paramValue"></param>
        /// <returns></returns>
        public static DbCommand WithSqlParam(this DbCommand cmd, string paramName, Action<DbParameter> configureParam = null)
        {
            if (string.IsNullOrEmpty(cmd.CommandText) && cmd.CommandType != System.Data.CommandType.StoredProcedure)
                throw new InvalidOperationException("Call LoadStoredProc before using this method");

            var param = cmd.CreateParameter();
            param.ParameterName = paramName;
            configureParam?.Invoke(param);
            cmd.Parameters.Add(param);
            return cmd;
        }

        /// <summary>
        /// Creates a DbParameter object based on the SqlParameter and adds it to a DbCommand.
        /// This enabled the ability to provide custom types for SQL-parameters.
        /// </summary>
        /// <param name="cmd"></param>
        /// <param name="paramName"></param>
        /// <param name="paramValue"></param>
        /// <returns></returns>
        public static DbCommand WithSqlParam(this DbCommand cmd, string paramName, SqlParameter parameter)
        {
            if (string.IsNullOrEmpty(cmd.CommandText) && cmd.CommandType != System.Data.CommandType.StoredProcedure)
                throw new InvalidOperationException("Call LoadStoredProc before using this method");

            //var param = cmd.CreateParameter();
            //param.ParameterName = paramName;
            //configureParam?.Invoke(param);
            cmd.Parameters.Add(parameter);

            return cmd;
        }

        public class SprocResults
        {

            //  private DbCommand _command;
            private DbDataReader _reader;

            public SprocResults(DbDataReader reader)
            {
                // _command = command;
                _reader = reader;
            }

            public IList<T> ReadToList<T>()
            {
                return MapToList<T>(_reader);
            }

            public T? ReadToValue<T>() where T : struct
            {
                return MapToValue<T>(_reader);
            }

            public Task<bool> NextResultAsync()
            {
                return _reader.NextResultAsync();
            }

            public Task<bool> NextResultAsync(CancellationToken ct)
            {
                return _reader.NextResultAsync(ct);
            }

            public bool NextResult()
            {
                return _reader.NextResult();
            }

            /// <summary>
            /// Retrieves the column values from the stored procedure and maps them to <typeparamref name="T"/>'s properties
            /// </summary>
            /// <typeparam name="T"></typeparam>
            /// <param name="dr"></param>
            /// <returns>IList<<typeparamref name="T"/>></returns>
            private IList<T> MapToList<T>(DbDataReader dr)
            {
                var objList = new List<T>();
                var props = typeof(T).GetRuntimeProperties().ToList();

                var colMapping = GetCustomColumnSchema(dr as Microsoft.Data.SqlClient.SqlDataReader)
                    .Where(x => props.Any(y => y.Name.ToLower() == x.ColumnName.ToLower()))
                    .ToDictionary(key => key.ColumnName.ToLower());

                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        T obj = Activator.CreateInstance<T>();
                        foreach (var prop in props)
                        {
                            if (colMapping.ContainsKey(prop.Name.ToLower()))
                            {
                                var column = colMapping[prop.Name.ToLower()];

                                if (column?.ColumnOrdinal != null)
                                {
                                    var val = dr.GetValue(column.ColumnOrdinal.Value);
                                    prop.SetValue(obj, val == DBNull.Value ? null : val);
                                }

                            }
                        }
                        objList.Add(obj);
                    }
                }
                return objList;
            }

            /// <summary>
            ///Attempts to read the first value of the first row of the resultset.
            /// </summary>
            private T? MapToValue<T>(DbDataReader dr) where T : struct
            {
                if (dr.HasRows)
                {
                    if (dr.Read())
                    {
                        return dr.IsDBNull(0) ? new T?() : new T?(dr.GetFieldValue<T>(0));
                    }
                }
                return new T?();
            }
        }

        /// <summary>
        /// Executes a DbDataReader and returns a list of mapped column values to the properties of <typeparamref name="T"/>
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="command"></param>
        /// <returns></returns>
        public static void ExecuteStoredProc(this DbCommand command, Action<SprocResults> handleResults, System.Data.CommandBehavior commandBehaviour = System.Data.CommandBehavior.Default, bool manageConnection = true)
        {
            if (handleResults == null)
            {
                throw new ArgumentNullException(nameof(handleResults));
            }

            using (command)
            {
                if (manageConnection && command.Connection.State == System.Data.ConnectionState.Closed)
                    command.Connection.Open();
                try
                {
                    using (var reader = command.ExecuteReader(commandBehaviour))
                    {
                        var sprocResults = new SprocResults(reader);
                        // return new SprocResults();
                        handleResults(sprocResults);
                    }
                }
                catch(Exception e)
                {
                    
                }
                finally
                {
                    if (manageConnection)
                    {
                        command.Connection.Close();
                    }
                }
            }
        }

        /// <summary>
        /// Executes a DbDataReader asynchronously and returns a list of mapped column values to the properties of <typeparamref name="T"/>.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="command"></param>
        /// <returns></returns>
        public async static Task ExecuteStoredProcAsync(this DbCommand command, Action<SprocResults> handleResults, System.Data.CommandBehavior commandBehaviour = System.Data.CommandBehavior.Default, CancellationToken ct = default(CancellationToken), bool manageConnection = true)
        {
            if (handleResults == null)
            {
                throw new ArgumentNullException(nameof(handleResults));
            }

            using (command)
            {
                if (manageConnection && command.Connection.State == System.Data.ConnectionState.Closed)
                    await command.Connection.OpenAsync(ct).ConfigureAwait(false);
                try
                {
                    using (var reader = await command.ExecuteReaderAsync(commandBehaviour, ct).ConfigureAwait(false))
                    {
                        var sprocResults = new SprocResults(reader);
                        handleResults(sprocResults);
                    }
                }
                finally
                {
                    if (manageConnection)
                    {
                        command.Connection.Close();
                    }
                }
            }
        }

        /// <summary>
        /// Executes a non-query.
        /// </summary>
        /// <param name="command"></param>
        /// <param name="commandBehaviour"></param>
        /// <param name="manageConnection"></param>
        /// <returns></returns>
        public static int ExecuteStoredNonQuery(this DbCommand command, System.Data.CommandBehavior commandBehaviour = System.Data.CommandBehavior.Default, bool manageConnection = true)
        {
            int numberOfRecordsAffected = -1;

            using (command)
            {
                if (command.Connection.State == System.Data.ConnectionState.Closed)
                {
                    command.Connection.Open();
                }

                try
                {
                    numberOfRecordsAffected = command.ExecuteNonQuery();
                }
                finally
                {
                    if (manageConnection)
                    {
                        command.Connection.Close();
                    }
                }
            }

            return numberOfRecordsAffected;
        }

        /// <summary>
        /// Executes a non-query asynchronously.
        /// </summary>
        /// <param name="command"></param>
        /// <param name="commandBehaviour"></param>
        /// <param name="ct"></param>
        /// <param name="manageConnection"></param>
        /// <returns></returns>
        public async static Task<int> ExecuteStoredNonQueryAsync(this DbCommand command, System.Data.CommandBehavior commandBehaviour = System.Data.CommandBehavior.Default, CancellationToken ct = default(CancellationToken), bool manageConnection = true)
        {
            int numberOfRecordsAffected = -1;

            using (command)
            {
                if (command.Connection.State == System.Data.ConnectionState.Closed)
                {
                    await command.Connection.OpenAsync(ct).ConfigureAwait(false);
                }

                try
                {
                    numberOfRecordsAffected = await command.ExecuteNonQueryAsync().ConfigureAwait(false);
                }
                finally
                {
                    if (manageConnection)
                    {
                        command.Connection.Close();
                    }
                }
            }

            return numberOfRecordsAffected;
        }

        /// <summary>
        /// Custom column schema to support lack of native method.
        /// </summary>
        private static ReadOnlyCollection<DbColumn> GetCustomColumnSchema(Microsoft.Data.SqlClient.SqlDataReader reader)
        {
            IList<DbColumn> columnSchema = new List<DbColumn>();
            DataTable schemaTable = reader.GetSchemaTable();

            // ReSharper disable once PossibleNullReferenceException
            DataColumnCollection schemaTableColumns = schemaTable.Columns;
            foreach (DataRow row in schemaTable.Rows)
            {
                DbColumn dbColumn = new DataRowDbColumn(row, schemaTableColumns);
                columnSchema.Add(dbColumn);
            }

            ReadOnlyCollection<DbColumn> readOnlyColumnSchema = new ReadOnlyCollection<DbColumn>(columnSchema);
            return readOnlyColumnSchema;
        }

    }

    class DataRowDbColumn : DbColumn
    {
        #region Fields

        private readonly DataColumnCollection schemaColumns;
        private readonly DataRow schemaRow;

        #endregion

        #region Constructors and Destructors

        public DataRowDbColumn(DataRow readerSchemaRow, DataColumnCollection readerSchemaColumns)
        {
            this.schemaRow = readerSchemaRow;
            this.schemaColumns = readerSchemaColumns;
            this.PopulateFields();
        }

        #endregion

        #region Methods

        private T GetDbColumnValue<T>(string columnName)
        {
            if (!this.schemaColumns.Contains(columnName))
            {
                return default(T);
            }

            object schemaObject = this.schemaRow[columnName];
            if (schemaObject is T variable)
            {
                return variable;
            }

            return default(T);
        }

        /// <summary>
        /// </summary>
        private void PopulateFields()
        {
            this.AllowDBNull = this.GetDbColumnValue<bool?>(SchemaTableColumn.AllowDBNull);
            this.BaseCatalogName = this.GetDbColumnValue<string>(SchemaTableOptionalColumn.BaseCatalogName);
            this.BaseColumnName = this.GetDbColumnValue<string>(SchemaTableColumn.BaseColumnName);
            this.BaseSchemaName = this.GetDbColumnValue<string>(SchemaTableColumn.BaseSchemaName);
            this.BaseServerName = this.GetDbColumnValue<string>(SchemaTableOptionalColumn.BaseServerName);
            this.BaseTableName = this.GetDbColumnValue<string>(SchemaTableColumn.BaseTableName);
            this.ColumnName = this.GetDbColumnValue<string>(SchemaTableColumn.ColumnName);
            this.ColumnOrdinal = this.GetDbColumnValue<int?>(SchemaTableColumn.ColumnOrdinal);
            this.ColumnSize = this.GetDbColumnValue<int?>(SchemaTableColumn.ColumnSize);
            this.IsAliased = this.GetDbColumnValue<bool?>(SchemaTableColumn.IsAliased);
            this.IsAutoIncrement = this.GetDbColumnValue<bool?>(SchemaTableOptionalColumn.IsAutoIncrement);
            this.IsExpression = this.GetDbColumnValue<bool>(SchemaTableColumn.IsExpression);
            this.IsHidden = this.GetDbColumnValue<bool?>(SchemaTableOptionalColumn.IsHidden);
            this.IsIdentity = this.GetDbColumnValue<bool?>("IsIdentity");
            this.IsKey = this.GetDbColumnValue<bool?>(SchemaTableColumn.IsKey);
            this.IsLong = this.GetDbColumnValue<bool?>(SchemaTableColumn.IsLong);
            this.IsReadOnly = this.GetDbColumnValue<bool?>(SchemaTableOptionalColumn.IsReadOnly);
            this.IsUnique = this.GetDbColumnValue<bool?>(SchemaTableColumn.IsUnique);
            this.NumericPrecision = this.GetDbColumnValue<int?>(SchemaTableColumn.NumericPrecision);
            this.NumericScale = this.GetDbColumnValue<int?>(SchemaTableColumn.NumericScale);
            this.UdtAssemblyQualifiedName = this.GetDbColumnValue<string>("UdtAssemblyQualifiedName");
            this.DataType = this.GetDbColumnValue<Type>(SchemaTableColumn.DataType);
            this.DataTypeName = this.GetDbColumnValue<string>("DataTypeName");
        }

        #endregion
    }
}
