//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using CSETWebCore.Business.ImportAssessment;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;

using System.Text;
using System.Data.SqlClient;
using System.Data.Common;
using System.Data.OleDb;

using CsvHelper.Excel;



namespace CSETWebCore.Business.AssessmentIO.Import
{
    /// <summary>
    /// Handles imports particular to AWWA.  Originally this
    /// refers to a spreadsheet that they upload to CSET to
    /// populate answers.
    /// </summary>
    public class ImportManagerAwwa
    {
        private CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ImportManagerAwwa(CSETContext context)
        {
            this._context = context;
        }

        [System.Runtime.Versioning.SupportedOSPlatform("windows")]
        public string XXXXXX()
        {
            var x = new ExcelReader(@"\\vmware-host\Shared Folders\Documents\$SHARED\CSET\CSET TSA\VADR Assessment Parameters for Reference Section.xlsx");

            var dt = x.ReadWorksheet("Sheet1$");

            return "";
        }






        /// <summary>
        /// 
        /// </summary>
        /// <param name="zipFileFromDatabase"></param>
        /// <param name="currentUserId"></param>
        /// <returns></returns>
        public string ProcessSpreadsheetImport(byte[] spreadsheet, int assessmentId)
        {
            var stream = new MemoryStream(spreadsheet);

            using (SpreadsheetDocument doc = SpreadsheetDocument.Open(stream, false))
            {
                // get API page content as a DataTable and pull reference values from it

                // Not sure how to use this number to find the right worksheet using OpenXML...
                // var targetSheetIndex = int.Parse(GetCellValue(doc, "API", "B2")) - 1;
                // ... so for now, using sheet name ...
                AwwaSheetConfig config = new AwwaSheetConfig(doc);

                var targetSheetPart = config.GetWorksheetPartByName(doc, config.targetSheetName);
                if (targetSheetPart == null || !config.sheetIsValid)
                {
                    return "Failed to find the correct sheet within the document"; //return false, signifying the import process failed
                }


                var answerMap = config.GetAnswerMap();
                //find target sheet number of rows
                IEnumerable<SheetData> sheetData = targetSheetPart.Worksheet.Elements<SheetData>();
                int maxRow = 0;


                foreach (SheetData sd in sheetData)
                {
                    IEnumerable<Row> row = sd.Elements<Row>(); // Get the row IEnumerator
                    maxRow = row.Count();
                }


                // track what is submitted so that we can build NA answers for what's missing
                List<string> submittedControlIDs = new List<string>();

                List<AwwaControlAnswer> mappedAnswers = new List<AwwaControlAnswer>();

                for (var i = config.targetSheetStartRow; i < maxRow; i++)
                {
                    var controltmpId = GetCellValue(doc, config.targetSheetName, $"{config.cidColRef}{i}");
                    var controlID = config.GetControlId(controltmpId);

                    if (string.IsNullOrWhiteSpace(controlID))
                    {
                        break;
                    }

                    submittedControlIDs.Add(controlID);

                    var awwaAnswer = GetCellValue(doc, config.targetSheetName, $"{config.statusColRef}{i}");
                    if (awwaAnswer != null)
                    {
                        awwaAnswer = awwaAnswer.Trim().ToLower();

                        var mappedAnswer = answerMap.Where(x => x.AwwaAnswer?.ToLower() == awwaAnswer).FirstOrDefault();

                        if (mappedAnswer != null)
                        {
                            // The spreadsheet may have Yes and No spelled out;
                            // Fix if that is the case.
                            if (mappedAnswer.CsetAnswer == "Yes")
                            {
                                mappedAnswer.CsetAnswer = "Y";
                            }
                            if (mappedAnswer.CsetAnswer == "No")
                            {
                                mappedAnswer.CsetAnswer = "N";
                            }

                            var a = new AwwaControlAnswer()
                            {
                                ControlID = controlID,
                                Answer = awwaAnswer,
                                CsetAnswer = mappedAnswer.CsetAnswer,
                                CsetComment = mappedAnswer.CsetComment
                            };
                            mappedAnswers.Add(a);
                        }
                    }
                }

                // include NA answers for any AWWA questions that were not in the spreadsheet
                mappedAnswers.AddRange(FilteredOutQuestions(submittedControlIDs));



                // at this point, CSET assessment answers can be built from the 'mappedAnswers' collection ...
                var queryAwwaReqQuestions = from r in _context.NEW_REQUIREMENT
                                            from rq in _context.REQUIREMENT_QUESTIONS_SETS
                                            where r.Requirement_Id == rq.Requirement_Id
                                            from nq in _context.NEW_QUESTION
                                            where rq.Question_Id == nq.Question_Id
                                            where r.Original_Set_Name == "AWWA"
                                            orderby r.Requirement_Title
                                            select new { r.Requirement_Title, r.Requirement_Id, nq.Question_Id };

                var listAwwaReqQuestions = queryAwwaReqQuestions.ToList();


                foreach (var a in mappedAnswers)
                {
                    // figure out the question ID that corresponds to the AWWA Control ID ...
                    var mappedQandR = listAwwaReqQuestions
                        .Where(x => x.Requirement_Title == a.ControlID).FirstOrDefault();

                    if (mappedQandR == null)
                    {
                        continue;
                    }

                    // Insert or update a Requirement answer
                    var answerR = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                        && x.Question_Or_Requirement_Id == mappedQandR.Requirement_Id
                        && x.Question_Type == "Requirement").FirstOrDefault();

                    if (answerR == null)
                    {
                        answerR = new ANSWER()
                        {
                            Assessment_Id = assessmentId,
                            Question_Or_Requirement_Id = mappedQandR.Requirement_Id,
                            Question_Type = "Requirement",
                            Question_Number = 0,
                            Answer_Text = a.CsetAnswer,
                            Comment = ""
                        };

                        _context.ANSWER.Add(answerR);
                        _context.SaveChanges();
                    }

                    if (answerR.Comment.Length > 0)
                    {
                        answerR.Comment += " - " + a.CsetComment;
                    }
                    else
                    {
                        answerR.Comment = a.CsetComment;
                    }

                    _context.SaveChanges();



                    // Insert or update a Question answer
                    var answerQ = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                       && x.Question_Or_Requirement_Id == mappedQandR.Question_Id
                       && x.Question_Type == "Question").FirstOrDefault();

                    if (answerQ == null)
                    {
                        answerQ = new ANSWER()
                        {
                            Assessment_Id = assessmentId,
                            Question_Or_Requirement_Id = mappedQandR.Question_Id,
                            Question_Type = "Question",
                            Question_Number = 0,
                            Answer_Text = a.CsetAnswer,
                            Comment = ""
                        };

                        _context.ANSWER.Add(answerQ);
                        _context.SaveChanges();
                    }

                    if (answerQ.Comment.Length > 0)
                    {
                        answerQ.Comment += " - " + a.CsetComment;
                    }
                    else
                    {
                        answerQ.Comment = a.CsetComment;
                    }

                    _context.SaveChanges();
                }
            }

            return null; //return empty, signiying the import process completed
        }


        /// <summary>
        /// Creates "NA" answers for any questions that were filtered out by
        /// the AWWA Tool, and were not included in the spreadsheet.
        /// </summary>
        /// <returns></returns>
        private List<AwwaControlAnswer> FilteredOutQuestions(List<string> submittedControlIDs)
        {
            var allAwwaControlIds = _context.NEW_REQUIREMENT.Where(x => x.Original_Set_Name == "AWWA")
                .Select(x => x.Requirement_Title).ToList();

            var listNaAnswers = new List<AwwaControlAnswer>();

            foreach (string title in allAwwaControlIds)
            {
                var c = title;

                if (!submittedControlIDs.Contains(c))
                {
                    // build a NA
                    var answer = new AwwaControlAnswer()
                    {
                        Answer = "",
                        ControlID = c,
                        CsetAnswer = "NA",
                        CsetComment = "[Screened out by the AWWA Cybersecurity Tool]"
                    };
                    listNaAnswers.Add(answer);
                }
            }

            return listNaAnswers;
        }


        /// <summary>
        /// Query the ANSWER record and return its comment or null.
        /// </summary>
        /// <param name="questionRequirementId"></param>
        /// <returns></returns>
        private string GetExistingComment(int assessmentId, int questionRequirementId)
        {
            var answer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Or_Requirement_Id == questionRequirementId).FirstOrDefault();

            if (answer != null)
            {
                return answer.Comment;
            }

            return String.Empty;
        }


        /// <summary>
        /// Gets a cell's value given the worksheet name and a cell reference
        /// </summary>
        private string GetCellValue(SpreadsheetDocument doc, string wsName, string cellRef)
        {
            Sheet sheet = doc.WorkbookPart.Workbook.Descendants<Sheet>().
                Where(s => s.Name == wsName).FirstOrDefault();

            if (sheet == null)
            {
                throw new Exception("Unknown worksheet name");
            }

            WorksheetPart wsPart = (WorksheetPart)(doc.WorkbookPart.GetPartById(sheet.Id));

            return GetCellValue(doc, wsPart, cellRef);
        }


        /// <summary>
        /// Gets a cell's value given the WorksheetPart and cell reference.
        /// </summary>
        private string GetCellValue(SpreadsheetDocument doc, WorksheetPart wsp, string cellRef)
        {
            string value = null;

            Cell theCell = wsp.Worksheet.Descendants<Cell>()
                .Where(c => c.CellReference == cellRef).FirstOrDefault();

            // If the cell does not exist, return an empty string.
            if (theCell != null && theCell.CellValue != null && theCell.CellValue.InnerText.Length > 0)
            {
                value = theCell.CellValue.InnerText;

                // If the cell represents an integer number, you are done. 
                // For dates, this code returns the serialized value that 
                // represents the date. The code handles strings and 
                // Booleans individually. For shared strings, the code 
                // looks up the corresponding value in the shared string 
                // table. For Booleans, the code converts the value into 
                // the words TRUE or FALSE.
                if (theCell.DataType != null)
                {
                    if (theCell.DataType.Value == CellValues.SharedString)
                    {
                        // For shared strings, look up the value in the
                        // shared strings table.
                        var stringTable =
                            doc.WorkbookPart.GetPartsOfType<SharedStringTablePart>()
                            .FirstOrDefault();

                        // If the shared string table is missing, something 
                        // is wrong. Return the index that is in
                        // the cell. Otherwise, look up the correct text in 
                        // the table.
                        if (stringTable != null)
                        {
                            value =
                                stringTable.SharedStringTable
                                .ElementAt(int.Parse(value)).InnerText;
                        }
                    }

                    if (theCell.DataType.Value == CellValues.Boolean)
                    {
                        switch (value)
                        {
                            case "0":
                                value = "FALSE";
                                break;
                            default:
                                value = "TRUE";
                                break;
                        }
                    }
                }
            }

            return value;
        }


        /// <summary>
        /// Returns the Excel column letter(s) for the column index.
        /// Note that the column index is 1-based, e.g., 1 = "A".
        /// </summary>
        /// <param name="colIndex"></param>
        /// <returns></returns>
        public static string ColumnIndexToColumnLetter(int colIndex)
        {
            int div = colIndex;
            string colLetter = String.Empty;
            int mod;

            while (div > 0)
            {
                mod = (div - 1) % 26;
                colLetter = (char)(65 + mod) + colLetter;
                div = (int)((div - mod) / 26);
            }
            return colLetter;
        }


        public static string GetValue(SpreadsheetDocument doc, Cell cell)
        {
            string value = cell.CellValue?.InnerText;
            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return doc.WorkbookPart.SharedStringTablePart.SharedStringTable.ChildElements[int.Parse(value)].InnerText;
            }
            return value;
        }
    }


    public class AwwaControlAnswer
    {
        public string ControlID { get; set; }
        public string Answer { get; set; }
        public string CsetAnswer { get; set; }
        public string CsetComment { get; set; }
    }


    public class AnswerMap
    {
        public string AwwaAnswer { get; set; }
        public string CsetAnswer { get; set; }
        public string CsetComment { get; set; }
    }


    /// <summary>
    /// This class is experimental to see if there is another way to 
    /// reliably read an Excel spreadsheet.  It is currently a
    /// work in progress and is not in use.
    /// </summary>
    public class ExcelReader
    {
        private string filePath;
        private string fileExtension;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="path"></param>
        public ExcelReader(string path)
        {
            filePath = path;
            fileExtension = System.IO.Path.GetExtension(filePath);
        }


        /// <summary>
        /// Sheet1$
        /// </summary>
        /// <returns></returns>
        [System.Runtime.Versioning.SupportedOSPlatform("windows")]
        public DataTable ReadWorksheet(string sheet)
        {
            string conn = string.Empty;
            DataTable dtexcel = new DataTable();
            if (fileExtension.CompareTo(".xls") == 0)
                conn = @"provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties='Excel 8.0;HRD=Yes;IMEX=1';"; //for below excel 2007  
            else
                conn = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties='Excel 12.0;HDR=NO';"; //for above excel 2007  
            using (OleDbConnection con = new OleDbConnection(conn))
            {
                try
                {
                    OleDbDataAdapter oleAdpt = new OleDbDataAdapter($"select * from [{sheet}]", con); //here we read data from sheet1  
                    oleAdpt.Fill(dtexcel); //fill excel data into dataTable  
                }
                catch { }
            }
            return dtexcel;
        }
    }
}
