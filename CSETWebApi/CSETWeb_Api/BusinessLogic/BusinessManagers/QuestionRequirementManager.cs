//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Snickler.EFCore;

namespace CSETWeb_Api.BusinessManagers
{
    public abstract class QuestionRequirementManager
    {

        public List<SubCategoryAnswersPlus> subCatAnswers;

        /// <summary>
        /// 
        /// </summary>
        protected int _assessmentId;

        /// <summary>
        /// 
        /// </summary>
        protected string _standardLevel;

        /// <summary>
        /// 
        /// </summary>
        protected List<string> _setNames = null;

        /// <summary>
        /// 
        /// </summary>
        protected string applicationMode = "";

        /// <summary>
        /// 
        /// </summary>
        public string ApplicationMode
        {
            get
            {
                return this.applicationMode;
            }
        }


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="assessmentId"></param>
        protected QuestionRequirementManager(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                _assessmentId = assessmentId;
                InitializeApplicationMode(db);
                InitializeSalLevel(db);
                InitializeStandardsForAssessment(db);
                InitializeSubCategoryAnswers(db);

            }
        }

        private void InitializeSubCategoryAnswers(CSET_Context db)
        {
            // Get any subcategory answers for the assessment
            this.subCatAnswers = (from sca in db.SUB_CATEGORY_ANSWERS
                                  join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on sca.Heading_Pair_Id equals usch.Heading_Pair_Id
                                  where sca.Assessement_Id == _assessmentId
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
        protected void InitializeApplicationMode(CSET_Context db)
        {
            applicationMode = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId)
                .Select(x => x.Application_Mode).FirstOrDefault();

            // Default to 'questions mode' if not already set
            if (applicationMode == null)
            {
                applicationMode = "Q";
                SetApplicationMode(applicationMode);
            }
            else if (applicationMode.ToLower().StartsWith("questions"))
            {
                applicationMode = "Q";
            }
            else if (applicationMode.ToLower().StartsWith("requirements"))
            {
                applicationMode = "R";
            }
        }


        /// <summary>
        /// Determines the assessment's SAL standard level (letter code)
        /// </summary>
        /// <returns></returns>
        protected void InitializeSalLevel(CSET_Context db)
        {

            var querySalLevel = from usl in db.UNIVERSAL_SAL_LEVEL
                                from ss in db.STANDARD_SELECTION
                                    .Where(s => s.Assessment_Id == _assessmentId && s.Selected_Sal_Level == usl.Full_Name_Sal)
                                select usl.Universal_Sal_Level1;
            _standardLevel = querySalLevel.ToList().FirstOrDefault();

        }


        /// <summary>
        /// Creates a list of standards selected for the assessment.
        /// </summary>
        /// <returns></returns>
        protected void InitializeStandardsForAssessment(CSET_Context db)
        {
            List<string> result = new List<string>();
            var sets = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == _assessmentId && x.Selected)
                .Select(x => x.Set_Name);
            _setNames = sets.ToList();
        }


        /// <summary>
        /// Stores the requested application mode in the STANDARD_SELECTION table.
        /// </summary>
        /// <param name="mode"></param>
        public void SetApplicationMode(string mode)
        {
            var db = new CSET_Context();
            var standardSelection = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
            if (standardSelection != null)
            {
                standardSelection.Application_Mode = (mode == "Q") ? "Questions Based" : "Requirements Based";
                db.STANDARD_SELECTION.AddOrUpdate(standardSelection, x => x.Assessment_Id);
                db.SaveChanges();
            }

            AssessmentUtil.TouchAssessment(_assessmentId);
        }

        public int StoreComponentAnswer(Answer answer)
        {
            var db = new CSET_Context();

            // Find the Question or Requirement
            var question = db.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();

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
                dbAnswer = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Is_Requirement == false && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = _assessmentId;
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

            db.ANSWER.AddOrUpdate(dbAnswer, x => x.Answer_Id);
            db.SaveChanges();

            AssessmentUtil.TouchAssessment(_assessmentId);

            return dbAnswer.Answer_Id;
        }

        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(Answer answer)
        {
            var db = new CSET_Context();

            // Find the Question or Requirement
            var question = db.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();
            var requirement = db.NEW_REQUIREMENT.Where(r => r.Requirement_Id == answer.QuestionId).FirstOrDefault();

            if (question == null && requirement == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }


            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            ANSWER dbAnswer = null;
            if (answer != null && answer.ComponentGuid != Guid.Empty)
            {
                dbAnswer = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Is_Requirement == answer.Is_Requirement && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }
            else if (answer != null)
            {
                dbAnswer = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Is_Requirement == answer.Is_Requirement).FirstOrDefault();
            }

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = _assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Number = answer.QuestionNumber;
            dbAnswer.Is_Requirement = answer.Is_Requirement;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.Feedback = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;
            dbAnswer.Is_Component = answer.Is_Component;

            db.ANSWER.AddOrUpdate(dbAnswer, x => x.Answer_Id);
            db.SaveChanges();

            AssessmentUtil.TouchAssessment(_assessmentId);

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
            using (CSET_Context context = new CSET_Context())
            {
                var list = context.Answer_Components_Default.Where(x => x.Assessment_Id == this._assessmentId).Cast<Answer_Components_Base>()
                    .OrderBy(x => x.Question_Group_Heading).ThenBy(x => x.Universal_Sub_Category).ToList();

                AddResponse(resp, context, list, "Component Defaults");
                BuildOverridesOnly(resp, context);
            }
        }

        public void BuildOverridesOnly(QuestionResponse resp, CSET_Context context)
        {
            // Because these are only override questions and the lists are short, don't bother grouping by group header.  Just subcategory.
            List<Answer_Components_Base> dlist = null;
            context.LoadStoredProc("[dbo].[usp_getAnswerComponentOverrides]")
              .WithSqlParam("assessment_id", this._assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  dlist = handler.ReadToList<Answer_Components_Base>()
                    .OrderBy(x => x.Symbol_Name).ThenBy(x => x.ComponentName).ThenBy(x => x.Component_Guid)
                    .ThenBy(x => x.Universal_Sub_Category)
                    .ToList();
              });

            AddResponseComponentOverride(resp, context, dlist, "Component Overrides");
        }

        private void AddResponseComponentOverride(QuestionResponse resp, CSET_Context context, List<Answer_Components_Base> list, string listname)
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
                        SubCategoryAnswer = this.subCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
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


            resp.QuestionGroups.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }



        private void AddResponse(QuestionResponse resp, CSET_Context context, List<Answer_Components_Base> list, string listname)
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
                        SubCategoryAnswer = this.subCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
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


            resp.QuestionGroups.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }

        public static string FormatLineBreaks(string s)
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

