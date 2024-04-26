//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using Nelibur.ObjectMapper;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using Snickler.EFCore;

namespace CSETWebCore.Business.Question
{
    public class QuestionRequirementManager : IQuestionRequirementManager
    {
        private List<SubCategoryAnswersPlus> _subCatAnswers;
        private int _assessmentID;
        protected string _standardLevel;
        private List<string> _setNames;
        private string _applicationMode;

        public List<SubCategoryAnswersPlus> SubCatAnswers
        {
            get { return _subCatAnswers; }
            set { _subCatAnswers = value; }
        }

        public int AssessmentId
        {
            get { return _assessmentID; }
            set { _assessmentID = value; }
        }

        public string StandardLevel
        {
            get { return _standardLevel; }
            set { _standardLevel = value; }
        }
        public List<string> SetNames
        {
            get { return _setNames; }
            set { _setNames = value; }
        }

        public string ApplicationMode
        {
            get { return _applicationMode; }
            set { _applicationMode = value; }
        }

        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAssessmentModeData _assessmentMode;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="assessmentId"></param>
        public QuestionRequirementManager(CSETContext context, IAssessmentUtil assessmentUtil,
            IAssessmentModeData assessmentMode)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _assessmentMode = assessmentMode;
        }

        public void InitializeManager(int assessmentId)
        {
            AssessmentId = assessmentId;
            InitializeApplicationMode();
            InitializeSalLevel();
            InitializeStandardsForAssessment();
            InitializeSubCategoryAnswers();
        }

        public void InitializeSubCategoryAnswers()
        {
            // Get any subcategory answers for the assessment
            SubCatAnswers = (from sca in _context.SUB_CATEGORY_ANSWERS
                             join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on sca.Heading_Pair_Id equals usch.Heading_Pair_Id
                             where sca.Assessment_Id == AssessmentId
                             select new SubCategoryAnswersPlus()
                             {
                                 AssessmentId = sca.Assessment_Id,
                                 HeadingId = sca.Heading_Pair_Id,
                                 AnswerText = sca.Answer_Text,
                                 GroupHeadingId = usch.Question_Group_Heading_Id,
                                 SubCategoryId = usch.Universal_Sub_Category_Id
                             }).ToList();
        }


        /// <summary>
        /// Determines whether the assessment is questions based or requirements based.
        /// Sets a Q or R that is returned to the client.
        /// </summary>
        /// <returns></returns>
        public void InitializeApplicationMode()
        {
            ApplicationMode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == AssessmentId)
                .Select(x => x.Application_Mode).FirstOrDefault();

            // Default to 'questions mode' if not already set
            if (ApplicationMode == null)
            {
                ApplicationMode = "Q";
                SetApplicationMode(ApplicationMode);
            }
            else if (ApplicationMode.ToLower().StartsWith("questions"))
            {
                ApplicationMode = "Q";
            }
            else if (ApplicationMode.ToLower().StartsWith("requirements"))
            {
                ApplicationMode = "R";
            }
        }


        /// <summary>
        /// Determines the assessment's SAL standard level (letter code)
        /// </summary>
        /// <returns></returns>
        public void InitializeSalLevel()
        {

            var querySalLevel = from usl in _context.UNIVERSAL_SAL_LEVEL
                                from ss in _context.STANDARD_SELECTION
                                    .Where(s => s.Assessment_Id == AssessmentId && s.Selected_Sal_Level == usl.Full_Name_Sal)
                                select usl.Universal_Sal_Level1;
            _standardLevel = querySalLevel.ToList().FirstOrDefault();

        }


        /// <summary>
        /// Creates a list of standards selected for the assessment.
        /// </summary>
        /// <returns></returns>
        public void InitializeStandardsForAssessment()
        {
            List<string> result = new List<string>();
            var sets = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == AssessmentId && x.Selected)
                .Select(x => x.Set_Name);
            _setNames = sets.ToList();
        }


        /// <summary>
        /// Stores the requested application mode in the STANDARD_SELECTION table.
        /// </summary>
        /// <param name="mode"></param>
        public void SetApplicationMode(string mode)
        {
            var standardSelection = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == AssessmentId).FirstOrDefault();
            if (standardSelection != null)
            {
                string targetString = "Requirements Based";
                //var targetString = (mode == "Q") ? "Questions Based" : ((mode == "R") ? "Requirements Based" : 
                //    ((mode == "P") ? "Principle Scope" : ((mode == "Principle-Phase Scope"));
                switch (mode) 
                {
                    case "Q":
                        targetString = "Questions Based";
                        break;
                    case "P":
                        targetString = "Principle Scope";
                        break;
                    case "F":
                        targetString = "Principle-Phase Scope";
                        break;
                    default:
                        targetString = "Requirements Based";
                        break;
                }

                if (standardSelection.Application_Mode != targetString)
                {
                    standardSelection.Application_Mode = targetString;
                    _context.STANDARD_SELECTION.Update(standardSelection);
                    _context.SaveChanges();

                    _assessmentUtil.TouchAssessment(AssessmentId);
                }
            }
        }

        /// <summary>
        /// Determines if the assessment is question or requirements based.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public string GetApplicationMode(int assessmentId)
        {

            var mode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Application_Mode).FirstOrDefault();

            if (mode == null)
            {
                mode = _assessmentMode.DetermineDefaultApplicationModeAbbrev();
                SetApplicationMode(mode);
            }

            return mode;
        }

        public int StoreComponentAnswer(Answer answer)
        {
            var question = _context.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();

            if (question == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            ANSWER dbAnswer = null;
            if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Is_Requirement == false && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = AssessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Number = int.Parse(answer.QuestionNumber);
            dbAnswer.Is_Requirement = false;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;
            dbAnswer.Is_Component = true;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(AssessmentId);

            return dbAnswer.Answer_Id;
        }

        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(Answer answer)
        {
            // Verify the Question exists
            if (
                (answer.QuestionType == "Question" && !_context.NEW_QUESTION.Any(q => q.Question_Id == answer.QuestionId))
                || (answer.QuestionType == "Requirement" && !_context.NEW_REQUIREMENT.Any(r => r.Requirement_Id == answer.QuestionId))
                || (answer.QuestionType == "Component" && !_context.COMPONENT_QUESTIONS.Any(c => c.Question_Id == answer.QuestionId))
                || (answer.QuestionType == "Maturity" && !_context.MATURITY_QUESTIONS.Any(m => m.Mat_Question_Id == answer.QuestionId))
                )
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            var types = new List<string> { "Question", "Requirement", "Component", "Maturity" };
            if (!types.Contains(answer.QuestionType))
            {
                throw new Exception("Unknown question type:" + answer.QuestionType);
            }



            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }


            ANSWER dbAnswer = null;
            if (answer != null && answer.ComponentGuid != Guid.Empty)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Question_Type == answer.QuestionType && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }
            else if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();
            }

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = AssessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType;

            dbAnswer.Question_Number = answer.QuestionNumber != null ? int.Parse(answer.QuestionNumber) : (int?)null;
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
            _assessmentUtil.TouchAssessment(AssessmentId);

            return dbAnswer.Answer_Id;
        }


        /// <summary>
        /// Not my favorite but passing in the 
        /// response adding the components to it
        /// and then returning
        /// </summary>
        /// <param name="resp"></param>        
        public void BuildComponentsResponse(QuestionResponse resp)
        {
            var answerComponents = _context.usp_Answer_Components_Default(this.AssessmentId);
            var list = answerComponents.Select(component => TinyMapper.Map<Answer_Components_Base>(component)).ToList();
            //.Where(x => x.Assessment_Id == this.assessmentID).Cast<Answer_Components_Base>()
            //.OrderBy(x => x.Question_Group_Heading).ThenBy(x => x.Universal_Sub_Category).ToList();

            AddResponse(resp, list, "Component Defaults");
            BuildOverridesOnly(resp);

        }

        public void BuildOverridesOnly(QuestionResponse resp)
        {
            // Because these are only override questions and the lists are short, don't bother grouping by group header.  Just subcategory.
            List<Answer_Components_Base> dlist = null;
            _context.LoadStoredProc("[usp_getAnswerComponentOverrides]")
              .WithSqlParam("assessment_id", this.AssessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  dlist = handler.ReadToList<Answer_Components_Base>()
                    .OrderBy(x => x.Symbol_Name).ThenBy(x => x.ComponentName).ThenBy(x => x.Component_Guid)
                    .ThenBy(x => x.Universal_Sub_Category)
                    .ToList();
              });

            AddResponseComponentOverride(resp, dlist, "Component Overrides");
        }

        public void AddResponseComponentOverride(QuestionResponse resp, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string symbolType = null;
            string componentName = null;
            string curGroupHeading = null;
            string curSubHeading = null;
            int prevQuestionId = 0;
            QuestionSubCategoryComparator comparator = new QuestionSubCategoryComparator();

            int displayNumber = 0;

            //push a new group if component_type, component_name, or question_group_heading changes

            foreach (var dbQ in list)
            {
                if ((dbQ.Symbol_Name != symbolType)
                    || (dbQ.ComponentName != componentName))
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = dbQ.ComponentName,
                        IsOverride = true

                    };
                    groupList.Add(qg);
                    symbolType = dbQ.Symbol_Name;
                    componentName = dbQ.ComponentName;

                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if ((dbQ.Universal_Sub_Category != curSubHeading) || (dbQ.Question_Id == prevQuestionId))
                {
                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description,
                        SubCategoryAnswer = this.SubCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);
                    curSubHeading = dbQ.Universal_Sub_Category;
                }
                prevQuestionId = dbQ.Question_Id;
                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = dbQ.Simple_Question,
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    FreeResponseAnswer = dbQ.Free_Response_Answer,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.FeedBack
                };

                sc.Questions.Add(qa);
            }


            resp.Categories.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }



        public void AddResponse(QuestionResponse resp, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string curGroupHeading = null;
            int curHeadingPairId = 0;


            int displayNumber = 0;


            foreach (var dbQ in list)
            {
                if (dbQ.Question_Group_Heading != curGroupHeading)
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = dbQ.ComponentName
                    };
                    groupList.Add(qg);
                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if (dbQ.heading_pair_id != curHeadingPairId)
                {
                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description,
                        SubCategoryAnswer = this.SubCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);

                    curHeadingPairId = dbQ.heading_pair_id;
                }

                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = dbQ.Simple_Question,
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    FreeResponseAnswer = dbQ.Free_Response_Answer,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.FeedBack
                };

                sc.Questions.Add(qa);
            }

            resp.Categories.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// Returns a string indicating the question type based on the booleans.
        /// </summary>
        /// <param name="is_requirement"></param>
        /// <param name="is_component"></param>
        /// <param name="is_framework"></param>
        /// <param name="is_maturity"></param>
        /// <returns></returns>
        public string DetermineQuestionType(bool is_requirement, bool is_component, bool is_framework, bool is_maturity)
        {
            if (is_requirement)
            {
                return "Requirement";
            }
            if (is_component)
            {
                return "Component";
            }
            if (is_framework)
            {
                return "Framework";
            }
            if (is_maturity)
            {
                return "Maturity";
            }
            return "Question";
        }


        /// <summary>
        /// Returns the number of questions that are relevant for the selected standards 
        /// when in REQUIREMENTS mode.        
        /// </summary>
        /// <returns></returns>
        public int NumberOfRequirements()
        {
            InitializeManager(_assessmentID);

            var q = from rs in _context.REQUIREMENT_SETS
                    from r in _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                    from rl in _context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == r.Requirement_Id)
                    where SetNames.Contains(rs.Set_Name)
                          && rl.Standard_Level == StandardLevel
                    select new { r, rs };

            return q.Distinct().Count();
        }


        /// <summary>
        /// Returns the number of questions that are relevant for the selected standards 
        /// when in QUESTIONS mode.
        /// 
        /// The query differs whether a single or multiple standards are selected.
        /// 
        /// </summary>
        /// <returns></returns>
        public int NumberOfQuestions()
        {
            InitializeManager(_assessmentID);

            string selectedSalLevel = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == AssessmentId).Select(c => c.Selected_Sal_Level).FirstOrDefault();

            if (SetNames.Count == 1)
            {
                // If a single standard is selected, do it this way
                var query1 = from q in _context.NEW_QUESTION
                             from qs in _context.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                             from l in _context.NEW_QUESTION_LEVELS.Where(x => qs.New_Question_Set_Id == x.New_Question_Set_Id)
                             from s in _context.SETS.Where(x => x.Set_Name == qs.Set_Name)
                             from usl in _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == selectedSalLevel)
                             where SetNames.Contains(s.Set_Name)
                                && l.Universal_Sal_Level == usl.Universal_Sal_Level1
                             select q.Question_Id;

                return query1.Distinct().Count();
            }
            else
            {
                var query2 = from q in _context.NEW_QUESTION
                             join qs in _context.NEW_QUESTION_SETS on q.Question_Id equals qs.Question_Id
                             join nql in _context.NEW_QUESTION_LEVELS on qs.New_Question_Set_Id equals nql.New_Question_Set_Id
                             join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                             join stand in _context.AVAILABLE_STANDARDS on qs.Set_Name equals stand.Set_Name
                             join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                             join usc in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
                             join usl in _context.UNIVERSAL_SAL_LEVEL on selectedSalLevel equals usl.Full_Name_Sal
                             where stand.Selected == true
                                && stand.Assessment_Id == AssessmentId
                                && nql.Universal_Sal_Level == usl.Universal_Sal_Level1
                             select q.Question_Id;

                return query2.Distinct().Count();
            }
        }
    }

    class QuestionSubCategoryComparator : IComparer<QuestionSubCategory>
    {
        public int Compare(QuestionSubCategory x, QuestionSubCategory y)
        {
            if (x.SubCategoryHeadingText == y.SubCategoryHeadingText)
            {
                return 0;
            }

            // CompareTo() method 
            return x.SubCategoryHeadingText.CompareTo(y.SubCategoryHeadingText);

        }
    }
}