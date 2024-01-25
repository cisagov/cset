//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.Xml.Linq;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Xml;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// A simple XML view of a tree question/option set with answers included
    /// </summary>
    public class QuestionTreeXml
    {
        private readonly CSETContext _context;
        private int _assessmentId;
        private readonly int _maturityModelId = 8;

        // query some data collections up front to avoid lots of database access

        private List<MATURITY_QUESTIONS> allQuestions;

        private List<ANSWER> allAnswers;

        private List<MATURITY_GROUPINGS> allGroupings;


        private XDocument _xDoc;


        /// <summary>
        /// 
        /// </summary>
        public QuestionTreeXml(int assessmentId, CSETContext context)
        {
            this._context = context;
            this._assessmentId = assessmentId;

            Initialize();
        }


        /// <summary>
        /// Returns the XML 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return _xDoc.ToString();
        }


        public XDocument Document
        {
            get { return _xDoc; }
        }


        /// <summary>
        /// 
        /// </summary>
        public void Initialize()
        {
            _xDoc = new XDocument(new XElement("Model"));

            allQuestions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                _maturityModelId == q.Maturity_Model_Id).ToList();

            allAnswers = _context.ANSWER
                .Where(a => a.Question_Type == Constants.Constants.QuestionTypeMaturity
                    && a.Assessment_Id == this._assessmentId)
                .ToList();


            // Get all groupings for this maturity model
            allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _maturityModelId).ToList();


            GetGroups((XElement)_xDoc.FirstNode, null);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// If the filterId is specified, the subgroups are reduced to that one.
        /// </summary>
        private void GetGroups(XElement oParent, int? parentId, int? filterId = null)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentId).OrderBy(x => x.Sequence).ToList();

            if (filterId != null)
            {
                mySubgroups = allGroupings.Where(x => x.Grouping_Id == filterId).ToList();
            }

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var nodeName = System.Text.RegularExpressions
                    .Regex.Replace(sg.Type.Grouping_Type_Name, " ", "_");

                var xG = new XElement("Grouping");
                xG.SetAttributeValue("id", sg.Grouping_Id);
                xG.SetAttributeValue("text", sg.Title);
                xG.SetAttributeValue("desc", sg.Description);
                oParent.Add(xG);


                GetQuestions(xG);

                GetGroups(xG, sg.Grouping_Id);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="groupingId"></param>
        private void GetQuestions(XElement xParent)
        {
            int parentId = int.Parse(xParent.Attribute("id").Value);


            // a question can be a child of a grouping, option or another question
            List<MATURITY_QUESTIONS> myQuestions = new List<MATURITY_QUESTIONS>();

            switch (xParent.Name.ToString())
            {
                case "Grouping":
                    myQuestions = allQuestions.Where(x => x.Grouping_Id == parentId
                        && x.Parent_Question_Id == null && x.Parent_Option_Id == null).ToList();
                    break;
                case "Question":
                    myQuestions = allQuestions.Where(x => x.Parent_Question_Id == parentId
                        && x.Parent_Option_Id == null).ToList();
                    break;
                case "Option":
                    myQuestions = allQuestions.Where(x => x.Parent_Option_Id == parentId
                        && x.Parent_Question_Id == null).ToList();
                    break;
            }


            var xQuestions = new XElement("Questions");
            if (myQuestions.Count > 0)
            {
                xParent.Add(xQuestions);
            }


            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                List<ANSWER> answers = allAnswers.Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id).ToList();
                ConsolidateAnswers(answers, out ANSWER answer);

                var xQ = new XElement("Question");
                xQuestions.Add(xQ);

                xQ.SetAttributeValue("id", myQ.Mat_Question_Id);
                xQ.SetAttributeValue("text", myQ.Question_Text);
                xQ.SetAttributeValue("answer-text", answer?.Answer_Text);

                GetOptions(xQ);

                GetQuestions(xQ);
            }
        }


        /// <summary>
        /// Build options for a question.
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        private void GetOptions(XElement xQuestion)
        {
            int questionId = int.Parse(xQuestion.Attribute("id").Value);

            var opts = _context.MATURITY_ANSWER_OPTIONS.Where(x => x.Mat_Question_Id == questionId)
                .OrderBy(x => x.Answer_Sequence)
                .ToList();

            foreach (var o in opts)
            {
                var xO = new XElement("Option");
                xQuestion.Add(xO);

                xO.SetAttributeValue("id", o.Mat_Option_Id);
                xO.SetAttributeValue("option-text", o.Option_Text);
                xO.SetAttributeValue("type", o.Mat_Option_Type);
                xO.SetAttributeValue("sequence", o.Answer_Sequence);
                xO.SetAttributeValue("weight", o.Weight);

                if (o.Mat_Option_Type == "checkbox" || o.Mat_Option_Type == "radio")
                {
                    xO.SetAttributeValue("selected", "false");
                }


                // Now include answer info, if an answer exists
                var ans = allAnswers.Where(x => x.Question_Or_Requirement_Id == o.Mat_Question_Id
                && x.Mat_Option_Id == o.Mat_Option_Id).FirstOrDefault();

                if (ans != null)
                {
                    xO.SetAttributeValue("answer-id", ans.Answer_Id);

                    if (o.Mat_Option_Type == "checkbox" || o.Mat_Option_Type == "radio")
                    {
                        xO.SetAttributeValue("selected", ans.Answer_Text == "S");
                    }
                    else
                    {
                        xO.SetAttributeValue("answer-text", ans.Answer_Text);
                    }

                    xO.SetAttributeValue("free-response", ans.Free_Response_Answer);
                }

                GetQuestions(xO);
            }
        }


        /// <summary>
        /// Merges property data into a single answer object from multiple ANSWER records
        /// (We can store multiple ANSWER records for a single CIS question,
        ///  i.e. one to hold question extras and rest to store option selections)
        /// </summary>
        /// <param name="answers"></param>
        /// <param name="answer"></param>
        private void ConsolidateAnswers(List<ANSWER> answers, out ANSWER answer)
        {
            if (answers.Count == 0)
            {
                answer = null;
                return;
            }

            answer = answers[0];

            if (answers.Count == 1)
            {
                return;
            }

            foreach (ANSWER a in answers)
            {
                // Want the selection status
                if (a.Answer_Text == "S" || a.Answer_Text == "")
                {
                    answer.Answer_Text = a.Answer_Text;
                }

                if (!string.IsNullOrEmpty(a.Free_Response_Answer))
                {
                    answer.Free_Response_Answer = a.Free_Response_Answer;
                }

                // Now get all the question extras
                if (!string.IsNullOrEmpty(a.Comment))
                {
                    answer.Comment = a.Comment;
                }

                if (!string.IsNullOrEmpty(a.FeedBack))
                {
                    answer.FeedBack = a.FeedBack;
                }

                if (a.Mark_For_Review != null)
                {
                    answer.Mark_For_Review = a.Mark_For_Review;
                }
            }
        }


        /// <summary>
        /// Returns a list of Question IDs that are descendants of 
        /// an unselected Option.
        /// </summary>
        /// <returns></returns>
        public List<int> OutOfScopeQuestionIds()
        {
            List<int> outOfScopeIds = new List<int>();

            var xml = new XmlDocument();
            using (var xmlReader = _xDoc.CreateReader())
            {
                xml.Load(xmlReader);
            }


            var outOfScopeQuestions = xml.SelectNodes("//Option[@selected='false']//Question");
            foreach (XmlNode q in outOfScopeQuestions)
            {
                outOfScopeIds.Add(int.Parse(q.Attributes["id"].Value));
            }

            return outOfScopeIds;
        }
    }
}
