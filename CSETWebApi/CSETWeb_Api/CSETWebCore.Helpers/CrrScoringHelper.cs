using System;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Model;
using CSETWebCore.Model.Crr;
using CSETWebCore.Model.Maturity;
using System.IO;
using System.Reflection;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// 
    /// </summary>
    public class CrrScoringHelper : ICrrScoringHelper
    {
        private readonly CSETContext _context;

        public int AssessmentId { get; set; }

        public int CrrModelId
        {
            get { return 4; }
        }

        /// <summary>
        /// The main XDocument that contains the full domain/goal/question structure
        /// </summary>
        public XDocument XDoc { get; set; }


        /// <summary>
        /// An XDocument that contains the NIST Cybersecurity Framework
        /// function/category/subcategory structure and corresponding
        /// CRR answer values.
        /// </summary>
        public XDocument XCsf { get; set; }


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public CrrScoringHelper(CSETContext context)
        {
            this._context = context;
        }

        public void InstantiateScoringHelper(int assessmentId)
        {
            this.AssessmentId = assessmentId;

            LoadStructure();

            ManipulateStructure();

            Rollup();

            LoadNistCsfMappedAnswers();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        public void LoadStructure()
        {
            XDoc = new XDocument(new XElement("Model"));


            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                CrrModelId == q.Maturity_Model_Id).ToList();

            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type_)
                .Where(x => x.Maturity_Model_Id == CrrModelId).ToList();


            GetSubgroups(XDoc.Root, null, allGroupings, questions, answers.ToList());
        }

        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        public void GetSubgroups(XElement xE, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
           List<MATURITY_QUESTIONS> questions,
           List<FullAnswer> answers)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var xGrouping = new XElement(sg.Type_.Grouping_Type_Name);
                xE.Add(xGrouping);
                xGrouping.SetAttributeValue("abbreviation", sg.Abbreviation);
                xGrouping.SetAttributeValue("groupingid", sg.Grouping_Id.ToString());
                xGrouping.SetAttributeValue("title", sg.Title);
                xGrouping.SetAttributeValue("description", sg.Description);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == sg.Grouping_Id).ToList();

                var parentQuestionIDs = myQuestions.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();

                    var xQuestion = new XElement("Question");
                    xQuestion.SetAttributeValue("questionid", myQ.Mat_Question_Id.ToString());
                    xQuestion.SetAttributeValue("parentquestionid", myQ.Parent_Question_Id.ToString());
                    xQuestion.SetAttributeValue("sequence", myQ.Sequence.ToString());
                    xQuestion.SetAttributeValue("displaynumber", myQ.Question_Title);
                    xQuestion.SetAttributeValue("questiontext", myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> "));
                    xQuestion.SetAttributeValue("answer", answer?.a.Answer_Text ?? "");
                    xQuestion.SetAttributeValue("isparentquestion", B2S(parentQuestionIDs.Contains(myQ.Mat_Question_Id)));

                    try
                    {
                        var xReftext = new XElement("RefText");
                        xReftext.Value = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text ?? "";
                        xQuestion.Add(xReftext);
                    }
                    catch (Exception ex)
                    {
                        var abc = 1;
                    }
                    xGrouping.Add(xQuestion);
                }


                // Recurse down to build subgroupings
                GetSubgroups(xGrouping, sg.Grouping_Id, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// Put goals under MILs.  Other shuffling.
        /// </summary>
        public void ManipulateStructure()
        {
            // create MIL nodes
            var domains = XDoc.Descendants("Domain").ToList();
            foreach (var domain in domains)
            {
                for (int i = 1; i <= 5; i++)
                {
                    var xMil = new XElement("Mil");
                    domain.Add(xMil);
                    xMil.SetAttributeValue("label", $"MIL-{i}");
                    SetColor(xMil, "red");



                    // move goals from Domain to the Mil element (for 2 - 5)
                    var milGoal = domain.Descendants("Goal")
                        .Where(g => g.Attribute("abbreviation").Value.Contains($"MIL{i}"))
                        .FirstOrDefault();

                    if (milGoal != null)
                    {
                        milGoal.Remove();
                        xMil.Add(milGoal);

                        milGoal.SetAttributeValue("ghost-goal", "true");
                    }
                }

                // lump the remaining goals into MIL-1
                var xMil1 = domain.Descendants("Mil").Where(m => m.Attribute("label").Value == "MIL-1").First();

                var xMil1Goals = domain.Descendants("Goal")
                    .Where(g => !g.Attribute("abbreviation").Value.Contains("MIL"))
                    .ToList();
                foreach (var g in xMil1Goals)
                {
                    g.Remove();
                    xMil1.Add(g);
                }
            }



            // Include a placeholder for P if only I, T, D present below a parent question.
            // This dummy is shown on the domain heatmap as a light gray box
            var parentQuestions = XDoc.XPathSelectElements("//Question[@isparentquestion='true']").ToList();
            foreach (var pq in parentQuestions)
            {
                var pqID = pq.Attribute("questionid").Value;
                var childP = pq.Parent.XPathSelectElement($"Question[@parentquestionid='{pqID}'][contains(@displaynumber, '-P')]");
                if (childP == null)
                {
                    var p = new XElement("Question");
                    p.SetAttributeValue("questionid", "");
                    p.SetAttributeValue("parentquestionid", pqID);
                    p.SetAttributeValue("displaynumber", "");
                    p.SetAttributeValue("answer", "");
                    p.SetAttributeValue("isparentquestion", "false");
                    p.SetAttributeValue("placeholder-p", "true");

                    pq.AddAfterSelf(p);
                }
            }
        }


        /// <summary>
        /// Color the nodes based on their children and a few other rules.
        /// </summary>
        public void Rollup()
        {
            // Color all questions based on their answers
            foreach (var q in XDoc.Descendants("Question"))
            {
                var answer = q.Attribute("answer").Value;
                switch (answer)
                {
                    case "Y":
                        SetColor(q, "green");
                        break;
                    case "I":
                        SetColor(q, "yellow");
                        break;
                    case "N":
                        SetColor(q, "red");
                        break;
                    default:
                        SetColor(q, "unanswered-gray");
                        break;
                }

                if (q.Attribute("isparentquestion").Value == "true")
                {
                    SetColor(q, "parent-gray");
                }

                if (q.Attribute("placeholder-p")?.Value == "true")
                {
                    SetColor(q, "placeholder-gray");
                }
            }



            // Goal rollup
            foreach (var goal in XDoc.Descendants("Goal").ToList())
            {
                var myQuestions = goal.Descendants("Question")
                    .Where(q => q.Attribute("isparentquestion").Value == "false"
                        && q.Attribute("placeholder-p")?.Value != "true"
                    );

                // start with red
                SetColor(goal, "red");


                // promote to yellow
                if (myQuestions.Any(q => GetColor(q) == "yellow")
                    || myQuestions.Any(q => GetColor(q) == "green"))
                {
                    SetColor(goal, "yellow");
                }


                // promote to green
                if (myQuestions.All(q => GetColor(q) == "green"))
                {
                    SetColor(goal, "green");
                }
            }


            // Basic MIL rollup (this could get overridden with the following 'cumulative' check)
            foreach (var mil in XDoc.Descendants("Mil").ToList())
            {
                var myGoals = mil.Descendants("Goal");

                // start with red
                SetColor(mil, "red");


                // promote to yellow (MIL-1 only)
                if (mil.Attribute("label").Value == "MIL-1")
                {
                    if (myGoals.Any(g => GetColor(g) == "yellow")
                        || myGoals.Any(g => GetColor(g) == "green"))
                    {
                        SetColor(mil, "yellow");
                    }
                }


                // promote to green
                if (myGoals.All(g => GetColor(g) == "green"))
                {
                    SetColor(mil, "green");
                }


                // MIL cumulative override
                // A satisfied (green) MIL 2-5 can't be green if his predecessor is not.
                if (mil.PreviousNode != null)
                {
                    if (GetColor((XElement)mil.PreviousNode) != "green")
                    {
                        SetColor(mil, "red");
                    }
                }
            }


            // Domain rollup
            foreach (var domain in XDoc.Descendants("Domain").ToList())
            {
                var myMils = domain.Descendants("Mil");

                // start with red
                SetColor(domain, "red");


                // promote to yellow
                if (myMils.Any(m => GetColor(m) == "yellow")
                    || myMils.Any(m => GetColor(m) == "green"))
                {
                    SetColor(domain, "yellow");
                }


                // promote to green
                if (myMils.All(m => GetColor(m) == "green"))
                {
                    SetColor(domain, "green");
                }
            }
        }

        public CrrReportChart GetPercentageOfPractice()
        {
            try
            {

                CrrReportChart rChart = new CrrReportChart();
                foreach (var domain in XDoc.Descendants("Domain").ToList())
                {
                    var dQuestions = domain.Descendants("Question")
                        .Where(q => q.Attribute("isparentquestion").Value == "false"
                        && q.Attribute("placeholder-p")?.Value != "true"
                    );
                    var questionTotal = (double)dQuestions.Count();
                    var dGreen = (double)dQuestions.Count(m => m.Attribute("answer").Value == "Y");
                    rChart.Labels.Add(domain.Attribute("title").Value);
                    if (questionTotal != 0)
                    {
                        rChart.Values.Add((int)((dGreen / questionTotal) * 100));
                    }
                    else
                    {
                        rChart.Values.Add(0);
                    }
                }


                return rChart;
            }
            catch (Exception e)
            {
                return null;
            }
        }


        /// <summary>
        /// Loads assessment answers into an XDocument
        /// that defines the NIST CSF function/category/subcategory structure.
        /// </summary>
        private void LoadNistCsfMappedAnswers()
        {
            var assembly = Assembly.GetExecutingAssembly();
            var resourceName = "CSETWebCore.Helpers.CrrNistCsfMapping.xml";
            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                string result = reader.ReadToEnd();
                XCsf = XDocument.Parse(result);
            }

            var questions = XDoc.Descendants("Question").ToList();

            foreach (XElement crrRef in XCsf.Descendants("CrrReference"))
            {
                var crrQuestions = questions.Where(q => q.Attribute("displaynumber").Value == crrRef.Attribute("question-title").Value).ToList();
                foreach (var crrQ in crrQuestions)
                {
                    crrRef.SetAttributeValue("answer", crrQ.Attribute("answer").Value);
                    crrRef.SetAttributeValue("questionid", crrQ.Attribute("questionid").Value);
                }
            }
        }





        #region helper methods

        /// <summary>
        /// Sets the scorecolor of an element
        /// </summary>
        /// <returns></returns>
        public string GetColor(XElement xE)
        {
            return xE.Attribute("scorecolor").Value;
        }


        /// <summary>
        /// Gets the scorecolor of an element
        /// </summary>
        public void SetColor(XElement xE, string color)
        {
            xE.SetAttributeValue("scorecolor", color);
        }


        /// <summary>
        /// The vertical color bars that represent the various NIST CSF functions.
        /// </summary>
        private Dictionary<string, string> csfFuncColors = new()
        {
            { "ID", "#3d5aff" },
            { "PR", "#5E00D5" },
            { "DE", "#EEFF0A" },
            { "RS", "#FE0600" },
            { "RC", "#1d9500" }
        };

        public Dictionary<string, string> CsfFunctionColors
        {
            get
            {
                return csfFuncColors;
            }
        }


        /// <summary>
        /// Bool-to-string
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        public string B2S(bool b)
        {
            return b ? "true" : "false";
        }


        private AnswerColorDistrib GetDistrib(List<XElement> xQs)
        {
            var greenCount = xQs.Where(q => q.Attribute("scorecolor").Value == "green").Count();
            var yellowCount = xQs.Where(q => q.Attribute("scorecolor").Value == "yellow").Count();
            var redCount = xQs.Where(q => q.Attribute("scorecolor").Value == "red" || q.Attribute("scorecolor").Value == "unanswered-gray").Count();

            return new AnswerColorDistrib()
            {
                Green = greenCount,
                Yellow = yellowCount,
                Red = redCount
            };
        }


        /// <summary>
        /// Returns the answer distribution of the entire xdoc.
        /// </summary>
        /// <returns></returns>
        public AnswerColorDistrib FullAnswerDistrib()
        {
            var xQs = XDoc.Descendants("Question").ToList();

            return GetDistrib(xQs);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainAbbrev"></param>
        /// <returns></returns>
        public AnswerColorDistrib DomainAnswerDistrib(string domainAbbrev)
        {
            var xDomain = XDoc.Descendants("Domain").Where(d => d.Attribute("abbreviation").Value == domainAbbrev);
            var xQs = xDomain.Descendants("Question").ToList();

            return GetDistrib(xQs);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainAbbrev"></param>
        /// <param name="goalAbbrev"></param>
        /// <returns></returns>
        public AnswerColorDistrib GoalAnswerDistrib(string domainAbbrev, string goalAbbrev)
        {
            var xGoal = XDoc.Descendants("Domain")
                .Where(d => d.Attribute("abbreviation").Value == domainAbbrev)
                .Descendants("Goal")
                .Where(g => g.Attribute("abbreviation").Value == goalAbbrev);

            var xQs = xGoal.Descendants("Question").ToList();

            return GetDistrib(xQs);
        }


        /// <summary>
        /// Returns an AnswerColorDistrib instance for the supplied 
        /// XElement.  All "CrrReference" descendants of the specified element
        /// are tallied for their answer values, Y, I or N.
        /// </summary>
        /// <param name="element"></param>
        /// <returns></returns>
        public AnswerColorDistrib CrrReferenceAnswerDistrib(XElement element)
        {
            var myQs = element.Descendants("CrrReference");

            var distrib = new AnswerColorDistrib()
            {
                Green = myQs.Count(x => x.Attribute("answer")?.Value == "Y"),
                Yellow = myQs.Count(x => x.Attribute("answer")?.Value == "I"),
                Red = myQs.Count(x => x.Attribute("answer")?.Value == "N")
            };

            return distrib;
        }


        #endregion
    }
}
