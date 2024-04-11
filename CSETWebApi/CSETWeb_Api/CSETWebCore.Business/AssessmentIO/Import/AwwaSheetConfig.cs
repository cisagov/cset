//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;


namespace CSETWebCore.Business.AssessmentIO.Import
{
    internal class AwwaSheetConfig
    {
        public DataTable dtAPI;
        public int targetSheetStartRow;
        public string cidColRef;
        public string statusColRef;
        private bool MustParse = false;
        public bool sheetIsValid = false;

        public string targetSheetName { get; private set; }


        public AwwaSheetConfig(SpreadsheetDocument doc)
        {
            if (GetWorksheetPartByName(doc, "2. RRA-Control Output") != null)
            {
                this.sheetIsValid = true;
                GetSheetConfig(doc);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="document"></param>
        /// <param name="sheetName"></param>
        /// <returns></returns>
        public WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
               document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
               Elements<Sheet>().Where(s => s.Name == sheetName);

            if (sheets?.Count() == 0)
            {
                // The specified worksheet does not exist.
                return null;
            }

            string relationshipId = sheets?.First().Id.Value;

            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);

            return worksheetPart;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="doc"></param>
        private void GetSheetConfig(SpreadsheetDocument doc)
        {
            var sheetAPI = GetWorksheetPartByName(doc, "API");
            if (sheetAPI == null)
            {
                this.dtAPI = WorksheetToDatatable(doc, GetWorksheetPartByName(doc, "2. RRA-Control Output"));
                this.targetSheetStartRow = 14;
                this.cidColRef = "B";
                this.statusColRef = "E";
                this.MustParse = true;
            }
            else
            {
                this.dtAPI = WorksheetToDatatable(doc, sheetAPI);
                this.targetSheetStartRow = int.Parse(dtAPI.Rows[2]["B"].ToString());
                this.cidColRef = (string)dtAPI.Rows[3]["B"];
                this.statusColRef = (string)dtAPI.Rows[4]["B"];
            }

            // Not sure how to use this number to find the right worksheet using OpenXML...
            // var targetSheetIndex = int.Parse(GetCellValue(doc, "API", "B2")) - 1;
            // ... so for now, using sheet name ...
            this.targetSheetName = "2. RRA-Control Output";
        }


        private static Regex controlParse = new Regex("([A-Z]{2,3}-[0-9]{1,2})(.+)");


        /// <summary>
        /// 
        /// </summary>
        /// <param name="controltmpId"></param>
        /// <returns></returns>
        internal String GetControlId(string controltmpId)
        {
            if (String.IsNullOrWhiteSpace(controltmpId))
                return null;

            if (this.MustParse)
            {
                Match m = controlParse.Match(controltmpId);
                if (m.Success)
                    return m.Groups[1].Value;
                return null;
            }
            return controltmpId;
        }

        private List<AnswerMap> internalMap = null;


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal List<AnswerMap> GetAnswerMap()
        {
            if (internalMap != null)
                return internalMap;

            if (this.MustParse)
            {
                internalMap = BuildDefaultAnswerMap();

            }
            else
            {
                internalMap = BuildAnswerMap(dtAPI);
            }
            return internalMap;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private List<AnswerMap> BuildDefaultAnswerMap()
        {
            List<AnswerMap> map = new List<AnswerMap>();
            map.Add(new AnswerMap() { AwwaAnswer = "Fully Implemented and Maintained".ToLower(), CsetAnswer = "Y", CsetComment = "" });
            map.Add(new AnswerMap() { AwwaAnswer = "Partially Implemented".ToLower(), CsetAnswer = "N", CsetComment = "" });
            map.Add(new AnswerMap() { AwwaAnswer = "Planned and Not Implemented".ToLower(), CsetAnswer = "N", CsetComment = "Planned Only" });
            map.Add(new AnswerMap() { AwwaAnswer = "Not Planned and/or Not Implemented - Risk Accepted".ToLower(), CsetAnswer = "NA", CsetComment = "Risk Accepted" });

            // map null values from spreadsheet to Unanswered
            map.Add(new AnswerMap()
            {
                AwwaAnswer = null,
                CsetAnswer = "U",
                CsetComment = ""
            });
            return map;
        }



        /// <summary>
        /// Builds a collection of AWWA answers mapped to CSET answers and comments.
        /// </summary>
        /// <param name="dtAPI"></param>
        /// <returns></returns>
        private List<AnswerMap> BuildAnswerMap(DataTable dtAPI)
        {
            List<AnswerMap> map = new List<AnswerMap>();

            for (int i = 1; i < dtAPI.Rows.Count; i++)
            {
                if (!string.IsNullOrEmpty(dtAPI.Rows[i]["D"].ToString()))
                {
                    map.Add(new AnswerMap()
                    {
                        AwwaAnswer = dtAPI.Rows[i]["C"].ToString().Trim().ToLower(),
                        CsetAnswer = dtAPI.Rows[i]["D"].ToString(),
                        CsetComment = dtAPI.Rows[i]["E"].ToString()
                    });
                }
            }

            // map null values from spreadsheet to Unanswered
            map.Add(new AnswerMap()
            {
                AwwaAnswer = null,
                CsetAnswer = "U",
                CsetComment = ""
            });

            return map;
        }

        /// <summary>
        /// Converts a worksheet to a simple DataTable.  
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="wsp"></param>
        /// <returns></returns>
        protected DataTable WorksheetToDatatable(SpreadsheetDocument doc, WorksheetPart wsp)
        {
            //Read the first Sheet from Excel file.
            // Sheet sheet = doc.WorkbookPart.Workbook.Sheets.GetFirstChild<Sheet>();

            //Get the Worksheet instance.
            //Worksheet worksheet = (doc.WorkbookPart.GetPartById(sheet.Id.Value) as WorksheetPart).Worksheet;

            Worksheet worksheet = wsp.Worksheet;

            //Fetch all the rows present in the Worksheet.
            IEnumerable<Row> rows = worksheet.GetFirstChild<SheetData>().Descendants<Row>();

            //Create a new DataTable.
            DataTable dt = new DataTable();


            //Loop through the Worksheet rows.
            // NOTE:  This loop is the longest part of the import process by far.
            var rowCount = 0;
            foreach (Row row in rows)
            {
                rowCount++;

                // When we run out of content rows, get out.  
                // There are blank rows within the first 12 rows, hence the 75 threshold.
                if (rowCount > 75 && row.InnerText == "")
                {
                    break;
                }

                var newRow = dt.Rows.Add();
                int colIndex = 0;
                for (int j = 0; j < row.Descendants<Cell>().Count(); j++)
                {
                    var cell = row.Descendants<Cell>().ElementAt(j);

                    // lazily add column on the fly, if necessary
                    if (dt.Columns.Count < j + 1)
                    {
                        dt.Columns.Add(ImportManagerAwwa.ColumnIndexToColumnLetter(j + 1));
                    }

                    newRow[colIndex] = ImportManagerAwwa.GetValue(doc, cell);
                    colIndex++;
                }
            }

            return dt;
        }
    }
}