//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model.Maturity.CPG;


namespace CSETWebCore.Helpers
{
    /// <summary>
    /// The idea is a lightweight XDocument based 
    /// representation of the CPG model's questions
    /// in their grouping structure.
    /// 
    /// </summary>
    public class CpgStructure
    {
        private readonly CSETContext _context;

        public int AssessmentId { get; set; }

        /// <summary>
        /// The structure can also be used to define an SSG model
        /// besides the main CPG model.  This attribute is set
        /// to load the SSG model.
        /// </summary>
        public int? ModelId { get; set; }

        public ContentModel Top { get; set; }

        private AdditionalSupplemental _addlSuppl { get; set; }

        /// <summary>
        /// The consumer can optionally suppress 
        /// grouping descriptions, question text and supplemental info
        /// if they want a smaller response object.
        /// </summary>
        private bool _includeText = true;


        private string _lang = "en";
        /// <summary>
        /// 
        /// </summary>
        private TranslationOverlay _overlay;




        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public CpgStructure(int assessmentId, CSETContext context, bool includeText, string lang, int? modelId)
        {
            this.AssessmentId = assessmentId;
            this._context = context;
            this._includeText = includeText;

            if (modelId == null)
            {
                var availModel = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == this.AssessmentId && x.Selected).FirstOrDefault();
                if (availModel == null)
                {
                    return;
                }

                this.ModelId = availModel.model_id;
            }
            else
            {
                this.ModelId = (int)modelId;
            }


            this._addlSuppl = new AdditionalSupplemental(context);

            // set up translation resources
            this._overlay = new TranslationOverlay();
            this._lang = lang;

            LoadStructure();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy in an XDocument.
        /// </summary>
        private void LoadStructure()
        {
            Top = new ContentModel();

            var mm = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == this.ModelId).FirstOrDefault();
            if (mm == null)
            {
                return;
            }


            Top.AssessmentId = this.AssessmentId;
            Top.ModelName = mm.Model_Name;
            Top.ModelId = (int)this.ModelId;



            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Include(x => x.MATURITY_QUESTION_PROPS)
                .Where(q => q.Maturity_Model_Id == ModelId).ToList();


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
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == ModelId).ToList();

            // Get all remarks
            var allRemarks = _context.MATURITY_DOMAIN_REMARKS
                .Where(x => x.Assessment_Id == this.AssessmentId).ToList();


            GetSubgroups(Top.Domains, null, allGroupings, questions, answers.ToList(), allRemarks);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroups(List<Model.Maturity.CPG.Domain> domainList,
            int? parentID,
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
                var grouping = new Model.Maturity.CPG.Domain();
                domainList.Add(grouping);
                grouping.Abbreviation = sg.Abbreviation;

                if (_includeText)
                {
                    grouping.Description = sg.Description;
                }
                grouping.GroupingId = sg.Grouping_Id;
                grouping.Title = sg.Title;
                grouping.TitlePrefix = sg.Title_Prefix;

                var remark = remarks.FirstOrDefault(r => r.Grouping_ID == sg.Grouping_Id);
                grouping.Remarks = remark?.DomainRemarks ?? "";



                // i18n
                grouping.Title = _overlay.GetMaturityGrouping(grouping.GroupingId, _lang)?.Title ?? grouping.Title;




                // are there any questions that belong to this grouping?
                var myQuestionsNative = questions.Where(x => x.Grouping_Id == sg.Grouping_Id).ToList();

                var parentQuestionIDs = myQuestionsNative.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestionsNative.OrderBy(s => s.Sequence))
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();
                    var question = QuestionAnswerBuilder.BuildCpgQuestion(myQ, answer);


                    if (_includeText)
                    {
                        question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                        question.Supplemental = myQ.Supplemental_Info;


                        // CPG question elements
                        question.SecurityPractice = myQ.Security_Practice;
                        question.Outcome = myQ.Outcome;
                        question.Scope = myQ.Scope;
                        question.RecommendedAction = myQ.Recommend_Action;
                        question.Services = myQ.Services;
                        question.ImplementationGuides = myQ.Implementation_Guides;
                        question.RiskAddressed = myQ.Risk_Addressed;

                        // Include CSF mappings
                        var csfList = _addlSuppl.GetCsfMappings(myQ.Mat_Question_Id, "Maturity");
                        foreach (var csf in csfList)
                        {
                            question.CsfMappings.Add(csf);
                        }

                        // Include any TTPs
                        var ttpList = _addlSuppl.GetTTPReferenceList(myQ.Mat_Question_Id);
                        foreach (var ttp in ttpList)
                        {
                            question.TTP.Add(ttp);
                        }


                        question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;
                    }


                    question.Cost = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "COST")?.PropertyValue;
                    question.Impact = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "IMPACT")?.PropertyValue;
                    question.Complexity = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "COMPLEXITY")?.PropertyValue;


                    // overlay
                    var o = _overlay.GetMaturityQuestion(question.QuestionId, _lang);
                    if (o != null)
                    {
                        question.QuestionText = o.QuestionText;
                        question.SecurityPractice = o.SecurityPractice;
                        question.Outcome = o.Outcome;
                        question.Scope = o.Scope;
                        question.RiskAddressed = o.RiskAddressed;
                        question.RecommendedAction = o.RecommendAction;
                    }

                    grouping.Questions.Add(question);
                }


                // Recurse down to build subgroupings
                GetSubgroups(grouping.Groupings, sg.Grouping_Id, allGroupings, questions, answers, remarks);
            }
        }
    }
}
