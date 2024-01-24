//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using FastMember;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;

namespace CSETWebCore.ExportCSV
{
    public class CSETtoExcelDocument
    {
        private DataSet ds = new DataSet();


        /// <summary>
        /// add the list to the workbook as a new sheet
        /// </summary>
        /// <param name="list"></param>        
        public void AddList<T>(List<T> list, String name, String[] order)
        {
            var table = new DataTable();
            table.TableName = name;
            using (var reader = ObjectReader.Create(list, order))
            {
                table.Load(reader);
            }
            AddDataTable(table);
        }



        public void AddDataTable(DataTable dt)
        {
            ds.Tables.Add(dt);
        }

        /// <summary>
        /// Note that this writes the excel file
        /// and launches excel with that file
        /// it needs changed to be written to a blob in the 
        /// database.  That can then be requested with a link.
        /// </summary>
        /// <param name="filePath"></param>
        public void WriteExcelFile(MemoryStream stream, List<DataMap> list)
        {
            CreateExcelFile file = new CreateExcelFile();
            file.CreateExcelDocument(stream, ds, list);
        }

    }
}