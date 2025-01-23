using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using DocumentFormat.OpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Business.Aggregation;
using static Lucene.Net.Util.Fst.Util;
using CSETWebCore.Interfaces.Reports;

namespace CSETWebCore.Business.Reports
{
    public class ObservationsToExcel
    {
        private readonly IReportsDataBusiness _report;


        /// <summary>
        /// CTOR
        /// </summary>
        public ObservationsToExcel(CSETContext context, IReportsDataBusiness report)
        {
            _report = report;
        }


        public void GenerateSpreadsheet(int assessmentId, MemoryStream ms)
        {
            // Define Excel column headers
            var columnHeaders = new[] {
                new ColDef("Contact", 24),
                new ColDef("Observation Title", 25),
                new ColDef("Question ID", 15),
                new ColDef("Importance", 12),
                new ColDef("Resolution Date", 26),
                new ColDef("Issue", 32),
                new ColDef("Impacts", 32),
                new ColDef("Recommendations", 32),
                new ColDef("Vulnerabilities", 32 )
            };

            // Create the Excel file
            using (var spreadsheetDocument = SpreadsheetDocument.Create(ms, SpreadsheetDocumentType.Workbook))
            {
                // Add a WorkbookPart
                var workbookPart = spreadsheetDocument.AddWorkbookPart();
                workbookPart.Workbook = new Workbook();

                // Define column widths
                var columns = CreateColumns(columnHeaders);

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
                    Name = "Observations"
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
                        CellValue = new CellValue(header.HeaderText),
                        DataType = CellValues.String,
                        StyleIndex = 1
                    };
                    headerRow.Append(cell);
                }
                sheetData.Append(headerRow);

                // get observations
                _report.SetReportsAssessmentId(assessmentId);
                BasicReportData data = new BasicReportData();
                data.information = _report.GetInformation();
                data.Individuals = _report.GetObservationIndividuals().OrderBy(x => x.FullName).ToList();


                foreach (var ind in data.Individuals)
                {
                    foreach (var obs in ind.Observations)
                    {
                        var row = new Row();
                        sheetData.Append(row);


                        row.Append(new Cell
                        {
                            CellValue = new CellValue(ind.FullName),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Observation),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.QuestionIdentifier),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Importance),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue((DateTimeOffset)obs.ResolutionDate),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Issue),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Impact),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Recommendations),
                            DataType = CellValues.String
                        });

                        row.Append(new Cell
                        {
                            CellValue = new CellValue(obs.Vulnerabilities),
                            DataType = CellValues.String
                        });
                    }
                }


                // Save the worksheet
                worksheetPart.Worksheet.Save();
                workbookPart.Workbook.Save();
            }
        }


        private Columns CreateColumns(ColDef[] cols)
        {
            var columns = new Columns();
            for (uint i = 0; i < cols.Length; i++)
            {
                columns.Append(new Column
                {
                    Min = i + 1,
                    Max = i + 1,
                    Width = cols[i].Width,
                    CustomWidth = true
                });
            }

            return columns;
        }


        /// <summary>
        /// Creates a stylesheet with a bold header style and text wrapping.
        /// </summary>
        /// <returns>A Stylesheet object.</returns>
        private Stylesheet CreateStylesheet()
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
    }


    internal class ColDef
    {
        public string HeaderText { get; set; }
        public int Width { get; set; }

        public ColDef(string h, int w)
        {
            HeaderText = h;
            Width = w;
        }
    }
}
