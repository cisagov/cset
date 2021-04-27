using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;

namespace CSETWebCore.Business.Question
{
    public abstract class QuestionRequirementManager : IQuestionRequirementManager
    {
        private readonly IAssessmentUtil _assessmentUtil;
        private CSET_Context _context;

        private List<SubCategoryAnswersPlus> _subCatAnswers;

        private int _assessmentID; 
        private string _standardLevel;
        private List<string> _setNames = null;
        private string _applicationMode = "";

        public List<SubCategoryAnswersPlus> SubCatAnswers
        {
            get { return _subCatAnswers; }
            set { _subCatAnswers = value; }
        }

        public int AssessmentID
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
            get
            {
                return _applicationMode;
            }
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="assessmentId"></param>
        public QuestionRequirementManager(IAssessmentUtil assessmentUtil, CSET_Context context)
        {
            _assessmentUtil = assessmentUtil;
            _context = context;
        }

        public void IntializeManager(int assessmentId)
        {
            AssessmentID = assessmentId;
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
                                  where sca.Assessement_Id == AssessmentID
                                  select new SubCategoryAnswersPlus()
                                  {
                                      AssessmentId = sca.Assessement_Id,
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
            _applicationMode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == AssessmentID)
                .Select(x => x.Application_Mode).FirstOrDefault();

            // Default to 'questions mode' if not already set
            if (ApplicationMode == null)
            {
                _applicationMode = "Q";
                SetApplicationMode(ApplicationMode);
            }
            else if (ApplicationMode.ToLower().StartsWith("questions"))
            {
                _applicationMode = "Q";
            }
            else if (ApplicationMode.ToLower().StartsWith("requirements"))
            {
                _applicationMode = "R";
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
                                    .Where(s => s.Assessment_Id == AssessmentID && s.Selected_Sal_Level == usl.Full_Name_Sal)
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
            var sets = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == AssessmentID && x.Selected)
                .Select(x => x.Set_Name);
            _setNames = sets.ToList();
        }


        /// <summary>
        /// Stores the requested application mode in the STANDARD_SELECTION table.
        /// </summary>
        /// <param name="mode"></param>
        public void SetApplicationMode(string mode)
        {
            var standardSelection = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == AssessmentID).FirstOrDefault();
            if (standardSelection != null)
            {
                standardSelection.Application_Mode = (mode == "Q") ? "Questions Based" : "Requirements Based";
                _context.STANDARD_SELECTION.AddOrUpdate(standardSelection, x => x.Assessment_Id);
                _context.SaveChanges();
            }

            _assessmentUtil.TouchAssessment(AssessmentID);
        }

        public int StoreComponentAnswer(Answer answer)
        {
            // Find the Question or Requirement
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
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentID
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Is_Requirement == false && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = AssessmentID;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Number = answer.QuestionNumber;
            dbAnswer.Is_Requirement = false;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.Feedback = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;
            dbAnswer.Is_Component = true;

            _context.ANSWER.AddOrUpdate(dbAnswer, x => x.Answer_Id);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(AssessmentID);

            return dbAnswer.Answer_Id;
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


            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }
            string questionType = "Question";

            ANSWER dbAnswer = null;
            if (answer != null && answer.ComponentGuid != Guid.Empty)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentID
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Question_Type == answer.QuestionType && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }
            else if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == AssessmentID
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();
            }



            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = AssessmentID;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType ?? questionType;

            dbAnswer.Question_Number = answer.QuestionNumber;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.Feedback = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;


            _context.ANSWER.AddOrUpdate(dbAnswer, x => x.Answer_Id);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(AssessmentID);

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
            var list = _context.usp_Answer_Components_Default(AssessmentID).Cast<Answer_Components_Base>().ToList();
            
            AddResponse(resp, list, "Component Defaults");
            BuildOverridesOnly(resp);
        }

        public void BuildOverridesOnly(QuestionResponse resp)
        {
            // Because these are only override questions and the lists are short, don't bother grouping by group header.  Just subcategory.
            List<Answer_Components_Base> dlist = null;
            _context.LoadStoredProc("[usp_getAnswerComponentOverrides]")
              .WithSqlParam("assessment_id", AssessmentID)
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
                        SubCategoryAnswer = SubCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);
                    curSubHeading = dbQ.Universal_Sub_Category;
                }
                prevQuestionId = dbQ.Question_Id;
                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = FormatLineBreaks(dbQ.Simple_Question),
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.Feedback
                };

                sc.Questions.Add(qa);
            }


            resp.Domains[0].Categories.AddRange(groupList);
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
                        SubCategoryAnswer = SubCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);

                    curHeadingPairId = dbQ.heading_pair_id;
                }

                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = FormatLineBreaks(dbQ.Simple_Question),
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.Feedback
                };

                sc.Questions.Add(qa);
            }


            var container = new Domain()
            {
                DisplayText = listname
            };
            container.Categories.AddRange(groupList);
            resp.Domains.Add(container);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public string FormatLineBreaks(string s)
        {
            return s.Replace("\r\n", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>");
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