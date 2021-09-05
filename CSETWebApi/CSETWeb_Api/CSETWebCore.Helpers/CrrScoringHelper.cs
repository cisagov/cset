using CSETWebCore.DataLayer;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using CSETWebCore.Model;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// 
    /// </summary>
    public class CrrScoringHelper
    {
        private readonly CSETContext _context;

        private int _assessmentId;

        private int _crrModelId = 4;

        /// <summary>
        /// The XDocument that holds everything
        /// </summary>
        public XDocument xDoc = null;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        public CrrScoringHelper(CSETContext context, int assessmentId)
        {
            this._assessmentId = assessmentId;
            this._context = context;

            LoadStructure();

            ManipulateStructure();

            Rollup();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        private void LoadStructure()
        {
            xDoc = new XDocument(new XElement("Model"));


            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Where(q =>
                _crrModelId == q.Maturity_Model_Id).ToList();

            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type_)
                .Where(x => x.Maturity_Model_Id == _crrModelId).ToList();


            GetSubgroups(xDoc.Root, null, allGroupings, questions, answers.ToList());
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroups(XElement xE, int? parentID,
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

                    xGrouping.Add(xQuestion);
                }


                // Recurse down to build subgroupings
                GetSubgroups(xGrouping, sg.Grouping_Id, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// Put goals under MILs.  Other shuffling.
        /// </summary>
        private void ManipulateStructure()
        {
            // create MIL nodes
            var domains = xDoc.Descendants("Domain").ToList();
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

                        milGoal.SetAttributeValue("ghost", "true");
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



            // TODO: include a placeholder for P if only I, T, D present.
            // This dummy is shown on the domain heatmap as a light gray box
            // xDoc.Descendants("Question").Where(q => q.)
        }


        /// <summary>
        /// Color the nodes based on their children and a few other rules.
        /// </summary>
        private void Rollup()
        {
            // Color all questions based on their answers
            foreach (var q in xDoc.Descendants("Question"))
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
                    SetColor(q, "gray");
                }
            }



            // Goal rollup
            foreach (var goal in xDoc.Descendants("Goal").ToList())
            {
                SetColor(goal, "red");

                // try for yellow
                if (goal.Descendants("Question")
                    .Where(q => q.Attribute("isparentquestion").Value == "false")
                    .Any(q => GetColor(q) == "yellow"))
                {
                    SetColor(goal, "yellow");
                }

                // try for green
                if (goal.Descendants("Question")
                    .Where(q => q.Attribute("isparentquestion").Value == "false")
                    .All(q => GetColor(q) == "green"))
                {
                    SetColor(goal, "green");
                }
            }


            // Basic MIL rollup (this could get overridden with the following 'cumulative' check)
            foreach (var mil in xDoc.Descendants("Mil").ToList())
            {
                SetColor(mil, "red");

                if (mil.Descendants("Goal").Any(g => GetColor(g) == "yellow"))
                {
                    SetColor(mil, "yellow");
                }

                if (mil.Descendants("Goal").All(g => GetColor(g) == "green"))
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
            foreach (var domain in xDoc.Descendants("Domain").ToList())
            {
                SetColor(domain, "red");

                if (domain.Descendants("Mil").Any(m => GetColor(m) == "yellow"))
                {
                    SetColor(domain, "yellow");
                }

                if (domain.Descendants("Mil").All(m => GetColor(m) == "green"))
                {
                    SetColor(domain, "green");
                }
            }
        }


        /// <summary>
        /// Sets the scorecolor of an element
        /// </summary>
        /// <returns></returns>
        private string GetColor(XElement xE)
        {
            return xE.Attribute("scorecolor").Value;
        }


        /// <summary>
        /// Gets the scorecolor of an element
        /// </summary>
        private void SetColor(XElement xE, string color)
        {
            xE.SetAttributeValue("scorecolor", color);
        }


        /// <summary>
        /// Bool-to-string
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        private static string B2S(bool b)
        {
            return b ? "true" : "false";
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainAbbrev"></param>
        /// <returns></returns>
        public AnswerColorDistrib DomainAnswerDistrib(string domainAbbrev)
        {
            var xDomain = xDoc.Descendants("Domain").Where(d => d.Attribute("abbreviation").Value == domainAbbrev);
            var xQs = xDomain.Descendants("Question").ToList();

            var greenCount = xQs.Where(q => q.Attribute("scorecolor").Value == "green").Count();
            var yellowCount = xQs.Where(q => q.Attribute("scorecolor").Value == "yellow").Count();
            var redCount = xQs.Where(q => q.Attribute("scorecolor").Value == "red").Count();

            return new AnswerColorDistrib() {
                Green = greenCount,
                Yellow = yellowCount,
                Red = redCount
            };            
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainAbbrev"></param>
        /// <param name="goalAbbrev"></param>
        /// <returns></returns>
        public AnswerColorDistrib GoalAnswerDistrib(string domainAbbrev, string goalAbbrev)
        {
            var xGoal = xDoc.Descendants("Domain")
                .Where(d => d.Attribute("abbreviation").Value == domainAbbrev)
                .Descendants("Goal")
                .Where(g => g.Attribute("abbreviation").Value == goalAbbrev);

            var xQs = xGoal.Descendants("Question").ToList();

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
    }
}
