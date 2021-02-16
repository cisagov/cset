//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Data;

namespace CSET_Main.ReportEngine.Builder
{
    public interface IDataHandling
    {
        DataColumn BuildTableColumn(string columnName, string columnType = "System.String", bool allowDBNull = true);
        void WriteEmptyMessage(DataTable table, string columnName, string message);
    }
}

