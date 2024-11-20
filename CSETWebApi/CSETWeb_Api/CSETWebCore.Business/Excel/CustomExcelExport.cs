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
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    public class CustomExcelExport
    {
        private CSETContext context;
        private int assessmentId;

        public CustomExcelExport(CSETContext context)
        {
            this.context = context;            
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<IWorkbook> ExportExcel(int assessmentId)
        {
            var rlist = await this.context.Procedures.usp_CF_QuestionsAsync(assessmentId);

            DataTable usersTable = new DataTable();
            usersTable.Columns.Add("Standard Category");
            usersTable.Columns.Add("Standard Sub Category");
            usersTable.Columns.Add("Requirement Text");
            usersTable.Columns.Add("Requirement Title");
            usersTable.Columns.Add("Answer Value");

            foreach (var r in rlist) {
                DataRow userRow = usersTable.NewRow();
                userRow["Standard Category"] = r.Standard_Category;
                userRow["Standard Sub Category"] = r.Standard_Sub_Category;
                userRow["Requirement Text"] = r.requirement_text;
                userRow["Requirement Title"] = r.Requirement_Title;
                userRow["Answer Value"] = r.Display_Tag;
                usersTable.Rows.Add(userRow);
            }
            
            
            IWorkbook wb = RenderDataTableToExcel(usersTable);
            return wb;
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