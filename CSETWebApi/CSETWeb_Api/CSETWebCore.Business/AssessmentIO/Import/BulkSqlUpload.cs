//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using Npgsql;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    public class BulkUploadToSql<T>
    {
        public IList<T> InternalStore { get; set; }
        public string TableName { get; set; }
        public int CommitBatchSize { get; set; } = 2000;
        public string ConnectionString { get; set; }

        public void Commit()
        {
            if (InternalStore.Count > 0)
            {
                DataTable dt;
                int numberOfPages = (InternalStore.Count / CommitBatchSize) + (InternalStore.Count % CommitBatchSize == 0 ? 0 : 1);
                for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++)
                {
                    dt = InternalStore.Skip(pageIndex * CommitBatchSize).Take(CommitBatchSize).ToDataTable();
                    BulkInsert(dt);
                }
            }
        }

        public void BulkInsert(DataTable dt)
        {
            using (NpgsqlConnection connection = new NpgsqlConnection(ConnectionString))
            {
                connection.Open();

                // Build column list from DataTable
                var columns = new List<string>();
                foreach (DataColumn col in dt.Columns)
                {
                    columns.Add($"\"{col.ColumnName}\"");
                }
                var columnList = string.Join(", ", columns);

                // Use PostgreSQL COPY command for bulk insert
                // Note: PostgreSQL doesn't have equivalent to SqlBulkCopyOptions.FireTriggers
                // Triggers will fire by default on COPY in PostgreSQL
                var copyCommand = $"COPY {TableName} ({columnList}) FROM STDIN (FORMAT BINARY)";

                using (var writer = connection.BeginBinaryImport(copyCommand))
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        writer.StartRow();
                        foreach (var item in row.ItemArray)
                        {
                            writer.Write(item ?? DBNull.Value);
                        }
                    }
                    writer.Complete();
                }

                connection.Close();
            }
        }
    }

    public static class BulkUploadToSqlHelper
    {
        public static DataTable ToDataTable<T>(this IEnumerable<T> data)
        {
            PropertyDescriptorCollection properties =
                TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;
        }
    }
}

