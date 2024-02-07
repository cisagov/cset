//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Nested;
using CSETWebCore.Helpers;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Originally called CisStructure, it is in the process of being made 
    /// more generic to handle other "nested" modules like SD.
    /// </summary>
    public class NestedStructure
    {
        private readonly CSETContext _context;

        private int _assessmentId;
        private readonly int _maturityModelId;

        // query some data collections up front to avoid lots of database access

        private List<MATURITY_QUESTIONS> allQuestions;

        private List<ANSWER> allAnswers;

        private List<MATURITY_GROUPINGS> allGroupings;

        private int? _baselineAssessmentId;
        private List<ANSWER> baselineAllAnswers = new List<ANSWER>();



        private NestedQuestions _myModel = null;

        public NestedQuestions MyModel { get => _myModel; }


        private AdditionalSupplemental _addSup;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="sectionId"></param>
        /// <param name="context"></param>
        public NestedStructure(int assessmentId, int sectionId, CSETContext context)
        {
            this._context = context;
            this._assessmentId = assessmentId;

            this._addSup = new AdditionalSupplemental(context);


            // Get the baseline assessment if one is assigned
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (info != null)
            {
                this._baselineAssessmentId = info.Baseline_Assessment_Id;
            }


            var amm = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (amm != null)
            {
                this._maturityModelId = amm.model_id;
            }
            else
            {
                //throw new Exception("CisQuestionsBusiness cannot be instantiated for an assessment without a maturity model.");
            }

            if (sectionId == 0)
            {
                // sectionId of 0 is a special case where we want the entire structure
                LoadStructure(null);
            }
            else
            {
                LoadStructure(sectionId);
            }


            // include score
            var scoring = new CisScoring(this.MyModel);
            this.MyModel.GroupingScore = scoring.CalculateGroupingScore();

            // include baseline score, if a baseline assessment is selected
            this.MyModel.BaselineGroupingScore = null;

            if (info != null && info.Baseline_Assessment_Id != null)
            {
                var baselineScoring = new CisScoring((int)info.Baseline_Assessment_Id, sectionId, context);
                this.MyModel.BaselineGroupingScore = baselineScoring.CalculateGroupingScore();
            }
        }


        /// <summary>
        /// Gathers questions and answers and builds them into a basic hierarchy.
        /// </summary>
        private void LoadStructure(int? sectionId)
        {
            _myModel = new NestedQuestions
            {
                AssessmentId = this._assessmentId,
                ModelId = this._maturityModelId
            };

            allQuestions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                _maturityModelId == q.Maturity_Model_Id).ToList();

            allAnswers = _context.ANSWER
                .Where(a => a.Question_Type == Constants.Constants.QuestionTypeMaturity
                    && a.Assessment_Id == this._assessmentId)
                .ToList();

            // include baseline answers
            if (this._baselineAssessmentId != null)
            {
                baselineAllAnswers = _context.ANSWER
                .Where(a => a.Question_Type == Constants.Constants.QuestionTypeMaturity
                    && a.Assessment_Id == this._baselineAssessmentId)
                .ToList();
            }


            // Get all subgroupings for this maturity model
            allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _maturityModelId).ToList();

            GetSubgroups(MyModel, null, sectionId);
        }


        /// <summary>
        /// Recursive method for traversing the structure.
        /// If the filterId is specified, the subgroups are reduced to that one.
        /// </summary>
        private void GetSubgroups(object oParent, int? parentId, int? filterId = null)
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

                var grouping = new Grouping()
                {
                    GroupType = nodeName,
                    Abbreviation = sg.Abbreviation,
                    GroupingId = sg.Grouping_Id,
                    Prefix = sg.Title_Prefix,
                    Title = sg.Title,
                    Description = sg.Description
                };


                if (oParent is NestedQuestions)
                {
                    ((NestedQuestions)oParent).Groupings.Add(grouping);
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
                    List<ANSWER> answers = allAnswers.Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id).ToList();
                    ConsolidateAnswers(answers, out ANSWER answer);

                    var question = new Model.Nested.Question()
                    {
                        QuestionId = myQ.Mat_Question_Id,
                        QuestionText = myQ.Question_Text,
                        ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text,
                        Sequence = myQ.Sequence,
                        MaturityLevel = myQ.Maturity_Level.Level,
                        MaturityLevelName = myQ.Maturity_Level.Level_Name,
                        DisplayNumber = myQ.Question_Title,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        QuestionType = myQ.Mat_Question_Type,
                        AnswerText = answer?.Answer_Text,
                        AnswerMemo = answer?.Free_Response_Answer,
                        AltAnswerText = answer?.Alternate_Justification,
                        Options = GetOptions(myQ.Mat_Question_Id),
                        Followups = GetFollowupQuestions(myQ.Mat_Question_Id),
                        Comment = answer?.Comment,
                        Feedback = answer?.FeedBack,
                        MarkForReview = answer?.Mark_For_Review ?? false,
                        DocumentIds = GetDocumentIds(answer?.Answer_Id)
                    };

                    question.TTP = _addSup.GetTTPReferenceList(question.QuestionId);
                    question.CSF = _addSup.GetCsfMappings(question.QuestionId, "maturity");

                    if (answer != null)
                    {
                        question.HasObservation = _context.FINDING.Any(x => x.Answer_Id == answer.Answer_Id);
                    }


                    // Include the corresponding baseline selection if it exists
                    var baselineAnswer = baselineAllAnswers
                        .Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id)
                        .FirstOrDefault();
                    if (baselineAnswer != null)
                    {
                        question.BaselineAnswerText = baselineAnswer.Answer_Text;
                        question.BaselineAnswerMemo = baselineAnswer.Free_Response_Answer;
                    }


                    grouping.Questions.Add(question);
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
        private List<Model.Nested.Question> GetFollowupQuestions(int parentId)
        {
            var qList = new List<Model.Nested.Question>();

            var myQuestions = allQuestions.Where(x => x.Parent_Question_Id == parentId && x.Parent_Option_Id == null).ToList();

            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                List<ANSWER> answers = allAnswers.Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id).ToList();
                ConsolidateAnswers(answers, out ANSWER answer);

                var question = new Model.Nested.Question()
                {
                    QuestionId = myQ.Mat_Question_Id,
                    QuestionText = myQ.Question_Text,
                    ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text,
                    Sequence = myQ.Sequence,
                    MaturityLevel = myQ.Maturity_Level.Level,
                    MaturityLevelName = myQ.Maturity_Level.Level_Name,
                    DisplayNumber = myQ.Question_Title,
                    ParentQuestionId = myQ.Parent_Question_Id,
                    QuestionType = myQ.Mat_Question_Type,
                    AnswerText = answer?.Answer_Text,
                    AnswerMemo = answer?.Free_Response_Answer,
                    AltAnswerText = answer?.Alternate_Justification,
                    Options = GetOptions(myQ.Mat_Question_Id),
                    Followups = GetFollowupQuestions(myQ.Mat_Question_Id),
                    Comment = answer?.Comment,
                    Feedback = answer?.FeedBack,
                    MarkForReview = answer?.Mark_For_Review ?? false,
                    DocumentIds = GetDocumentIds(answer?.Answer_Id)
                };

                question.TTP = _addSup.GetTTPReferenceList(question.QuestionId);
                question.CSF = _addSup.GetCsfMappings(question.QuestionId, "maturity");

                if (answer != null)
                {
                    question.HasObservation = _context.FINDING.Any(x => x.Answer_Id == answer.Answer_Id);
                }


                // Include the corresponding baseline selection if it exists
                var baselineAnswer = baselineAllAnswers
                    .Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id)
                    .FirstOrDefault();
                if (baselineAnswer != null)
                {
                    question.BaselineAnswerText = baselineAnswer.Answer_Text;
                    question.BaselineAnswerMemo = baselineAnswer.Free_Response_Answer;
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
            var list = new List<Option>();

            var opts = _context.MATURITY_ANSWER_OPTIONS.Where(x => x.Mat_Question_Id == questionId)
                .OrderBy(x => x.Answer_Sequence)
                .ToList();

            foreach (var o in opts)
            {
                var option = new Option()
                {
                    OptionText = o.Option_Text,
                    OptionId = o.Mat_Option_Id,
                    OptionType = o.Mat_Option_Type,
                    Sequence = o.Answer_Sequence,
                    HasAnswerText = o.Has_Answer_Text,
                    Weight = o.Weight,
                    IsNone = o.Is_None,
                    ThreatType = o.ThreatType
                };

                var ans = allAnswers.Where(x => x.Question_Or_Requirement_Id == o.Mat_Question_Id
                    && x.Mat_Option_Id == option.OptionId).FirstOrDefault();

                option.AnswerId = ans?.Answer_Id;
                option.Selected = ans?.Answer_Text == "S";
                option.AnswerText = ans?.Free_Response_Answer;


                // Include the corresponding baseline selection if it exists
                var baselineAnswer = baselineAllAnswers
                    .Where(x => x.Question_Or_Requirement_Id == o.Mat_Question_Id && x.Mat_Option_Id == o.Mat_Option_Id)
                    .FirstOrDefault();
                if (baselineAnswer != null)
                {
                    option.BaselineSelected = baselineAnswer.Answer_Text == "S";
                    option.BaselineAnswerText = baselineAnswer.Free_Response_Answer;
                }


                // Include questions that are a followup to the OPTION
                var myQuestions = allQuestions.Where(x => x.Parent_Option_Id == o.Mat_Option_Id).ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    List<ANSWER> answers = allAnswers.Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id).ToList();
                    ConsolidateAnswers(answers, out ANSWER answer);

                    var question = new Model.Nested.Question()
                    {
                        QuestionId = myQ.Mat_Question_Id,
                        QuestionText = myQ.Question_Text,
                        ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text,
                        Sequence = myQ.Sequence,
                        MaturityLevel = myQ.Maturity_Level.Level,
                        MaturityLevelName = myQ.Maturity_Level.Level_Name,
                        DisplayNumber = myQ.Question_Title,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        ParentOptionId = myQ.Parent_Option_Id,
                        QuestionType = myQ.Mat_Question_Type,
                        AnswerText = answer?.Answer_Text,
                        AnswerMemo = answer?.Free_Response_Answer,
                        AltAnswerText = answer?.Alternate_Justification,
                        Options = GetOptions(myQ.Mat_Question_Id),
                        Followups = GetFollowupQuestions(myQ.Mat_Question_Id),
                        Comment = answer?.Comment,
                        Feedback = answer?.FeedBack,
                        MarkForReview = answer?.Mark_For_Review ?? false,
                        DocumentIds = GetDocumentIds(answer?.Answer_Id)
                    };

                    question.TTP = _addSup.GetTTPReferenceList(question.QuestionId);
                    question.CSF = _addSup.GetCsfMappings(question.QuestionId, "maturity");

                    if (answer != null)
                    {
                        question.HasObservation = _context.FINDING.Any(x => x.Answer_Id == answer.Answer_Id);
                    }


                    // Include the corresponding baseline selection if it exists
                    baselineAnswer = baselineAllAnswers
                        .Where(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id)
                        .FirstOrDefault();
                    if (baselineAnswer != null)
                    {
                        question.BaselineAnswerText = baselineAnswer.Answer_Text;
                        question.BaselineAnswerMemo = baselineAnswer.Free_Response_Answer;
                    }


                    option.Followups.Add(question);
                }

                list.Add(option);
            }

            return list;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private List<int> GetDocumentIds(int? answerId)
        {
            var list = new List<int>();

            if (answerId == null)
            {
                return list;
            }

            return _context.DOCUMENT_ANSWERS.Where(x => x.Answer_Id == answerId).ToList().Select(x => x.Document_Id).ToList();
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
                //if (a.Answer_Text == "S" || a.Answer_Text == "") 
                //{ 
                //    answer.Answer_Text = a.Answer_Text;
                //}

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
    }
}
