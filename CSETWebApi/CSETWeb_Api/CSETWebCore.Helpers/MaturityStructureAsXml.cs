//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
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
    public class MaturityStructureAsXml
    {
        private readonly CSETContext _context;

        public int AssessmentId { get; set; }

        private XDocument xDoc { get; set; }

        private AdditionalSupplemental _addlSuppl { get; set; }

        /// <summary>
        /// The consumer can optionally suppress 
        /// grouping descriptions, question text and supplemental info
        /// if they want a smaller response object.
        /// </summary>
        private bool _includeText = true;


        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityStructureAsXml(int assessmentId, CSETContext context, bool includeText)
        {
            this.AssessmentId = assessmentId;
            this._context = context;
            this._includeText = includeText;

            this._addlSuppl = new AdditionalSupplemental(context);

            LoadStructureAsXml();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        private void LoadStructureAsXml()
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
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Include(x => x.MATURITY_QUESTION_PROPS)
                .Where(q =>
                model.model_id == q.Maturity_Model_Id).ToList();


            // cull any questions that are above the target level (if the model supports a target)
            var targetLevel = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == this.AssessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();
            if (targetLevel != null)
            {
                questions.RemoveAll(x => x.Maturity_Level.Level > int.Parse(targetLevel.Standard_Specific_Sal_Level));
            }


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Where(x => x.Maturity_Model_Id == model.model_id).ToList();


            // manually populate grouping data.  Using a .Include() in the previous query was not working consistently
            var allGroupingTypes = _context.MATURITY_GROUPING_TYPES.ToList();

            foreach (var item in allGroupings)
            {
                if (item.Type == null)
                {
                    item.Type = new MATURITY_GROUPING_TYPES()
                    {
                        Type_Id = item.Type_Id,
                        Grouping_Type_Name = allGroupingTypes.Where(x => x.Type_Id == item.Type_Id).FirstOrDefault()?.Grouping_Type_Name
                    };
                }
            }


            // Get all remarks
            var allRemarks = _context.MATURITY_DOMAIN_REMARKS
                .Where(x => x.Assessment_Id == this.AssessmentId).ToList();


            GetSubgroupsAsXml(xDoc.Root, null, allGroupings, questions, answers.ToList(), allRemarks);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroupsAsXml(XElement xE, int? parentID,
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
                    .Regex.Replace(sg.Type.Grouping_Type_Name, " ", "_");
                var xGrouping = new XElement(nodeName);
                xE.Add(xGrouping);
                xGrouping.SetAttributeValue("abbreviation", sg.Abbreviation);

                if (_includeText)
                {
                    xGrouping.SetAttributeValue("description", sg.Description);
                }
                xGrouping.SetAttributeValue("groupingid", sg.Grouping_Id.ToString());
                xGrouping.SetAttributeValue("title", sg.Title);
                xGrouping.SetAttributeValue("titlePrefix", sg.Title_Prefix);

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
                    xQuestion.SetAttributeValue("answer", answer?.a.Answer_Text ?? "");
                    xQuestion.SetAttributeValue("comment", answer?.a.Comment ?? "");
                    xQuestion.SetAttributeValue("isparentquestion", B2S(parentQuestionIDs.Contains(myQ.Mat_Question_Id)));

                    if (_includeText)
                    {
                        xQuestion.SetAttributeValue("questiontext", myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> "));

                        xQuestion.SetAttributeValue("supplemental", myQ.Supplemental_Info);

                        // CPG question elements
                        xQuestion.SetAttributeValue("securitypractice", myQ.Security_Practice);
                        xQuestion.SetAttributeValue("outcome", myQ.Outcome);
                        xQuestion.SetAttributeValue("scope", myQ.Scope);
                        xQuestion.SetAttributeValue("recommendedaction", myQ.Recommend_Action);
                        xQuestion.SetAttributeValue("services", myQ.Services);
                        xQuestion.SetAttributeValue("implementationguides", myQ.Implementation_Guides);
                        xQuestion.SetAttributeValue("riskaddressed", myQ.Risk_Addressed);

                        // Include CSF mappings
                        var csfList = _addlSuppl.GetCsfMappings(myQ.Mat_Question_Id, "Maturity");
                        foreach (var csf in csfList)
                        {
                            var xCsf = new XElement("CSF");
                            xCsf.Value = csf;
                            xQuestion.Add(xCsf);
                        }

                        // Include any TTPs
                        var ttpList = _addlSuppl.GetTTPReferenceList(myQ.Mat_Question_Id);
                        foreach (var ttp in ttpList)
                        {
                            var xTtp = new XElement("TTP");
                            xTtp.Value = ttp.Description;
                            xQuestion.Add(xTtp);
                        }


                        xQuestion.SetAttributeValue("referencetext",
                            myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text);
                    }

                    foreach (var prop in myQ.MATURITY_QUESTION_PROPS)
                    {
                        var xProp = new XElement("Prop");
                        xProp.SetAttributeValue("name", prop.PropertyName);
                        xProp.SetAttributeValue("value", prop.PropertyValue);
                        xQuestion.Add(xProp);
                    }

                    xGrouping.Add(xQuestion);
                }


                // Recurse down to build subgroupings
                GetSubgroupsAsXml(xGrouping, sg.Grouping_Id, allGroupings, questions, answers, remarks);
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
