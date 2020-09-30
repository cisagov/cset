//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.IO;
using System.Web.UI.WebControls;
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessLogic.ImportAssessment;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    /// <summary>
    /// Handles imports particular to AWWA.  Originally this
    /// refers to a spreadsheet that they upload to CSET to
    /// populate answers.
    /// </summary>
    public class ImportManagerAwwa
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="zipFileFromDatabase"></param>
        /// <param name="currentUserId"></param>
        /// <returns></returns>
        public async Task ProcessSpreadsheetImport(byte[] spreadsheet, int assessmentId)
        {
            var stream = new MemoryStream(spreadsheet);
            using (SpreadsheetDocument doc = SpreadsheetDocument.Open(stream, false))
            {
                // get API page content as a DataTable and pull reference values from it
                var sheetAPI = GetWorksheetPartByName(doc, "API");
                var dtAPI = WorksheetToDatatable(doc, sheetAPI);
                var targetSheetStartRow = int.Parse(dtAPI.Rows[2]["B"].ToString());
                var cidColRef = dtAPI.Rows[3]["B"];
                var statusColRef = dtAPI.Rows[4]["B"];


                // Not sure how to use this number to find the right worksheet using OpenXML...
                // var targetSheetIndex = int.Parse(GetCellValue(doc, "API", "B2")) - 1;
                // ... so for now, using sheet name ...
                string targetSheetName = "2. RRA-Control Output";
                var targetSheetPart = GetWorksheetPartByName(doc, targetSheetName);

                var answerMap = BuildAnswerMap(dtAPI);


                //find target sheet number of rows
                IEnumerable<SheetData> sheetData = targetSheetPart.Worksheet.Elements<SheetData>();
                int maxRow = 0;
                foreach (SheetData sd in sheetData)
                {
                    IEnumerable<Row> row = sd.Elements<Row>(); // Get the row IEnumerator
                    maxRow = row.Count();
                }



                List<AwwaControlAnswer> mappedAnswers = new List<AwwaControlAnswer>();


                for (var i = targetSheetStartRow; i < maxRow; i++)
                {
                    var controlID = GetCellValue(doc, targetSheetName, string.Format("{0}{1}", cidColRef, i));

                    if (string.IsNullOrEmpty(controlID))
                    {
                        break;
                    }

                    if (!string.IsNullOrEmpty(controlID))
                    {
                        var awwaAnswer = GetCellValue(doc, targetSheetName, string.Format("{0}{1}", statusColRef, i));
                        var mappedAnswer = answerMap.Where(x => x.AwwaAnswer == awwaAnswer).FirstOrDefault();

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



                // at this point, CSET assessment answers can be built from the 'answers' collection ...

                string sql = "select r.Requirement_Title, r.Requirement_Id, q.Question_Id " +
                    "from new_requirement r " +
                    "left join requirement_questions rq on r.Requirement_Id = rq.Requirement_Id " +
                    "left join new_question q on rq.Question_Id = q.Question_Id " +
                    "where r.Original_Set_Name = 'AWWA' " +
                    "order by r.Requirement_Title";

                DBIO dbio = new DBIO();
                DataTable dt = dbio.Select(sql, null);



                var sqlInsert = "insert into ANSWER (Assessment_Id, Is_Requirement, Question_Or_Requirement_Id, Mark_For_Review, Comment, Alternate_Justification, Question_Number, Answer_Text, Component_Guid, Is_Component, Custom_Question_Guid, Is_Framework, Is_Maturity, Old_Answer_Id, Reviewed, FeedBack) " +
                    "values (@assessid, @isreq, @questionreqid, 0, @comment, '', @questionnum, @ans, '00000000-0000-0000-0000-000000000000', 0, null, 0, 0, null, 0, null)";

                var sqlUpdate = "update ANSWER set Answer_Text = @ans, Comment = @comment where Assessment_Id = @assessid and Question_Or_Requirement_Id = @questionreqid and Is_Requirement = @isreq";

                QuestionsManager qm = new QuestionsManager(assessmentId);
                foreach (var a in mappedAnswers)
                {
                    // figure out the question ID that corresponds to the AWWA Control ID ...
                    var g = dt.Select(string.Format("requirement_title = '{0}'", a.ControlID));

                    if (g.Length == 0)
                    {
                        continue;
                    }

                    DataRow mappedQuestionAndRequirement = g[0];


                    // Insert or update a Requirement answer
                    try
                    {
                        var parmsReq = new Dictionary<string, object>()
                        {
                            { "@assessid", assessmentId },
                            { "@isreq", 1 },
                            { "@questionreqid", mappedQuestionAndRequirement["requirement_id"] },
                            { "@comment", a.CsetComment },
                            { "@questionnum", 0 },
                            { "@ans", a.CsetAnswer }
                        };

                        dbio.Execute(sqlInsert, parmsReq);
                    }
                    catch (Exception exc)
                    {
                        var parmsReq = new Dictionary<string, object>()
                        {
                            { "@ans", a.CsetAnswer },
                            { "@comment", a.CsetComment },
                            { "@assessid", assessmentId },
                            { "@questionreqid", mappedQuestionAndRequirement["requirement_id"] },
                            { "@isreq", 1 }
                        };

                        dbio.Execute(sqlUpdate, parmsReq);
                    }


                    // Insert or update a Question answer
                    try
                    {
                        var parmsQ = new Dictionary<string, object>()
                        {
                            { "@assessid", assessmentId },
                            { "@isreq", 0 },
                            { "@questionreqid", mappedQuestionAndRequirement["question_id"] },
                            { "@comment", a.CsetComment },
                            { "@questionnum", 0 },
                            { "@ans", a.CsetAnswer }
                        };

                        dbio.Execute(sqlInsert, parmsQ);
                    }
                    catch (Exception exc)
                    {
                        var parmsQ = new Dictionary<string, object>()
                        {
                            { "@ans", a.CsetAnswer },
                            { "@comment", a.CsetComment },
                            { "@assessid", assessmentId },
                            { "@questionreqid", mappedQuestionAndRequirement["question_id"] },
                            { "@isreq", 0 }
                        };

                        dbio.Execute(sqlUpdate, parmsQ);
                    }
                }
            }
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
                        AwwaAnswer = dtAPI.Rows[i]["C"].ToString(),
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
        /// 
        /// </summary>
        /// <param name="document"></param>
        /// <param name="sheetName"></param>
        /// <returns></returns>
        private WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName)
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
                    switch (theCell.DataType.Value)
                    {
                        case CellValues.SharedString:

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
                            break;

                        case CellValues.Boolean:
                            switch (value)
                            {
                                case "0":
                                    value = "FALSE";
                                    break;
                                default:
                                    value = "TRUE";
                                    break;
                            }
                            break;
                    }
                }
            }

            return value;
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
            foreach (Row row in rows)
            {
                var newRow = dt.Rows.Add();
                int colIndex = 0;
                for (int j = 0; j < row.Descendants<Cell>().Count(); j++)
                {
                    var cell = row.Descendants<Cell>().ElementAt(j);

                    // lazily add column on the fly, if necessary
                    if (dt.Columns.Count < j + 1)
                    {
                        dt.Columns.Add(ColumnIndexToColumnLetter(j + 1));
                    }

                    newRow[colIndex] = GetValue(doc, cell);
                    colIndex++;
                }
            }

            return dt;
        }


        /// <summary>
        /// Returns the Excel column letter(s) for the column index.
        /// Note that the column index is 1-based, e.g., 1 = "A".
        /// </summary>
        /// <param name="colIndex"></param>
        /// <returns></returns>
        static string ColumnIndexToColumnLetter(int colIndex)
        {
            int div = colIndex;
            string colLetter = String.Empty;
            int mod = 0;

            while (div > 0)
            {
                mod = (div - 1) % 26;
                colLetter = (char)(65 + mod) + colLetter;
                div = (int)((div - mod) / 26);
            }
            return colLetter;
        }


        private string GetValue(SpreadsheetDocument doc, Cell cell)
        {
            string value = cell.CellValue?.InnerText;
            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return doc.WorkbookPart.SharedStringTablePart.SharedStringTable.ChildElements.GetItem(int.Parse(value)).InnerText;
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
}
