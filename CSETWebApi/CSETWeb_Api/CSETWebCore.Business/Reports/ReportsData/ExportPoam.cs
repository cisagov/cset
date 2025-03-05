//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Collections.Generic;
using System.IO;
using System.Linq;


namespace CSETWebCore.Business.Reports
{
    public class ExportPoamBusiness
    {
        /// <summary>
        /// Generates a CMMC POAM spreadsheet.
        /// </summary>
        public static void GenerateSpreadSheet(MemoryStream memoryStream, MaturityResponse mm)
        {
            // Define Excel column headers
            var columnHeaders = new[] {
                "Control Title",
                "Weakness",
                "Maturity Level",
                "Resource Estimate",
                "Scheduled Completion Date",
                "Milestones with Interim Completion Dates",
                "Changes to Milestones",
                "How was the weakness identified?",
                "Status (Ongoing or Complete)"
            };

            // Create the Excel file
            using (var spreadsheetDocument = SpreadsheetDocument.Create(memoryStream, SpreadsheetDocumentType.Workbook))
            {
                // Add a WorkbookPart
                var workbookPart = spreadsheetDocument.AddWorkbookPart();
                workbookPart.Workbook = new Workbook();

                // Define column widths
                var columns = CreateColumns(
                    columnHeaders.Length, // Total number of columns
                    5,                    // Start specific width at column E (5th column)
                    9,                    // End specific width at column I (9th column)
                    40,                   // Specific width for columns E:I
                    20                    // Default width for other columns
                );

                // Add Stylesheet (for bold headers and text wrapping)
                var stylesPart = workbookPart.AddNewPart<WorkbookStylesPart>();
                stylesPart.Stylesheet = CreateStylesheet();
                stylesPart.Stylesheet.Save();

                // Add a WorksheetPart
                var worksheetPart = workbookPart.AddNewPart<WorksheetPart>();
                worksheetPart.Worksheet = new Worksheet(columns, new SheetData());

                // Add Sheets to the Workbook
                var sheets = spreadsheetDocument.WorkbookPart.Workbook.AppendChild(new Sheets());
                var sheet = new Sheet
                {
                    Id = spreadsheetDocument.WorkbookPart.GetIdOfPart(worksheetPart),
                    SheetId = 1,
                    Name = "POAM"
                };

                sheets.Append(sheet);

                // Get the SheetData
                var sheetData = worksheetPart.Worksheet.GetFirstChild<SheetData>();

                // Create the header row
                var headerRow = new Row();

                foreach (var header in columnHeaders)
                {
                    var cell = new Cell
                    {
                        CellValue = new CellValue(header),
                        DataType = CellValues.String,
                        StyleIndex = 1
                    };
                    headerRow.Append(cell);
                }
                sheetData.Append(headerRow);

                foreach (var grouping in mm.Groupings)
                {
                    foreach (var subgrouping in grouping.SubGroupings)
                    {
                        foreach (var question in subgrouping.Questions)
                        {
                            // Skip questions that have been met.
                            if (question.Answer == "Y" || isUnpardonable(question.DisplayNumber))
                            {
                                continue;
                            }

                            var row = new Row();

                            // Add the control title cell
                            var controlTitleCell = new Cell
                            {
                                CellValue = new CellValue(question.DisplayNumber),
                                DataType = CellValues.String
                            };
                            row.Append(controlTitleCell);

                            // Add the weakness cell
                            var weaknessCell = new Cell
                            {
                                CellValue = new CellValue(question.QuestionText),
                                DataType = CellValues.String
                            };
                            row.Append(weaknessCell);

                            // Add the maturity level cell
                            if (!string.IsNullOrEmpty(question.MaturityLevelName))
                            {
                                var maturityLevelCell = new Cell
                                {
                                    CellValue = new CellValue(question.MaturityLevelName),
                                    DataType = CellValues.String
                                };
                                row.Append(maturityLevelCell);
                            }


                            sheetData.Append(row);
                        }
                    }
                }

                // Save the worksheet
                worksheetPart.Worksheet.Save();
                workbookPart.Workbook.Save();
            }

        }


        /// <summary>
        /// Creates column definitions for a worksheet, with specific widths for a range.
        /// </summary>
        private static Columns CreateColumns(
            int numberOfColumns,
            uint specificWidthStart,
            uint specificWidthEnd,
            double specificWidth,
            double defaultWidth = 10)
        {
            var columns = new Columns();
            for (uint i = 1; i <= (uint)numberOfColumns; i++)
            {
                columns.Append(new Column
                {
                    Min = i,
                    Max = i,
                    Width = (i >= specificWidthStart && i <= specificWidthEnd) ? specificWidth : defaultWidth,
                    CustomWidth = true
                });
            }
            return columns;
        }


        /// <summary>
        /// Creates a stylesheet with a bold header style and text wrapping.
        /// </summary>
        /// <returns>A Stylesheet object.</returns>
        private static Stylesheet CreateStylesheet()
        {
            return new Stylesheet(
                new Fonts(
                    new Font(), // Default font
                    new Font( // Bold font
                        new Bold()
                    )
                ),
                new Fills(
                    new Fill(new PatternFill { PatternType = PatternValues.None }), // Default fill
                    new Fill(new PatternFill { PatternType = PatternValues.Gray125 }) // Gray fill (default alternate)
                ),
                new Borders(
                    new Border(), // Default border
                    new Border( // Thin border
                        new LeftBorder(),
                        new RightBorder(),
                        new TopBorder(),
                        new BottomBorder(),
                        new DiagonalBorder()
                    )
                ),
                new CellFormats(
                    new CellFormat(), // Default cell format
                    new CellFormat { FontId = 1, ApplyFont = true, Alignment = new Alignment { WrapText = true } } // Bold + wrap text
                )
            );
        }


        /// <summary>
        /// Generate a filename for a POAM report
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static string GetFilename(int assessmentId, CSETContext context)
        {
            string filename = $"ExcelExport.xlsx";

            var assessmentName = context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
            if (!string.IsNullOrEmpty(assessmentName))
            {
                filename = $"{assessmentName} - POAM.xlsx";
            }

            return filename;
        }

        /// <summary>
        /// Check if an item is unpardonable based on its control title.
        /// </summary>
        /// <param name="controlTitle"></param>
        /// <returns>bool</returns>
        private static bool isUnpardonable(string controlTitle)
        {
            var unpardonables = new List<string> {
                "AC.L2-3.1.20",
                "AC.L2-3.1.22",
                "PE.L2-3.10.3",
                "PE.L2-3.10.4",
                "PE.L2-3.10.5",
                "IR.L3-3.6.1E",
                "IR.L3-3.6.2E",
                "RA.L3-3.11.1E",
                "RA.L3-3.11.4E",
                "RA.L3-3.11.6E",
                "RA.L3-3.11.7E",
                "SI.L3-3.14.3E"
            };

            return unpardonables.Contains(controlTitle);
        }
    }
}