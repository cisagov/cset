//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Data;
using CSETWebCore.Interfaces.ReportEngine;

namespace CSETWebCore.Business.ReportEngine
{
    public class DataHandling : IDataHandling
    {
        /// <summary>
        /// Creates a column for a DataTable
        /// </summary>
        /// <param name="columnName"></param>
        /// <param name="caption"></param>
        /// <param name="columnType"></param>
        /// <param name="allowDBNull"></param>
        /// <returns></returns>
        public DataColumn BuildTableColumn(string columnName, string columnType = "System.String", bool allowDBNull = true)
        {
            DataColumn column = new DataColumn(columnName);
            column.DataType = System.Type.GetType(columnType);
            column.AllowDBNull = true;
            column.Caption = columnName;
            return column;
        }
        /// <summary>
        /// Creates a new row on the passed table and adds the message text to value for the passed column.
        /// Used mainly to add text to a field that is empty.
        /// </summary>
        /// <param name="table"></param>
        /// <param name="columnName"></param>
        /// <param name="message"></param>
        public void WriteEmptyMessage(DataTable table, string columnName, string message)
        {
            DataRow row = table.NewRow();
            row[columnName] = message;
            table.Rows.Add(row);
        }
    }
}