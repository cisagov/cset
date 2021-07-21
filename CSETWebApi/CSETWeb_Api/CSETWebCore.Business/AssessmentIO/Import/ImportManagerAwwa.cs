//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
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
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;


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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="zipFileFromDatabase"></param>
        /// <param name="currentUserId"></param>
        /// <returns></returns>
        public async Task<String> ProcessSpreadsheetImport(byte[] spreadsheet, int assessmentId)
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
                if(targetSheetPart == null || !config.sheetIsValid)
                {
                    return "Failed to find the correct sheet within the document" ; //return false, signifying the import process failed
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

                DBIO dbio = new DBIO(_context);

                // track what is submitted so that we can build NA answers for what's missing
                List<string> submittedControlIDs = new List<string>();

                List<AwwaControlAnswer> mappedAnswers = new List<AwwaControlAnswer>();

                for (var i = config.targetSheetStartRow; i < maxRow; i++)
                {
                    var controltmpId = GetCellValue(doc, config.targetSheetName, string.Format("{0}{1}", config.cidColRef, i));
                    var controlID = config.GetControlId(controltmpId);

                    if (string.IsNullOrWhiteSpace(controlID))
                    {
                        break;
                    }

                    submittedControlIDs.Add(controlID);

                    var awwaAnswer = GetCellValue(doc, config.targetSheetName, string.Format("{0}{1}", config.statusColRef, i));
                    if (awwaAnswer != null)
                    {
                        awwaAnswer = awwaAnswer.Trim().ToLower();

                        var mappedAnswer = answerMap.Where(x => x.AwwaAnswer?.ToLower() == awwaAnswer).FirstOrDefault();

                        if (mappedAnswer != null)
                        {
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
                mappedAnswers.AddRange(FilteredOutQuestions(submittedControlIDs, dbio));



                // at this point, CSET assessment answers can be built from the 'mappedAnswers' collection ...

                string sql = "select r.Requirement_Title, r.Requirement_Id, q.Question_Id " +
                    "from new_requirement r " +
                    "left join requirement_questions rq on r.Requirement_Id = rq.Requirement_Id " +
                    "left join new_question q on rq.Question_Id = q.Question_Id " +
                    "where r.Original_Set_Name = 'AWWA' " +
                    "order by r.Requirement_Title";

                DataTable dt = dbio.Select(sql, null);

                var sqlInsert = "insert into ANSWER (Assessment_Id, Question_Or_Requirement_Id, Mark_For_Review, Comment, Alternate_Justification, Question_Number, Answer_Text, Component_Guid, Custom_Question_Guid, Question_Type, Old_Answer_Id, Reviewed, FeedBack) " +
                    "values (@assessid, @questionreqid, 0, @comment, '', @questionnum, @ans, '00000000-0000-0000-0000-000000000000', null, @qtype, null, 0, null)";

                var sqlUpdate = "update ANSWER set Answer_Text = @ans, Comment = @comment where Assessment_Id = @assessid and Question_Or_Requirement_Id = @questionreqid and Question_Type = @qtype";

                //QuestionBusiness qm = new QuestionBusiness(assessmentId);

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
                            { "@questionreqid", mappedQuestionAndRequirement["requirement_id"] },
                            { "@comment", a.CsetComment },
                            { "@questionnum", 0 },
                            { "@ans", a.CsetAnswer },
                            { "@qtype", "Requirement" }
                        };

                        dbio.Execute(sqlInsert, parmsReq);
                    }
                    catch (Exception exc)
                    {
                        // get any existing comment and append to it; don't overlay it
                        var comment = GetExistingComment(assessmentId, (int)mappedQuestionAndRequirement["requirement_id"]);
                        if (a.CsetComment.Trim() != comment.Trim())
                        {
                            comment = comment
                                + (comment.Trim().Length > 0 && a.CsetComment.Trim().Length > 0 ? " - " : "")
                                + a.CsetComment;
                        }
                        else
                        {
                            comment = a.CsetComment;
                        }


                        var parmsReq = new Dictionary<string, object>()
                        {
                            { "@ans", a.CsetAnswer },
                            { "@comment", comment },
                            { "@assessid", assessmentId },
                            { "@questionreqid", mappedQuestionAndRequirement["requirement_id"] },
                            { "@qtype", "Requirement" }
                        };

                        dbio.Execute(sqlUpdate, parmsReq);
                    }


                    // Insert or update a Question answer
                    try
                    {
                        var parmsQ = new Dictionary<string, object>()
                        {
                            { "@assessid", assessmentId },
                            { "@questionreqid", mappedQuestionAndRequirement["question_id"] },
                            { "@comment", a.CsetComment },
                            { "@questionnum", 0 },
                            { "@ans", a.CsetAnswer },
                            { "@qtype", "Question" }
                        };

                        dbio.Execute(sqlInsert, parmsQ);
                    }
                    catch (Exception exc)
                    {
                        // get any existing comment and append to it; don't overlay it
                        var comment = GetExistingComment(assessmentId, (int)mappedQuestionAndRequirement["question_id"]);
                        if (a.CsetComment.Trim() != comment.Trim())
                        {
                            comment = comment 
                                + (comment.Trim().Length > 0 && a.CsetComment.Trim().Length > 0 ? " - " : "") 
                                + a.CsetComment;
                        }
                        else
                        {
                            comment = a.CsetComment;
                        }


                        var parmsQ = new Dictionary<string, object>()
                        {
                            { "@ans", a.CsetAnswer },
                            { "@comment", comment },
                            { "@assessid", assessmentId },
                            { "@questionreqid", mappedQuestionAndRequirement["question_id"] },
                            { "@qtype", "Question" }
                        };

                        dbio.Execute(sqlUpdate, parmsQ);
                    }
                }
            }

            return null; //return empty, signiying the import process completed
        }


        /// <summary>
        /// Creates "NA" answers for any questions that were filtered out by
        /// the AWWA Tool, and were not included in the spreadsheet.
        /// </summary>
        /// <returns></returns>
        private List<AwwaControlAnswer> FilteredOutQuestions(List<string> submittedControlIDs, DBIO dbio)
        {
            var sqlAwwaFullControlList = "select requirement_title from NEW_REQUIREMENT where original_set_name = 'AWWA'";
            var dtfullList = dbio.Select(sqlAwwaFullControlList, null);


            var listNaAnswers = new List<AwwaControlAnswer>();

            foreach (DataRow r in dtfullList.Rows)
            {
                var c = r["REQUIREMENT_TITLE"].ToString();

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
            var sqlSelect = "select [Comment] from ANSWER where assessment_id = @assessId and Question_or_Requirement_Id = @qrid";
            var parms = new Dictionary<string, object>()
            {
                { "@assessId", assessmentId },
                { "@qrid", questionRequirementId }
            };
            DBIO dbio = new DBIO(_context);
            var answer = dbio.Select(sqlSelect, parms);

            if (answer.Rows.Count > 0)
            {
                return answer.Rows[0]["Comment"].ToString();
            }

            return string.Empty;
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
        /// Returns the Excel column letter(s) for the column index.
        /// Note that the column index is 1-based, e.g., 1 = "A".
        /// </summary>
        /// <param name="colIndex"></param>
        /// <returns></returns>
        public static string ColumnIndexToColumnLetter(int colIndex)
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


        public static string GetValue(SpreadsheetDocument doc, Cell cell)
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
