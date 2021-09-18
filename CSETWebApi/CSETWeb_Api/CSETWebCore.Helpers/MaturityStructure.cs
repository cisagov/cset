using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// The idea is a lightweight XDocument based 
    /// representation of any maturity model's questions
    /// in their grouping structure.
    /// 
    /// </summary>
    public class MaturityStructure
    {
        private readonly CSETContext _context;

        public int AssessmentId { get; set; }

        private XDocument xDoc { get; set; }


        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityStructure(int assessmentId, CSETContext context)
        {
            this.AssessmentId = assessmentId;
            this._context = context;

            LoadStructure();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        public void LoadStructure()
        {
            xDoc = new XDocument(new XElement("Model"));


            // determine the assessment's maturity model
            var model = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == this.AssessmentId && x.Selected).FirstOrDefault();
            if (model == null)
            {
                return;
            }

            var mm = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == model.model_id).FirstOrDefault();
            if (mm == null)
            {
                return;
            }

            xDoc.Root.SetAttributeValue("assessmentid", this.AssessmentId);
            xDoc.Root.SetAttributeValue("model", mm.Model_Name);
            xDoc.Root.SetAttributeValue("modelid", model.model_id);


            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                model.model_id == q.Maturity_Model_Id).ToList();

            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type_)
                .Where(x => x.Maturity_Model_Id == model.model_id).ToList();

            // Get all remarks
            var allRemarks = _context.MATURITY_DOMAIN_REMARKS
                .Where(x => x.Assessment_Id == this.AssessmentId).ToList();


            GetSubgroups(xDoc.Root, null, allGroupings, questions, answers.ToList(), allRemarks);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        public void GetSubgroups(XElement xE, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
           List<MATURITY_QUESTIONS> questions,
           List<FullAnswer> answers,
           List<MATURITY_DOMAIN_REMARKS> remarks)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var nodeName = System.Text.RegularExpressions
                    .Regex.Replace(sg.Type_.Grouping_Type_Name, " ", "_");
                var xGrouping = new XElement(nodeName);
                xE.Add(xGrouping);
                xGrouping.SetAttributeValue("abbreviation", sg.Abbreviation);
                xGrouping.SetAttributeValue("description", sg.Description);
                xGrouping.SetAttributeValue("groupingid", sg.Grouping_Id.ToString());
                xGrouping.SetAttributeValue("title", sg.Title);

                var remark = remarks.FirstOrDefault(r => r.Grouping_ID == sg.Grouping_Id);
                xGrouping.SetAttributeValue("remarks", remark != null ? remark.DomainRemarks : "");
                


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

                    xQuestion.SetAttributeValue("referencetext",
                        myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text);
                    //xQuestion.SetAttributeValue("supplemental", myQ.Supplemental_Info);

                    xGrouping.Add(xQuestion);
                }


                // Recurse down to build subgroupings
                GetSubgroups(xGrouping, sg.Grouping_Id, allGroupings, questions, answers, remarks);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public XDocument ToXDocument()
        {
            return this.xDoc;
        }


        /// <summary>
        /// Returns the assessment's maturity question structure as XML.
        /// </summary>
        /// <returns></returns>
        public string ToXml()
        {
            return this.xDoc.ToString();
        }


        /// <summary>
        /// Returns the assessment's maturity question structure as JSON.
        /// </summary>
        /// <returns></returns>
        public string ToJson()
        {
            return CustomJsonWriter.Serialize(this.xDoc.Root);
        }


        /// <summary>
        /// Bool-to-string
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
        public static string B2S(bool b)
        {
            return b ? "true" : "false";
        }
    }
}
