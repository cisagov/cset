//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Data;

namespace CSETWebCore.Interfaces.ReportEngine
{
    public interface IDataHandling
    {
        DataColumn BuildTableColumn(string columnName, string columnType = "System.String", bool allowDBNull = true);
        void WriteEmptyMessage(DataTable table, string columnName, string message);
    }
}