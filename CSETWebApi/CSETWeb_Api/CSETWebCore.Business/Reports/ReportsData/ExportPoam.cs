//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.IO;
using System.Linq;


namespace CSETWebCore.Business.Reports
{
    public class ExportPoamBusiness
    {
        /// <summary>
        /// Generates a CMMC POAM spreadsheet.
        /// </summary>
        public static void GenerateSpreadSheet(MemoryStream memoryStream)
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
                var columns = new Columns();
                for (uint i = 1; i <= (uint)columnHeaders.Length; i++)
                {
                    columns.Append(new Column
                    {
                        Min = i,
                        Max = i,
                        Width = 20, // Double the width
                        CustomWidth = true
                    });
                }

                // Add Stylesheet (for bold headers and text wrapping)
                var stylesPart = workbookPart.AddNewPart<WorkbookStylesPart>();
                stylesPart.Stylesheet = ExportPoamBusiness.CreateStylesheet();
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

                // Save the worksheet
                worksheetPart.Worksheet.Save();
                workbookPart.Workbook.Save();
            }

        }


        /// <summary>
        /// Creates a stylesheet with a bold header style and text wrapping.
        /// </summary>
        /// <returns>A Stylesheet object.</returns>
        public static Stylesheet CreateStylesheet()
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
    }
}