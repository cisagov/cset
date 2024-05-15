//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Model.Cmu;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Reports.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// 
    /// </summary>
    public class CmuScoringHelper : ICmuScoringHelper
    {
        private readonly CSETContext _context;

        public int AssessmentId { get; set; }

        public int ModelId { get; set; }


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
        public CmuScoringHelper(CSETContext context)
        {
            this._context = context;
        }

        public void InstantiateScoringHelper(int assessmentId)
        {
            this.AssessmentId = assessmentId;

            var dbModel = _context.AVAILABLE_MATURITY_MODELS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
            if (dbModel == null)
            {
                throw new Exception("The assessment does not use a maturity model");
            }

            this.ModelId = dbModel.model_id;

            LoadStructure();

            if (this.ModelId == 3 || this.ModelId == 4)
            {
                ManipulateStructure();
            }

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
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                ModelId == q.Maturity_Model_Id).ToList();


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == ModelId).ToList();


            // Get all domain remarks for the assessment
            var domainRemarks = _context.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == AssessmentId).ToList();


            GetSubgroups(XDoc.Root, null, allGroupings, questions, answers.ToList(), domainRemarks);

        }

        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        public void GetSubgroups(XElement xE, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
           List<MATURITY_QUESTIONS> questions,
           List<FullAnswer> answers,
           List<MATURITY_DOMAIN_REMARKS> domainRemarks)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var domainRemark = domainRemarks.Where(x => x.Grouping_ID == sg.Grouping_Id).FirstOrDefault();
                var xGrouping = new XElement(sg.Type.Grouping_Type_Name);
                xE.Add(xGrouping);
                xGrouping.SetAttributeValue("abbreviation", sg.Abbreviation);
                xGrouping.SetAttributeValue("groupingid", sg.Grouping_Id.ToString());
                xGrouping.SetAttributeValue("title", sg.Title);
                xGrouping.SetAttributeValue("description", sg.Description);
                if (domainRemark != null)
                {
                    xGrouping.SetAttributeValue("remark", domainRemark.DomainRemarks);
                }


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
                    catch (Exception exc)
                    {
                        NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                    }

                    xGrouping.Add(xQuestion);
                }


                // Recurse down to build subgroupings
                GetSubgroups(xGrouping, sg.Grouping_Id, allGroupings, questions, answers, domainRemarks);
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
                    xMil.SetAttributeValue("level", i);
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
        /// No and Unanswered are set to red.
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
                    default:
                        SetColor(q, "red");
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
                // Some models may have Mil elements as children, some may have Domain elements as children
                var myChildren = domain.Elements();

                // start with red
                SetColor(domain, "red");


                // promote to yellow
                if (myChildren.Any(m => GetColor(m) == "yellow")
                    || myChildren.Any(m => GetColor(m) == "green"))
                {
                    SetColor(domain, "yellow");
                }


                // promote to green
                if (myChildren.All(m => GetColor(m) == "green"))
                {
                    SetColor(domain, "green");
                }
            }
        }


        /// <summary>
        /// Calculates a raw percentage of 'Yes' answers for each Domain
        /// </summary>
        /// <returns></returns>
        public CmuReportChart GetPercentageOfPractice()
        {
            try
            {
                var results = GetCmuResultsSummary();
                CmuReportChart rChart = new CmuReportChart();
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
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                return null;
            }
        }


        /// <summary>
        /// Calculates the Goal, MIL and Domain scores and stores them in the XDoc
        /// </summary>
        /// <returns></returns>
        public CmuResultsModel GetCmuResultsSummary()
        {
            var crrDomains = new List<CmuMaturityDomainModel>();
            foreach (var domain in XDoc.Descendants("Domain").ToList())
            {
                var domainModel = new CmuMaturityDomainModel(domain.Attribute("title")?.Value);

                var mils = domain.Descendants("Mil").OrderBy(x => x.Attribute("label").Value).ToList();

                foreach (var mil in mils)
                {
                    CalculateMilScore(mil);
                }

                CalculateDomainScore(domain);
                domainModel.DomainScore = double.Parse(domain.Attribute("numericscore").Value);
                domainModel.AcheivedLevel = int.Parse(domain.Attribute("achievedlevel").Value);


                // RKW - I don't think we are actually using this, other than a place to stash domain bar widths
                domainModel.AddLevelData(
                new DomainStats()
                {
                    domainName = domainModel.DomainName,
                    ModelLevel = "1"
                });

                crrDomains.Add(domainModel);
            }


            // DEBUG:  Uncomment this if you need a scoring breakdown 
            // var csv = ExportScoringCsv();


            var cmuResultsModel = new CmuResultsModel
            {
                CmuDomains = crrDomains
            };
            cmuResultsModel.TrimToNElements(10);
            cmuResultsModel.GenerateWidthValues();
            return cmuResultsModel;
        }


        /// <summary>
        /// Calculates the MIL score by averaging the scores of the questions in each goal,
        /// and then averaging the goal scores.
        /// </summary>
        /// <param name="goals"></param>
        private void CalculateMilScore(XElement mil)
        {
            var goals = mil.Descendants("Goal");
            var goalAverages = new List<double>();

            // for each goal, total his questions
            foreach (var goal in goals)
            {
                double goalTotal = 0;

                var questions = goal.Descendants("Question")
                        .Where(q => q.Attribute("isparentquestion").Value == "false"
                                    && q.Attribute("placeholder-p")?.Value != "true");

                foreach (var question in questions)
                {
                    if (question.Attribute("answer").Value == "Y")
                    {
                        goalTotal += 1;
                    }
                    if (question.Attribute("answer").Value == "I")
                    {
                        goalTotal += .5;
                    }
                }

                var goalScore = goalTotal / (double)questions.Count();
                goal.SetAttributeValue("numericscore", goalScore);

                goalAverages.Add(goalScore);
            }

            // average the goal scores for the mil score
            var milScore = goalAverages.Average();
            mil.SetAttributeValue("numericscore", milScore);
        }


        /// <summary>
        /// Determine the domain score by "stacking" up complete MIL scores,
        /// including the first partial MIL score we encounter.
        /// </summary>
        /// <param name="domain"></param>
        /// <returns></returns>
        private void CalculateDomainScore(XElement domain)
        {
            double score = 0;
            domain.SetAttributeValue("achievedlevel", 0);

            foreach (var mil in domain.Descendants("Mil"))
            {
                var milScore = double.Parse(mil.Attribute("numericscore").Value);

                if (milScore == 1)
                {
                    score += milScore;
                }
                else
                {
                    score += milScore;
                    break;
                }
            }

            domain.SetAttributeValue("achievedlevel", Math.Floor(score));
            domain.SetAttributeValue("numericscore", score);
        }


        /// <summary>
        /// Loads assessment answers into an XDocument
        /// that defines the NIST CSF function/category/subcategory structure.
        /// </summary>
        private void LoadNistCsfMappedAnswers()
        {
            /// TODO:  Instead of reading an embedded XML file, read the database CSF_MAPPING

            var mappings = from mq in _context.MATURITY_QUESTIONS
                           join cm in _context.CSF_MAPPING on mq.Mat_Question_Id equals cm.Question_Id
                           where mq.Maturity_Model_Id == this.ModelId
                           select new { cm = cm, mq = mq };
            var abc = mappings.ToList();


            var assembly = Assembly.GetExecutingAssembly();
            var resourceName = "CSETWebCore.Helpers.NIST_CSF_Structure.xml";
            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            using (StreamReader reader = new StreamReader(stream))
            {
                XCsf = XDocument.Parse(reader.ReadToEnd());
            }

            // populate the XML structure with the mapped questions
            foreach (var ab in abc)
            {
                var node = XCsf.Descendants().Where(x => x.Attribute("title")?.Value == ab.cm.CSF_Code).FirstOrDefault();
                if (node != null)
                {
                    var reff = new XElement("CrrReference");
                    reff.SetAttributeValue("question-title", ab.mq.Question_Title);
                    node.Element("References").Add(reff);
                }
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


        /// <summary>
        /// Generates a CSV containing scoring.
        /// </summary>
        /// <returns></returns>
        public string ExportScoringCsv()
        {
            var sb = new StringBuilder();

            sb.AppendLine("Domain\tMIL Level\tGoal\tGoal Score\tMIL Score\tDomain Score");

            foreach (var d in XDoc.Descendants("Domain"))
            {
                var domainName = d.Attribute("abbreviation").Value;

                foreach (var m in d.Descendants("Mil"))
                {
                    var milLevel = int.Parse(m.Attribute("level").Value);
                    foreach (var g in m.Descendants("Goal"))
                    {
                        var goalName = g.Attribute("abbreviation").Value;
                        var goalScore = g.Attribute("numericscore").Value;

                        // for MIL-2 thru 5 include the score in the MIL Score column
                        var milScore = (milLevel > 1) ? goalScore : "";

                        sb.AppendLine($"{domainName}\t{milLevel}\t{goalName}\t{goalScore}\t{milScore}");
                    }

                    if (milLevel == 1)
                    {
                        var milScore = m.Attribute("numericscore").Value;
                        sb.AppendLine($"\t\t\t\t{milScore}");
                    }
                }

                var domainScore = d.Attribute("numericscore").Value;
                sb.AppendLine($"\t\t\t\t\t{domainScore}");
                sb.AppendLine("");
            }

            return sb.ToString();
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
            { "ID", "#4567b7" },
            { "PR", "#8a1982" },
            { "DE", "#ead607" },
            { "RS", "#ff0006" },
            { "RC", "#328320" }
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
            var redCount = xQs.Where(q => q.Attribute("scorecolor").Value == "red").Count();

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
        /// Returns the answer distribution of the entire xdoc.
        /// </summary>
        /// <returns></returns>
        public AnswerColorDistrib MIL1FullAnswerDistrib()
        {
            var xQs = XDoc.Descendants("Mil").Where(el => el.Attribute("label") != null && el.Attribute("label").Value == "MIL-1").Descendants("Question").ToList();

            return GetDistrib(xQs);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainAbbrev"></param>
        /// <returns></returns>
        public AnswerColorDistrib MIL1DomainAnswerDistrib(string domainAbbrev)
        {
            var xDomain = XDoc.Descendants("Domain").Where(d => d.Attribute("abbreviation").Value == domainAbbrev).Descendants("Mil").Where(el => el.Attribute("label") != null && el.Attribute("label").Value == "MIL-1");
            var xQs = xDomain.Descendants("Question").ToList();

            return GetDistrib(xQs);
        }


        /// <summary>
        /// Returns the answer distribution for a single domain 
        /// as specified by its abbreviation.
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
                Red = myQs.Count(x => x.Attribute("answer")?.Value == "N"
                    || x.Attribute("answer")?.Value == "U")
            };

            return distrib;
        }


        #endregion
    }
}
