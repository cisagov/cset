//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Data;
using System.IO;

namespace CSETWebCore.Api.Controllers
{
    public class CustomExcelExport
    {
        private CSETContext context;
        private int assessmentId;

        public CustomExcelExport(CSETContext context, int assessmentId)
        {
            this.context = context;
            this.assessmentId = assessmentId;
        }

        public MemoryStream ExportExcel(int assessmentId)
        {

            
        }

        private XSSFWorkbook RenderDataTableToExcel(DataTable SourceTable)
        {
            XSSFWorkbook workbook = null;            
            ISheet sheet = null;
            XSSFRow headerRow = null;
            
            workbook = new XSSFWorkbook();                
            sheet = workbook.CreateSheet();
            headerRow = (XSSFRow)sheet.CreateRow(0);
            foreach (DataColumn column in SourceTable.Columns)
                headerRow.CreateCell(column.Ordinal).SetCellValue(column.ColumnName);
            int rowIndex = 1;
            foreach (DataRow row in SourceTable.Rows)
            {
                XSSFRow dataRow = (XSSFRow)sheet.CreateRow(rowIndex);
                foreach (DataColumn column in SourceTable.Columns)
                    dataRow.CreateCell(column.Ordinal).SetCellValue(row[column].ToString());
                ++rowIndex;
            }
            for (int i = 0; i <= SourceTable.Columns.Count; ++i)
                sheet.AutoSizeColumn(i);
            return workbook;
            
        }
    }
}