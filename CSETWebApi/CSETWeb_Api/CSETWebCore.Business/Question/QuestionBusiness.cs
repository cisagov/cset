//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Standards;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Hydro;
using CSETWebCore.Model.Question;
using Nelibur.ObjectMapper;
using Npoi.Mapper;
using NPOI.HPSF;
using NPOI.SS.UserModel;
using NPOI.Util;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace CSETWebCore.Business.Question
{
    public class QuestionBusiness : IQuestionBusiness
    {
        List<QuestionPlusHeaders> questions;

        List<FullAnswer> Answers;

        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _document;
        private readonly IHtmlFromXamlConverter _htmlConverter;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly CSETContext _context;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentId"></param>
        public QuestionBusiness(ITokenManager tokenManager, IDocumentBusiness document,
            IHtmlFromXamlConverter htmlConverter, IQuestionRequirementManager questionRequirement,
            IAssessmentUtil assessmentUtil, CSETContext context)
        {
            _tokenManager = tokenManager;
            _document = document;
            _htmlConverter = htmlConverter;
            _questionRequirement = questionRequirement;
            _assessmentUtil = assessmentUtil;
            _context = context;
        }

        public void SetQuestionAssessmentId(int assessmentId)
        {
            _questionRequirement.InitializeManager(assessmentId);
        }


        /// <summary>
        /// Returns a list of Questions.
        /// We can find questions for a single group or for all groups (*).
        /// </summary>        
        public QuestionResponse GetQuestionListWithSet(string questionGroupName)
        {
            IQueryable<QuestionPlusHeaders> query = null;

            string assessSalLevel = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == _questionRequirement.AssessmentId).Select(c => c.Selected_Sal_Level).FirstOrDefault();
            string assessSalLevelUniversal = _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == assessSalLevel).Select(x => x.Universal_Sal_Level1).First();

            if (_questionRequirement.SetNames.Count == 1)
            {
                // If a single standard is selected, do it this way
                query = (from q in _context.NEW_QUESTION
                         from qs in _context.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                         from l in _context.NEW_QUESTION_LEVELS.Where(x => qs.New_Question_Set_Id == x.New_Question_Set_Id)
                         from s in _context.SETS.Where(x => x.Set_Name == qs.Set_Name && x.Set_Name == qs.Set_Name)
                         from usl in _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == assessSalLevel)
                         from usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == q.Heading_Pair_Id)
                         from qgh in _context.QUESTION_GROUP_HEADING.Where(x => x.Question_Group_Heading_Id == usch.Question_Group_Heading_Id)
                         from usc in _context.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == usch.Universal_Sub_Category_Id)
                         where _questionRequirement.SetNames.Contains(s.Set_Name)
                            && l.Universal_Sal_Level == usl.Universal_Sal_Level1

                         select new QuestionPlusHeaders()
                         {
                             QuestionId = q.Question_Id,
                             SimpleQuestion = q.Simple_Question,
                             QuestionGroupHeadingId = qgh.Question_Group_Heading_Id,
                             QuestionGroupHeading = qgh.Question_Group_Heading1,
                             UniversalSubCategoryId = usc.Universal_Sub_Category_Id,
                             UniversalSubCategory = usc.Universal_Sub_Category,
                             SubHeadingQuestionText = usch.Sub_Heading_Question_Description,
                             PairingId = usch.Heading_Pair_Id,
                             SetName = s.Short_Name,
                             ShortSetName = s.Short_Name
                         });

                // Get the questions for the specified group (or all groups)  
                if (!string.IsNullOrEmpty(questionGroupName) && questionGroupName != "*")
                {
                    query = query.Where(x => x.QuestionGroupHeading == questionGroupName);
                }
            }
            else
            {
                query = (from q in _context.NEW_QUESTION
                         join qs in _context.NEW_QUESTION_SETS on q.Question_Id equals qs.Question_Id
                         join nql in _context.NEW_QUESTION_LEVELS on qs.New_Question_Set_Id equals nql.New_Question_Set_Id
                         join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                         join stand in _context.AVAILABLE_STANDARDS on qs.Set_Name equals stand.Set_Name
                         join s in _context.SETS on stand.Set_Name equals s.Set_Name
                         join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                         join usc in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
                         where stand.Selected == true && stand.Assessment_Id == _questionRequirement.AssessmentId
                         select new QuestionPlusHeaders()
                         {
                             QuestionId = q.Question_Id,
                             SimpleQuestion = q.Simple_Question,
                             QuestionGroupHeadingId = qgh.Question_Group_Heading_Id,
                             QuestionGroupHeading = qgh.Question_Group_Heading1,
                             UniversalSubCategoryId = usc.Universal_Sub_Category_Id,
                             UniversalSubCategory = usc.Universal_Sub_Category,
                             SubHeadingQuestionText = usch.Sub_Heading_Question_Description,
                             PairingId = usch.Heading_Pair_Id,
                             SetName = s.Short_Name,
                             ShortSetName = stand.Set_Name
                         });
            }

            // Get all answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _questionRequirement.AssessmentId && x.Question_Type == "Question")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          from c in _context.FINDING.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b, ObservationsExist = c != null };

            this.questions = query.Distinct().ToList();
            this.Answers = answers.ToList();

            // Merge the questions and answers into a hierarchy
            return BuildResponse();

        }

        /// <summary>
        /// Returns a list of Questions.
        /// We can find questions for a single group or for all groups (*).
        /// </summary>        
        public QuestionResponse GetQuestionList(string questionGroupName)
        {
            _questionRequirement.InitializeManager(_tokenManager.AssessmentForUser());

            IQueryable<QuestionPlusHeaders> query = null;

            string assessSalLevel = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == _questionRequirement.AssessmentId).Select(c => c.Selected_Sal_Level).FirstOrDefault();
            string assessSalLevelUniversal = _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == assessSalLevel).Select(x => x.Universal_Sal_Level1).First();

            if (_questionRequirement.SetNames.Count == 1)
            {
                // If a single standard is selected, do it this way
                query = (from q in _context.NEW_QUESTION
                         from qs in _context.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                         from l in _context.NEW_QUESTION_LEVELS.Where(x => qs.New_Question_Set_Id == x.New_Question_Set_Id)
                         from s in _context.SETS.Where(x => x.Set_Name == qs.Set_Name && x.Set_Name == qs.Set_Name)
                         from usl in _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == assessSalLevel)
                         from usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == q.Heading_Pair_Id)
                         from qgh in _context.QUESTION_GROUP_HEADING.Where(x => x.Question_Group_Heading_Id == usch.Question_Group_Heading_Id)
                         from usc in _context.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == usch.Universal_Sub_Category_Id)
                         where _questionRequirement.SetNames.Contains(s.Set_Name)
                            && l.Universal_Sal_Level == usl.Universal_Sal_Level1

                         select new QuestionPlusHeaders()
                         {
                             QuestionId = q.Question_Id,
                             SimpleQuestion = q.Simple_Question,
                             QuestionGroupHeadingId = qgh.Question_Group_Heading_Id,
                             QuestionGroupHeading = qgh.Question_Group_Heading1,
                             UniversalSubCategoryId = usc.Universal_Sub_Category_Id,
                             UniversalSubCategory = usc.Universal_Sub_Category,
                             SubHeadingQuestionText = usch.Sub_Heading_Question_Description,
                             PairingId = usch.Heading_Pair_Id
                         });

                // Get the questions for the specified group (or all groups)  
                if (!string.IsNullOrEmpty(questionGroupName) && questionGroupName != "*")
                {
                    query = query.Where(x => x.QuestionGroupHeading == questionGroupName);
                }
            }
            else
            {
                query = (from q in _context.NEW_QUESTION
                         join qs in _context.NEW_QUESTION_SETS on q.Question_Id equals qs.Question_Id
                         join nql in _context.NEW_QUESTION_LEVELS on qs.New_Question_Set_Id equals nql.New_Question_Set_Id
                         join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                         join stand in _context.AVAILABLE_STANDARDS on qs.Set_Name equals stand.Set_Name
                         join s in _context.SETS on stand.Set_Name equals s.Set_Name
                         join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                         join usc in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
                         where stand.Selected == true && stand.Assessment_Id == _questionRequirement.AssessmentId
                         select new QuestionPlusHeaders()
                         {
                             QuestionId = q.Question_Id,
                             SimpleQuestion = q.Simple_Question,
                             QuestionGroupHeadingId = qgh.Question_Group_Heading_Id,
                             QuestionGroupHeading = qgh.Question_Group_Heading1,
                             UniversalSubCategoryId = usc.Universal_Sub_Category_Id,
                             UniversalSubCategory = usc.Universal_Sub_Category,
                             SubHeadingQuestionText = usch.Sub_Heading_Question_Description,
                             PairingId = usch.Heading_Pair_Id
                         });
            }

            // Get all answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _questionRequirement.AssessmentId && x.Question_Type == "Question")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          from c in _context.FINDING.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b, ObservationsExist = c != null };

            this.questions = query.Distinct().ToList();
            this.Answers = answers.ToList();

            // Merge the questions and answers into a hierarchy
            return BuildResponse();
        }

        /// <summary>
        /// Map Questions and answers to view
        /// </summary>
        /// <param name="questionResponse"></param>
        /// <returns></returns>
        public List<AnalyticsQuestionAnswer> GetAnalyticQuestionAnswers(QuestionResponse questionResponse)
        {
            List<AnalyticsQuestionAnswer> analyticQuestionAnswers = new List<AnalyticsQuestionAnswer>();
            foreach (var questionGroup in questionResponse.Categories)
            {
                foreach (var subCategory in questionGroup.SubCategories)
                {
                    foreach (var question in subCategory.Questions)
                    {

                        analyticQuestionAnswers.Add(new AnalyticsQuestionAnswer
                        {
                            QuestionId = question.QuestionId,
                            QuestionText = question.QuestionText,
                            AnswerText = question.Answer,
                            CategoryId = questionGroup.GroupHeadingId,
                            CategoryText = questionGroup.GroupHeadingText,
                            SubCategoryId = (int)subCategory.SubCategoryId,
                            SubCategoryText = subCategory.SubCategoryHeadingText,
                            SetName = questionGroup.SetName,
                            IsRequirement = question.Is_Requirement,
                            IsComponent = question.Is_Component
                        });
                    }
                }
            }
            return analyticQuestionAnswers;
        }


        /// <summary>
        /// Returns a list of answer IDs that are currently 'active' on the
        /// Assessment, given its SAL level and selected Standards.
        /// 
        /// This piggy-backs on GetQuestionList() so that we don't need to support
        /// multiple copies of the question and answer queries.
        /// </summary>
        /// <returns></returns>
        public List<int> GetActiveAnswerIds()
        {
            QuestionResponse resp = this.GetQuestionList(null);

            List<int> relevantAnswerIds = this.Answers.Where(ans =>
                this.questions.Select(q => q.QuestionId).Contains(ans.a.Question_Or_Requirement_Id))
                .Select(x => x.a.Answer_Id)
                .ToList<int>();

            return relevantAnswerIds;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionId"></param>
        /// <param name="assessmentid"></param>
        /// <returns></returns>
        public QuestionDetails GetDetails(int questionId, string questionType)
        {
            var qvm = new QuestionDetailsBusiness(
                new StandardSpecficLevelRepository(_context),
                new InformationTabBuilder(_context, _htmlConverter, _tokenManager),
                _context, _tokenManager, _document
            );

            _questionRequirement.InitializeManager(_tokenManager.AssessmentForUser());
            return qvm.GetQuestionDetails(questionId, _questionRequirement.AssessmentId, questionType);
        }


        /// <summary>
        /// Constructs a response containing the applicable questions with their answers.
        /// </summary>
        /// <returns></returns>
        public QuestionResponse BuildResponse()
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            int curGroupId = 0;
            int curPairingId = 0;


            int displayNumber = 0;

            foreach (var dbQ in this.questions.OrderBy(x => x.QuestionGroupHeading)
                .ThenBy(x => x.UniversalSubCategory)
                .ThenBy(x => x.QuestionId))
            {
                if (dbQ.QuestionGroupHeadingId != curGroupId)
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingId = dbQ.QuestionGroupHeadingId,
                        GroupHeadingText = dbQ.QuestionGroupHeading,
                        StandardShortName = "Standard Questions",
                        SetName = dbQ.SetName

                    };

                    groupList.Add(qg);

                    curGroupId = qg.GroupHeadingId;
                    curPairingId = 0;

                    // start numbering again in new group
                    displayNumber = 0;
                }




                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if (dbQ.PairingId != curPairingId)
                {
                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = qg.GroupHeadingId,
                        SubCategoryId = dbQ.UniversalSubCategoryId,
                        SubCategoryHeadingText = dbQ.UniversalSubCategory,
                        HeaderQuestionText = dbQ.SubHeadingQuestionText,
                        SubCategoryAnswer = _questionRequirement.SubCatAnswers.Where(sca => sca.GroupHeadingId == qg.GroupHeadingId
                                                && sca.SubCategoryId == dbQ.UniversalSubCategoryId)
                                                .FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);

                    curPairingId = dbQ.PairingId;
                }

                FullAnswer answer = this.Answers.Where(x => x.a.Question_Or_Requirement_Id == dbQ.QuestionId).FirstOrDefault();

                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.QuestionId,
                    QuestionType = dbQ.QuestionType,
                    QuestionText = dbQ.SimpleQuestion,
                    Answer = answer?.a?.Answer_Text,
                    Answer_Id = answer?.a?.Answer_Id,
                    AltAnswerText = answer?.a?.Alternate_Justification,
                    Comment = answer?.a?.Comment,
                    Feedback = answer?.a?.FeedBack,
                    MarkForReview = answer?.a.Mark_For_Review ?? false,
                    Reviewed = answer?.a.Reviewed ?? false,
                    Is_Component = answer?.a.Is_Component ?? false,
                    ComponentGuid = answer?.a.Component_Guid ?? Guid.Empty,
                    Is_Requirement = answer?.a.Is_Requirement ?? false
                };

                if (string.IsNullOrEmpty(qa.QuestionType))
                {
                    qa.QuestionType = _questionRequirement.DetermineQuestionType(qa.Is_Requirement, qa.Is_Component, false, qa.Is_Maturity);
                }

                if (answer != null)
                {
                    TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                    TinyMapper.Map(answer.b, qa);

                    // db view still uses the term "HasDiscovery" - map to "HasObservation"
                    qa.HasObservation = answer.b.HasDiscovery ?? false;
                }

                sc.Questions.Add(qa);
            }

            QuestionResponse response = new QuestionResponse
            {
                Categories = groupList,
                ApplicationMode = _questionRequirement.ApplicationMode,
                OnlyMode = _context.STANDARD_SELECTION.First(x => x.Assessment_Id == _questionRequirement.AssessmentId).Only_Mode
            };

            response.QuestionCount = _questionRequirement.NumberOfQuestions();
            response.RequirementCount = _questionRequirement.NumberOfRequirements();

            return response;
        }


        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(Answer answer)
        {
            // Find the Question or Requirement
            var question = _context.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();
            var requirement = _context.NEW_REQUIREMENT.Where(r => r.Requirement_Id == answer.QuestionId).FirstOrDefault();

            if (question == null && requirement == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            int assessmentId = _tokenManager.AssessmentForUser();

            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }
            string questionType = "Question";

            ANSWER dbAnswer = null;
            if (answer != null && answer.ComponentGuid != Guid.Empty)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Question_Type == answer.QuestionType && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }
            else if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();
            }

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType ?? questionType;
            int tQuestionNumber = 0;
            if (int.TryParse(answer.QuestionNumber, out tQuestionNumber))
            {
                dbAnswer.Question_Number = int.Parse(answer.QuestionNumber);
            }
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;


            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(assessmentId);

            return dbAnswer.Answer_Id;
        }


        /// <summary>
        /// Persists a single answer to the SUB_CATEGORY_ANSWERS table for the 'block answer',
        /// and flips all of the constituent questions' answers.
        /// </summary>
        public void StoreSubcategoryAnswers(SubCategoryAnswers subCatAnswerBlock)
        {
            if (subCatAnswerBlock == null)
            {
                return;
            }

            // SUB_CATEGORY_ANSWERS

            // Get the USCH so that we will know the Heading_Pair_Id
            var usch = _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.FirstOrDefault(u => u.Question_Group_Heading_Id == subCatAnswerBlock.GroupHeadingId
                                                                           && u.Universal_Sub_Category_Id == subCatAnswerBlock.SubCategoryId);

            var subCatAnswer = _context.SUB_CATEGORY_ANSWERS.FirstOrDefault(sca => sca.Assessment_Id == _questionRequirement.AssessmentId
                                                                          && sca.Heading_Pair_Id == usch.Heading_Pair_Id);

            if (subCatAnswer == null)
            {
                subCatAnswer = new SUB_CATEGORY_ANSWERS();
                subCatAnswer.Assessment_Id = _questionRequirement.AssessmentId;
                subCatAnswer.Heading_Pair_Id = usch.Heading_Pair_Id;
                subCatAnswer.Answer_Text = subCatAnswerBlock.SubCategoryAnswer;
                subCatAnswer.Component_Guid = new Guid().ToString();
                _context.SUB_CATEGORY_ANSWERS.Add(subCatAnswer);
            }
            else
            {
                subCatAnswer.Assessment_Id = _questionRequirement.AssessmentId;
                subCatAnswer.Heading_Pair_Id = usch.Heading_Pair_Id;
                subCatAnswer.Answer_Text = subCatAnswerBlock.SubCategoryAnswer;
                _context.SUB_CATEGORY_ANSWERS.Update(subCatAnswer);
            }

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_questionRequirement.AssessmentId);

            // loop and store all of the subcategory's answers
            foreach (Answer ans in subCatAnswerBlock.Answers)
            {

                if (String.IsNullOrWhiteSpace(ans.QuestionType))
                {
                    ans.QuestionType = _questionRequirement.DetermineQuestionType(ans.Is_Requirement, ans.Is_Component, false, ans.Is_Maturity);
                }
                _questionRequirement.StoreAnswer(ans);
            }
        }


        public int QuestionCountInSubGroup(string subGroup, int modelId)
        {
            return _context.MATURITY_QUESTIONS.Where(x => x.Sub_Category == subGroup && x.Maturity_Model_Id == modelId).Count();
        }

        public List<HydroGroupingInfo> AllQuestionsInSubGroup(int modelId, int groupLevel, int assessmentId)
        {
            List<int> groupingIdList = _context.MATURITY_GROUPINGS.Where(g => g.Maturity_Model_Id == modelId && g.Group_Level == groupLevel).Select(x => x.Grouping_Id).ToList();
            List<int> parentGroupingIdList = _context.MATURITY_GROUPINGS.Where(g => g.Maturity_Model_Id == modelId && g.Group_Level == groupLevel).Select(x => (int)x.Parent_Id).ToList();
            List<int> distinctParentGroupingIdList = parentGroupingIdList.Distinct().ToList();

            var ansResults = from q in _context.MATURITY_QUESTIONS.Where(g => g.Maturity_Model_Id == modelId && groupingIdList.Contains((int)g.Grouping_Id))
                             join a in _context.ANSWER on q.Mat_Question_Id equals a.Question_Or_Requirement_Id
                             where a.Assessment_Id == assessmentId
                             select new { a };

            List<MATURITY_QUESTIONS> questionList = _context.MATURITY_QUESTIONS.Where(g => g.Maturity_Model_Id == modelId && groupingIdList.Contains((int)g.Grouping_Id)).ToList();

            List<HydroGroupingInfo> info = new List<HydroGroupingInfo>();

            for (int i = 0; i < groupingIdList.Count; i++)
            {
                List<MATURITY_QUESTIONS> questionsInGroup = questionList.FindAll(q => q.Grouping_Id == groupingIdList[i]);

                List<QuestionWithAnswers> questionWithAnswers = new List<QuestionWithAnswers>();

                foreach (MATURITY_QUESTIONS question in questionsInGroup)
                {
                    QuestionWithAnswers questionAnswers = new QuestionWithAnswers();
                    List<ANSWER> answerListPerQuestion = _context.ANSWER.Where(a => a.Question_Or_Requirement_Id == question.Mat_Question_Id && a.Answer_Text == "S" && a.Assessment_Id == assessmentId).ToList();
                    List<MATURITY_ANSWER_OPTIONS> answerOptions = _context.MATURITY_ANSWER_OPTIONS.Where(o => o.Mat_Question_Id == question.Mat_Question_Id).ToList();

                    questionAnswers.Question = question;
                    questionAnswers.Question.MATURITY_ANSWER_OPTIONS = answerOptions;
                    questionAnswers.Answers = answerListPerQuestion;

                    questionWithAnswers.Add(questionAnswers);
                }

                int totalSubGroupingsInParent = _context.MATURITY_GROUPINGS.Where(g => g.Parent_Id == parentGroupingIdList[i]).Count();

                info.Add(new HydroGroupingInfo()
                {
                    TotalSubGroupings = totalSubGroupingsInParent,
                    ParentGroupingId = parentGroupingIdList[i],
                    GroupingId = groupingIdList[i],
                    QuestionsWithAnswers = questionWithAnswers
                });
            }

            return info;
        }


        public int SaveHydroComment(ANSWER answer, int answerId, int progressId, string comment)
        {

            try
            {
                _context.HYDRO_DATA_ACTIONS.Update(new HYDRO_DATA_ACTIONS()
                {
                    Answer = answer,
                    Answer_Id = answerId,
                    Progress_Id = progressId,
                    Comment = comment
                });
            }
            catch (Exception)
            {
                //TODO: It is a big pet peeve of mine to have empty try catches
                //Please atleast log the error.  
                //if it is something you expect to see often and you know it is not an error
                //then exception tossing and catching is really expensive please refactor 
                //such that it is not necessary such as test for containment before adding.

                HYDRO_DATA_ACTIONS hda = new HYDRO_DATA_ACTIONS()
                {
                    Answer = answer,
                    Answer_Id = answerId,
                    Progress_Id = progressId,
                    Comment = comment
                };
                _context.HYDRO_DATA_ACTIONS.Add(hda);
            }

            _context.SaveChanges();

            return answerId;
        }
    }
}