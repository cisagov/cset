//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Model.Nested;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Represents a maturity model's questions
    /// in their grouping structure.  
    /// 
    /// </summary>
    public class MaturityStructureForModel
    {
        private readonly CSETContext _context;

        private readonly int _modelId;

        public ModelStructure Model;

        private List<MATURITY_GROUPINGS> allGroupings;

        private List<MATURITY_QUESTIONS> allQuestions;

        private List<ANSWER> allAnswers;

        private int _assessmentId;



        /// <summary>
        /// The consumer can optionally suppress 
        /// grouping descriptions, question text and supplemental info
        /// if they want a smaller response object.
        /// </summary>
        private bool _includeText = true;


        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for a maturity model.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityStructureForModel(int modelId, CSETContext context, bool includeText = true, int assessmentId = 0)
        {
            this._modelId = modelId;
            this._context = context;
            this._includeText = includeText;
            this._assessmentId = assessmentId;

            LoadStructure();
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic
        /// hierarchy.
        /// </summary>
        private void LoadStructure()
        {
            Model = new ModelStructure();


            var mm = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == _modelId).FirstOrDefault();
            if (mm == null)
            {
                return;
            }

            Model.ModelId = _modelId;
            Model.ModelName = mm.Model_Name;
            Model.ModelTitle = mm.Model_Title;


            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            allQuestions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                _modelId == q.Maturity_Model_Id).ToList();


            allAnswers = _context.ANSWER
                .Where(a => a.Question_Type == Constants.Constants.QuestionTypeMaturity && a.Assessment_Id == _assessmentId)
                .ToList();



            // Get all subgroupings for this maturity model
            allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _modelId).ToList();



            GetSubgroups(Model, null);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// </summary>
        private void GetSubgroups(object oParent, int? parentID)
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

                var grouping = new Grouping()
                {
                    GroupType = nodeName,
                    Abbreviation = sg.Abbreviation,
                    GroupingId = sg.Grouping_Id,
                    Prefix = sg.Title_Prefix,
                    Title = sg.Title
                };

                if (_includeText)
                {
                    grouping.Description = sg.Description;
                }

                if (oParent is ModelStructure)
                {
                    ((ModelStructure)oParent).Groupings.Add(grouping);
                }

                if (oParent is Grouping)
                {
                    ((Grouping)oParent).Groupings.Add(grouping);
                }



                // are there any questions that belong to this grouping?
                var myQuestions = allQuestions.Where(x => x.Grouping_Id == sg.Grouping_Id
                    && x.Parent_Question_Id == null && x.Parent_Option_Id == null).ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    var answer = allAnswers
                        .FirstOrDefault(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id && x.Mat_Option_Id == null);

                    var question = new Question()
                    {
                        QuestionId = myQ.Mat_Question_Id,
                        Sequence = myQ.Sequence,
                        MaturityLevel = myQ.Maturity_Level.Level,
                        MaturityLevelName = myQ.Maturity_Level.Level_Name,
                        DisplayNumber = myQ.Question_Title,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        QuestionType = myQ.Mat_Question_Type,
                        AnswerText = answer?.Answer_Text,
                        Comment = answer?.Comment,
                        Options = GetOptions(myQ.Mat_Question_Id)
                    };

                    if (_includeText)
                    {
                        question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");

                        // CPG elements
                        question.SecurityPractice = myQ.Security_Practice;
                        question.Outcome = myQ.Outcome;
                        question.Scope = myQ.Scope;
                        question.RecommendedAction = myQ.Recommend_Action;
                        question.ImplementationGuides = myQ.Implementation_Guides;

                        question.SupplementalInfo = myQ.Supplemental_Info;
                        question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;

                        GetReferences(myQ.Mat_Question_Id, out List<ReferenceDocLink> s, out List<ReferenceDocLink> r);
                        question.SourceDocuments = s;
                        question.AdditionalDocuments = r;
                    }

                    grouping.Questions.Add(question);

                    var followups = GetFollowupQuestions(myQ.Mat_Question_Id);
                    question.Followups.AddRange(followups);
                }


                // Recurse down to build subgroupings
                GetSubgroups(grouping, sg.Grouping_Id);
            }
        }


        /// <summary>
        /// Get questions that are followups to QUESTIONS
        /// </summary>
        /// <param name="allQuestions"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        private List<Question> GetFollowupQuestions(int parentId)
        {
            var qList = new List<Question>();

            var myQuestions = allQuestions.Where(x => x.Parent_Question_Id == parentId && x.Parent_Option_Id == null).ToList();

            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                var answer = allAnswers
                    .FirstOrDefault(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id && x.Mat_Option_Id == null);

                var question = new Question()
                {
                    QuestionId = myQ.Mat_Question_Id,
                    Sequence = myQ.Sequence,
                    MaturityLevel = myQ.Maturity_Level.Level,
                    MaturityLevelName = myQ.Maturity_Level.Level_Name,
                    DisplayNumber = myQ.Question_Title,
                    ParentQuestionId = myQ.Parent_Question_Id,
                    QuestionType = myQ.Mat_Question_Type,
                    Comment = answer?.Comment ?? "",
                    Options = GetOptions(myQ.Mat_Question_Id)
                };


                if (_includeText)
                {
                    question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                    question.SupplementalInfo = myQ.Supplemental_Info;
                    question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;

                    GetReferences(myQ.Mat_Question_Id, out List<ReferenceDocLink> s, out List<ReferenceDocLink> r);
                    question.SourceDocuments = s;
                    question.AdditionalDocuments = r;
                }

                qList.Add(question);

                var followups = GetFollowupQuestions(myQ.Mat_Question_Id);
                question.Followups.AddRange(followups);
            }

            return qList;
        }

        /// <summary>
        /// Build options for a question.
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        private List<Option> GetOptions(int questionId)
        {
            var opts = _context.MATURITY_ANSWER_OPTIONS.Where(x => x.Mat_Question_Id == questionId)
                .OrderBy(x => x.Answer_Sequence)
                .ToList();

            var list = new List<Option>();

            foreach (var o in opts)
            {
                var option = new Option()
                {
                    OptionText = o.Option_Text,
                    OptionId = o.Mat_Option_Id,
                    OptionType = o.Mat_Option_Type,
                    Sequence = o.Answer_Sequence
                };

                // Include questions that are a followup to the OPTION
                var myQuestions = allQuestions.Where(x => x.Parent_Option_Id == o.Mat_Option_Id).ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    var question = new Question()
                    {
                        QuestionId = myQ.Mat_Question_Id,
                        Sequence = myQ.Sequence,
                        MaturityLevel = myQ.Maturity_Level.Level,
                        MaturityLevelName = myQ.Maturity_Level.Level_Name,
                        DisplayNumber = myQ.Question_Title,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        ParentOptionId = myQ.Parent_Option_Id,
                        QuestionType = myQ.Mat_Question_Type,
                        Options = GetOptions(myQ.Mat_Question_Id)
                    };

                    if (_includeText)
                    {
                        question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                        question.SupplementalInfo = myQ.Supplemental_Info;
                        question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;

                        GetReferences(myQ.Mat_Question_Id, out List<ReferenceDocLink> s, out List<ReferenceDocLink> r);
                        question.SourceDocuments = s;
                        question.AdditionalDocuments = r;
                    }

                    option.Followups.Add(question);
                }

                list.Add(option);
            }

            return list;
        }


        private void GetReferences(int questionId, out List<ReferenceDocLink> sourceDocs,
                out List<ReferenceDocLink> additionalDocs)
        {
            var refBuilder = new Helpers.ReferencesBuilder(_context);
            refBuilder.BuildRefDocumentsForMaturityQuestion(questionId, out List<ReferenceDocLink> s,
                out List<ReferenceDocLink> r);

            sourceDocs = s;
            additionalDocs = r;
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
