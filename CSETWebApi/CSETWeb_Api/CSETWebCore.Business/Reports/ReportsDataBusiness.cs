//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Maturity;
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Sal;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;


namespace CSETWebCore.Business.Reports
{
    public class ReportsDataBusiness : IReportsDataBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private int _assessmentId;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IMaturityBusiness _maturityBusiness;
        private readonly IQuestionRequirementManager _questionRequirement;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessment_id"></param>
        public ReportsDataBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IAssessmentModeData assessmentMode,
            IMaturityBusiness maturityBusiness, IQuestionRequirementManager questionRequirement)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _maturityBusiness = maturityBusiness;
            _questionRequirement = questionRequirement;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void SetReportsAssessmentId(int assessmentId)
        {
            _assessmentId = assessmentId;
        }


        /// <summary>
        /// Returns a list of questions/answers that are considered deficient for the assessment.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMaturityDeficiencies()
        {
           var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model_).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);


            // default answer values that are considered 'deficient'
            List<string> deficientAnswerValues = new List<string>() { "N" };

            // CMMC considers unanswered as deficient
            if (myModel.model_.Model_Name.ToUpper() == "CMMC")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }

            // EDM also considers unanswered and incomplete as deficient
            if (myModel.model_.Model_Name.ToUpper() == "EDM")
            {
                deficientAnswerValues = new List<string>() { "N", "U", "I" };
            }

            // RRA also considers unanswered and incomplete as deficient
            if (myModel.model_.Model_Name.ToUpper() == "RRA")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }


            var query = from a in _context.ANSWER
                          join m in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                          where a.Assessment_Id == _assessmentId
                               && a.Question_Type == "Maturity"
                               && m.Maturity_Model_Id == myModel.model_id
                               && deficientAnswerValues.Contains(a.Answer_Text)
                          orderby m.Grouping_Id, m.Maturity_Level, m.Mat_Question_Id ascending
                          select new MatRelevantAnswers()
                          {
                              ANSWER = a,
                              Mat = m
                          };

            var responseList = query.ToList();
            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswer that contain comments.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetCommentsList()
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model_).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var query = from a in _context.ANSWER
                       join m in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                       where a.Assessment_Id == _assessmentId && a.Question_Type == "Maturity" && !string.IsNullOrWhiteSpace(a.Comment) && m.Maturity_Model_Id == myModel.model_id
                       select new MatRelevantAnswers()
                       {
                           ANSWER = a,
                           Mat = m
                       };

            var responseList = query.ToList();
            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswer that are marked for review.
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMarkedForReviewList()
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model_).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var query = from a in _context.ANSWER
                       join m in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                       where a.Assessment_Id == _assessmentId && a.Question_Type == "Maturity" && (a.Mark_For_Review ?? false) == true && m.Maturity_Model_Id == myModel.model_id
                       select new MatRelevantAnswers()
                       {
                           ANSWER = a,
                           Mat = m
                       };

            var responseList = query.ToList();
            return responseList;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetAlternatesList()
        {
            var query = from a in _context.ANSWER
                       join m in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                       join mm in _context.AVAILABLE_MATURITY_MODELS on a.Assessment_Id equals mm.Assessment_Id
                       where a.Assessment_Id == _assessmentId && a.Question_Type == "Maturity" && a.Answer_Text == "A" && m.Maturity_Model_Id == mm.model_id
                       orderby m.Sequence
                       select new MatRelevantAnswers()
                       {
                           ANSWER = a,
                           Mat = m
                       };

            var responseList = query.ToList();

            return responseList;
        }


        /// <summary>
        /// Returns a list of answered maturity questions.  This was built for ACET
        /// but could be used by other maturity models with some work.
        /// </summary>
        /// <returns></returns>
        public List<MatAnsweredQuestionDomain> GetAnsweredQuestionList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model_)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            // get the target maturity level IDs
            var targetRange = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityRangeIds(_assessmentId);

            var questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id
                && targetRange.Contains(q.Maturity_Level)).ToList();


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type_)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        Components = new List<MaturityAnsweredQuestionsComponent>()
                    };

                    foreach (var componenet in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = componenet.Title,
                            Questions = new List<MaturityAnsweredQuestions>()
                        };

                        foreach (var question in componenet.Questions)
                        {
                            if (question.Answer != null)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    AnswerText = question.Answer,
                                };

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }


                                //if (question.MaturityLevel == 6)
                                //{
                                //    newQuestion.MaturityLevel = "ADV";
                                //}
                                //else if (question.MaturityLevel == 7)
                                //{
                                //    newQuestion.MaturityLevel = "B";

                                //}
                                //else if (question.MaturityLevel == 8)
                                //{
                                //    newQuestion.MaturityLevel = "E";

                                //}
                                //else if (question.MaturityLevel == 9)
                                //{
                                //    newQuestion.MaturityLevel = "INN";

                                //}
                                //else if (question.MaturityLevel == 10)
                                //{
                                //    newQuestion.MaturityLevel = "INT";

                                //}
                                //else
                                //{
                                //    newQuestion.MaturityLevel = "";
                                //}
                                newComponent.Questions.Add(newQuestion);

                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                        }

                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }

                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="g"></param>
        /// <param name="parentID"></param>
        /// <param name="allGroupings"></param>
        /// <param name="questions"></param>
        /// <param name="answers"></param>
        public void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var newGrouping = new MaturityGrouping()
                {
                    GroupingID = sg.Grouping_Id,
                    GroupingType = sg.Type_.Grouping_Type_Name,
                    Title = sg.Title,
                    Description = sg.Description,
                    Abbreviation = sg.Abbreviation
                };

                g.SubGroupings.Add(newGrouping);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == newGrouping.GroupingID).ToList();

                var parentQuestionIDs = myQuestions.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestions)
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();

                    var qa = new QuestionAnswer()
                    {
                        DisplayNumber = myQ.Question_Title,
                        QuestionId = myQ.Mat_Question_Id,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        QuestionType = "Maturity",
                        QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>"),
                        Answer = answer?.a.Answer_Text,
                        AltAnswerText = answer?.a.Alternate_Justification,
                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.FeedBack,
                        MarkForReview = answer?.a.Mark_For_Review ?? false,
                        Reviewed = answer?.a.Reviewed ?? false,
                        Is_Maturity = true,
                        // MaturityLevel = myQ.Maturity_Level,
                        IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id),
                        SetName = string.Empty
                    };

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);
                    }

                    newGrouping.Questions.Add(qa);
                }

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControls()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            var q = (from rs in _context.REQUIREMENT_SETS
                     join r in _context.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                     join rl in _context.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                     join s in _context.SETS on rs.Set_Name equals s.Set_Name
                     join av in _context.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                     join rqs in _context.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                     join qu in _context.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                     join a in _context.Answer_Questions_No_Components on qu.Question_Id equals a.Question_Or_Requirement_Id
                     where rl.Standard_Level == _questionRequirement.StandardLevel && av.Selected == true && rl.Level_Type == "NST"
                         && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
                     orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                     select new { r, rs, rl, s, qu, a }).ToList();

            //get all the questions for this control 
            //determine the percent implemented.                 
            int prev_requirement_id = 0;
            int questionCount = 0;
            int questionsAnswered = 0;
            BasicReportData.RequirementControl control = null;
            List<BasicReportData.Control_Questions> questions = null;
            foreach (var a in q.ToList())
            {
                
                if (prev_requirement_id != a.r.Requirement_Id)
                {
                    questionCount = 0;
                    questionsAnswered = 0;
                    questions = new List<BasicReportData.Control_Questions>();
                    control = new BasicReportData.RequirementControl()
                    {
                        ControlDescription = a.r.Requirement_Text,
                        RequirementTitle = a.r.Requirement_Title,
                        Level = a.rl.Standard_Level,
                        StandardShortName = a.s.Short_Name,
                        Standard_Category = a.r.Standard_Category,
                        SubCategory = a.r.Standard_Sub_Category,
                        Control_Questions = questions
                    };
                    controls.Add(control);
                }
                questionCount++;

                switch (a.a.Answer_Text)
                {
                    case Constants.Constants.ALTERNATE:
                    case Constants.Constants.YES:
                        questionsAnswered++;
                        break;
                }

                questions.Add(new BasicReportData.Control_Questions()
                {
                    Answer = a.a.Answer_Text,
                    Comment = a.a.Comment,
                    Simple_Question = a.qu.Simple_Question
                });

                control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                prev_requirement_id = a.r.Requirement_Id;
            }

            return controls;
        }


        public List<List<DiagramZones>> GetDiagramZones()
        {
            var level = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();


            var rval1 = (from c in _context.ASSESSMENT_DIAGRAM_COMPONENTS
                         join s in _context.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                         where c.Assessment_Id == _assessmentId && c.Zone_Id == null
                         orderby s.Symbol_Name, c.label
                         select new DiagramZones
                         {
                             Diagram_Component_Type = s.Symbol_Name,
                             label = c.label,
                             Zone_Name = "No Assigned Zone",
                             Universal_Sal_Level = level == null ? "Low" : level.Selected_Sal_Level
                         }).ToList();

            var rval = (from c in _context.ASSESSMENT_DIAGRAM_COMPONENTS
                        join z in _context.DIAGRAM_CONTAINER on c.Zone_Id equals z.Container_Id
                        join s in _context.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                        where c.Assessment_Id == _assessmentId
                        orderby s.Symbol_Name, c.label
                        select new DiagramZones
                        {
                            Diagram_Component_Type = s.Symbol_Name,
                            label = c.label,
                            Zone_Name = z.Name,
                            Universal_Sal_Level = z.Universal_Sal_Level
                        }).ToList();

            return rval.Union(rval1).GroupBy(u => u.Zone_Name).Select(grp => grp.ToList()).ToList();
        }


        public List<usp_getFinancialQuestions_Result> GetFinancialQuestions()
        {
            return _context.usp_getFinancialQuestions(_assessmentId).ToList();
        }


        public List<StandardQuestions> GetQuestionsForEachStandard()
        {
            var dblist = from a in _context.AVAILABLE_STANDARDS
                         join b in _context.NEW_QUESTION_SETS on a.Set_Name equals b.Set_Name
                         join c in _context.Answer_Questions on b.Question_Id equals c.Question_Or_Requirement_Id
                         join q in _context.NEW_QUESTION on c.Question_Or_Requirement_Id equals q.Question_Id
                         join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                         join s in _context.SETS on b.Set_Name equals s.Set_Name
                         where a.Selected == true && a.Assessment_Id == _assessmentId
                         && c.Assessment_Id == _assessmentId
                         orderby s.Short_Name, h.Question_Group_Heading, c.Question_Number
                         select new SimpleStandardQuestions()
                         {
                             ShortName = s.Short_Name,
                             Answer = c.Answer_Text,
                             CategoryAndNumber = h.Question_Group_Heading + " #" + c.Question_Number,
                             Question = q.Simple_Question
                         };

            List<StandardQuestions> list = new List<StandardQuestions>();
            string lastshortname = "";
            List<SimpleStandardQuestions> qlist = new List<SimpleStandardQuestions>();
            foreach (var a in dblist.ToList())
            {
                if (a.ShortName != lastshortname)
                {
                    qlist = new List<SimpleStandardQuestions>();
                    list.Add(new StandardQuestions()
                    {
                        Questions = qlist,
                        StandardShortName = a.ShortName
                    });
                }
                lastshortname = a.ShortName;
                qlist.Add(a);
            }

            return list;
        }


        /// <summary>
        /// Returns a list of questions generated by components in the network.
        /// The questions correspond to the SAL level of each component's Zone level.
        /// Questions for components in hidden layers are not included.
        /// </summary>
        /// <returns></returns>
        public List<ComponentQuestion> GetComponentQuestions()
        {
            var l = new List<ComponentQuestion>();

            List<usp_getExplodedComponent> results = null;

            _context.LoadStoredProc("[usp_getExplodedComponent]")
              .WithSqlParam("assessment_id", _assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  results = handler.ReadToList<usp_getExplodedComponent>().OrderBy(c => c.ComponentName).ThenBy(c => c.QuestionText).ToList();
              });

            foreach (usp_getExplodedComponent q in results)
            {
                l.Add(new ComponentQuestion
                {
                    Answer = q.Answer_Text,
                    ComponentName = q.ComponentName,
                    Component_Symbol_Id = q.Component_Symbol_Id,
                    Question = q.QuestionText,
                    LayerName = q.LayerName,
                    SAL = q.SAL,
                    Zone = q.ZoneName
                });
            }


            return l;
        }


        public List<usp_GetOverallRankedCategoriesPage_Result> GetTop5Categories()
        {

            return _context.usp_GetOverallRankedCategoriesPage(_assessmentId).Take(5).ToList();


        }


        public List<RankedQuestions> GetTop5Questions()
        {
            return GetRankedQuestions().Take(5).ToList();
        }


        /// <summary>
        /// Returns a list of questions that have been answered "Alt"
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithAltJust> GetQuestionsWithAlternateJustification()
        {

            var results = new List<QuestionsWithAltJust>();

            // get any "A" answers that currently apply

            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId)
                .Where(ans => ans.Answer_Text == "A").ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsWithAltJust()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                AlternateJustification = ans.Alternate_Justification,
                                Question = req.Requirement_Text
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsWithAltJust()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                AlternateJustification = ans.Alternate_Justification,
                                Question = q.Simple_Question
                            };

                return query.ToList();
            }

        }


        /// <summary>
        /// Returns a list of questions that have comments.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithComments> GetQuestionsWithComments()
        {

            var results = new List<QuestionsWithComments>();

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId)
                .Where(ans => !string.IsNullOrEmpty(ans.Comment))
                .ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsWithComments()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = req.Requirement_Text,
                                Comment = ans.Comment
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsWithComments()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                Question = q.Simple_Question,
                                Comment = ans.Comment
                            };

                return query.ToList();
            }
        }


        /// <summary>
        /// Returns a list of questions that have been marked for review.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsMarkedForReview> GetQuestionsMarkedForReview()
        {

            var results = new List<QuestionsMarkedForReview>();

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId)
                .Where(ans => ans.Mark_For_Review)
                .ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsMarkedForReview()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = req.Requirement_Text
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsMarkedForReview()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                Question = q.Simple_Question
                            };

                return query.ToList();
            }

        }


        public List<RankedQuestions> GetRankedQuestions()
        {
            var rm = new Question.RequirementBusiness(_assessmentUtil, _questionRequirement, _context, null);

            List<RankedQuestions> list = new List<RankedQuestions>();
            List<usp_GetRankedQuestions_Result> rankedQuestionList = _context.usp_GetRankedQuestions(_assessmentId).ToList();
            foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
            {
                q.QuestionText = rm.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);

                list.Add(new RankedQuestions()
                {
                    Answer = q.AnswerText,
                    CategoryAndNumber = q.Category + " #" + q.QuestionRef,
                    Level = q.Level,
                    Question = q.QuestionText,
                    Rank = q.Rank ?? 0
                });
            }

            return list;
        }


        public List<DocumentLibraryTable> GetDocumentLibrary()
        {
            List<DocumentLibraryTable> list = new List<DocumentLibraryTable>();
            var docs = from a in _context.DOCUMENT_FILE
                       where a.Assessment_Id == _assessmentId
                       select a;
            foreach (var doc in docs)
            {
                list.Add(new DocumentLibraryTable()
                {
                    DocumentTitle = doc.Title,
                    FileName = doc.Path
                });
            }

            return list;
        }


        public BasicReportData.OverallSALTable GetNistSals()
        {
            var manager = new NistSalBusiness(_context, _assessmentUtil);
            var sals = manager.CalculatedNist(_assessmentId);
            List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
            var infos = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
            Dictionary<string, string> typeToLevel = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToDictionary(x => x.CIA_Type, x => x.DropDownValueLevel);

            BasicReportData.OverallSALTable overallSALTable = new BasicReportData.OverallSALTable()
            {
                OSV = sals.Selected_Sal_Level,
                Q_AV = sals.ALevel,
                Q_CV = sals.CLevel,
                Q_IV = sals.ILevel
            };

            bool ok;
            string l;
            ok = typeToLevel.TryGetValue(Constants.Constants.Availabilty, out l);
            overallSALTable.IT_AV = ok ? l : "Low";
            ok = typeToLevel.TryGetValue(Constants.Constants.Confidentiality, out l);
            overallSALTable.IT_CV = ok ? l : "Low";
            ok = typeToLevel.TryGetValue(Constants.Constants.Integrity, out l);
            overallSALTable.IT_IV = ok ? l : "Low";

            return overallSALTable;
        }


        public List<BasicReportData.CNSSSALJustificationsTable> GetNistInfoTypes()
        {
            List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
            var infos = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
            foreach (CNSS_CIA_JUSTIFICATIONS info in infos)
            {
                list.Add(new BasicReportData.CNSSSALJustificationsTable()
                {
                    CIA_Type = info.CIA_Type,
                    Justification = info.Justification
                });
            }

            return list;
        }


        /// <summary>
        /// Returns SAL CIA values for the assessment.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.OverallSALTable GetSals()
        {
            var sals = (from a in _context.STANDARD_SELECTION
                        join b in _context.ASSESSMENT_SELECTED_LEVELS on a.Assessment_Id equals b.Assessment_Id
                        where a.Assessment_Id == _assessmentId
                        select new { a, b }).ToList();

            string OSV = "Low";
            string Q_CV = "Low";
            string Q_IV = "Low";
            string Q_AV = "Low";
            foreach (var s in sals)
            {
                OSV = s.a.Selected_Sal_Level;
                switch (s.b.Level_Name)
                {
                    case "Confidence_Level":
                        Q_CV = s.b.Standard_Specific_Sal_Level;
                        break;
                    case "Integrity_Level":
                        Q_IV = s.b.Standard_Specific_Sal_Level;
                        break;
                    case "Availability_Level":
                        Q_AV = s.b.Standard_Specific_Sal_Level;
                        break;
                }
            }

            // get active SAL type
            var standardSelection = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            return new BasicReportData.OverallSALTable()
            {
                OSV = OSV,
                Q_CV = Q_CV,
                Q_AV = Q_AV,
                Q_IV = Q_IV,
                LastSalDeterminationType = standardSelection.Last_Sal_Determination_Type
            };
        }


        /// <summary>
        /// Returns a block of data generally from the INFORMATION table plus a few others.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.INFORMATION GetInformation()
        {
            INFORMATION infodb = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();

            TinyMapper.Bind<INFORMATION, BasicReportData.INFORMATION>(config =>
            {
                config.Ignore(x => x.Additional_Contacts);
            });
            var info = TinyMapper.Map<BasicReportData.INFORMATION>(infodb);


            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            info.Assessment_Date = assessment.Assessment_Date.ToLongDateString();

            // Primary Assessor
            var user = _context.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
            info.Assessor_Name = user != null ? FormatName(user.FirstName, user.LastName) : string.Empty;


            // Other Contacts
            info.Additional_Contacts = new List<string>();
            var contacts = _context.ASSESSMENT_CONTACTS
                .Where(ac => ac.Assessment_Id == _assessmentId
                        && ac.UserId != assessment.AssessmentCreatorId)
                .Include(u => u.User)
                .ToList();
            foreach (var c in contacts)
            {
                info.Additional_Contacts.Add(FormatName(c.FirstName, c.LastName));
            }

            // Include anything that was in the INFORMATION record's Additional_Contacts column
            if (infodb.Additional_Contacts != null)
            {
                string[] acLines = infodb.Additional_Contacts.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string c in acLines)
                {
                    info.Additional_Contacts.Add(c);
                }
            }


            // ACET properties
            info.Credit_Union_Name = assessment.CreditUnionName;
            info.Charter = assessment.Charter;

            info.Assets = 0;
            bool a = int.TryParse(assessment.Assets, out int assets);
            if (a)
            {
                info.Assets = assets;
            }


            // Maturity properties
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model_)
                .FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            if (myModel != null)
            {
                info.QuestionsAlias = myModel.model_.Questions_Alias;
            }

            return info;
        }


        /// <summary>
        /// Returns a list of individuals assigned to findings/observations.
        /// </summary>
        /// <returns></returns>
        public List<Individual> GetFindingIndividuals()
        {

            var findings = (from a in _context.FINDING_CONTACT
                            join b in _context.FINDING on a.Finding_Id equals b.Finding_Id
                            join c in _context.ANSWER on b.Answer_Id equals c.Answer_Id
                            join d in _context.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals d.Assessment_Contact_Id
                            join i in _context.IMPORTANCE on b.Importance_Id equals i.Importance_Id
                            where c.Assessment_Id == _assessmentId
                            orderby a.Assessment_Contact_Id, b.Answer_Id, b.Finding_Id
                            select new { a, b, d, i.Value }).ToList();



            List<Individual> list = new List<Individual>();
            int contactid = 0;
            Individual individual = null;
            foreach (var f in findings)
            {
                if (contactid != f.a.Assessment_Contact_Id)
                {
                    individual = new Individual()
                    {
                        Findings = new List<Findings>(),
                        INDIVIDUALFULLNAME = FormatName(f.d.FirstName, f.d.LastName)
                    };
                    list.Add(individual);
                }
                contactid = f.a.Assessment_Contact_Id;
                TinyMapper.Bind<FINDING, Findings>();
                Findings rfind = TinyMapper.Map<Findings>(f.b);
                rfind.Finding = f.b.Summary;
                rfind.ResolutionDate = f.b.Resolution_Date.ToString();
                rfind.Importance = f.Value;

                var othersList = (from a in f.b.FINDING_CONTACT
                                  join b in _context.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals b.Assessment_Contact_Id
                                  select FormatName(b.FirstName, b.LastName)).ToList();
                rfind.OtherContacts = string.Join(",", othersList);
                individual.Findings.Add(rfind);

            }
            return list;


        }


        public GenSALTable GetGenSals()
        {
            var gensalnames = _context.GEN_SAL_NAMES.ToList();
            var actualvalues = (from a in _context.GENERAL_SAL.Where(x => x.Assessment_Id == _assessmentId)
                                join b in _context.GEN_SAL_WEIGHTS on new { a.Sal_Name, a.Slider_Value } equals new { b.Sal_Name, b.Slider_Value }
                                select b).ToList();
            GenSALTable genSALTable = new GenSALTable();
            foreach (var a in gensalnames)
            {
                genSALTable.setValue(a.Sal_Name, "None");
            }
            foreach (var a in actualvalues)
            {
                genSALTable.setValue(a.Sal_Name, a.Display);
            }
            return genSALTable;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<MaturityReportData.MaturityModel> GetMaturityModelData()
        {
            List<MaturityReportData.MaturityQuestion> mat_questions = new List<MaturityReportData.MaturityQuestion>();
            List<MaturityReportData.MaturityModel> mat_models = new List<MaturityReportData.MaturityModel>();

            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);

            var query = (
                from amm in _context.AVAILABLE_MATURITY_MODELS
                join mm in _context.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                join mq in _context.MATURITY_QUESTIONS on mm.Maturity_Model_Id equals mq.Maturity_Model_Id
                join ans in _context.ANSWER on mq.Mat_Question_Id equals ans.Question_Or_Requirement_Id
                join asl in _context.ASSESSMENT_SELECTED_LEVELS on amm.Assessment_Id equals asl.Assessment_Id
                where amm.Assessment_Id == _assessmentId
                && ans.Assessment_Id == _assessmentId
                && ans.Is_Maturity == true
                && asl.Level_Name == "Maturity_Level"
                select new { amm, mm, mq, ans, asl }
                ).ToList();
            var models = query.Select(x => new { x.mm, x.asl }).Distinct();
            foreach (var model in models)
            {
                MaturityReportData.MaturityModel newModel = new MaturityReportData.MaturityModel();
                newModel.MaturityModelName = model.mm.Model_Name;
                newModel.MaturityModelID = model.mm.Maturity_Model_Id;
                if (Int32.TryParse(model.asl.Standard_Specific_Sal_Level, out int lvl))
                {
                    newModel.TargetLevel = lvl;
                }
                else
                {
                    newModel.TargetLevel = null;
                }
                mat_models.Add(newModel);
            }

            foreach (var queryItem in query)
            {
                MaturityReportData.MaturityQuestion newQuestion = new MaturityReportData.MaturityQuestion();
                newQuestion.Mat_Question_Id = queryItem.mq.Mat_Question_Id;
                newQuestion.Question_Title = queryItem.mq.Question_Title;
                newQuestion.Question_Text = queryItem.mq.Question_Text;
                newQuestion.Supplemental_Info = queryItem.mq.Supplemental_Info;
                newQuestion.Examination_Approach = queryItem.mq.Examination_Approach;
                newQuestion.Grouping_Id = queryItem.mq.Grouping_Id ?? 0;
                newQuestion.Parent_Question_Id = queryItem.mq.Parent_Question_Id;
                newQuestion.Maturity_Level = queryItem.mq.Maturity_Level;
                newQuestion.Set_Name = queryItem.mm.Model_Name;
                newQuestion.Sequence = queryItem.mq.Sequence;
                newQuestion.Maturity_Model_Id = queryItem.mm.Maturity_Model_Id;
                newQuestion.Answer = queryItem.ans;

                mat_models.Where(x => x.MaturityModelID == newQuestion.Maturity_Model_Id)
                    .FirstOrDefault()
                    .MaturityQuestions.Add(newQuestion);

                mat_questions.Add(newQuestion);
            }

            return mat_models;
        }

        /// <summary>
        /// Formats first and last name.  If the name is believed to be a domain\userid, 
        /// the userid is returned with the domain removed.
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <returns></returns>
        public string FormatName(string firstName, string lastName)
        {
            firstName = firstName.Trim();
            lastName = lastName.Trim();

            if (firstName.Length > 0 && lastName.Length > 0)
            {
                return string.Format("{0} {1}", firstName, lastName);
            }

            // if domain-qualified userid, remove domain
            if (firstName.IndexOf('\\') >= 0 && firstName.IndexOf(' ') < 0 && lastName.Length == 0)
            {
                return firstName.Substring(firstName.LastIndexOf('\\') + 1);
            }

            return string.Format("{0} {1}", firstName, lastName);
        }
    }
}



