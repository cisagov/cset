//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Contact;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Maturity.Configuration;
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Reports;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace CSETWebCore.Business.Reports
{
    public partial class ReportsDataBusiness : IReportsDataBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private int _assessmentId;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IMaturityBusiness _maturityBusiness;
        private readonly IQuestionRequirementManager _questionRequirement;
        private ITokenManager _tokenManager;

        public List<int> OutOfScopeQuestions = new List<int>();

        private TranslationOverlay _overlay;



        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessment_id"></param>
        public ReportsDataBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IAssessmentModeData assessmentMode,
            IMaturityBusiness maturityBusiness, IQuestionRequirementManager questionRequirement, ITokenManager tokenManager)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _maturityBusiness = maturityBusiness;
            _questionRequirement = questionRequirement;
            _tokenManager = tokenManager;

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// Allows the token to be set after construction.  This is needed
        /// in the Reports realm, when tokens are passed as a param to the controller method.
        /// </summary>
        /// <param name="token"></param>
        public void SetToken(ITokenManager token)
        {
            _tokenManager = token;
        }


        /// <summary>
        /// Returns an unfiltered list of MatRelevantAnswers for the current assessment.
        /// The optional modelId parameter is used to get a specific model's questions.  If not
        /// supplied, the default model's questions are retrieved.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetQuestionsList(int? modelId = null)
        {
            int targetModelId = 0;

            if (modelId == null)
            {
                var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
                if (myModel == null)
                {
                    return new List<MatRelevantAnswers>();
                }

                targetModelId = myModel.model_id;
            }
            else
            {
                targetModelId = (int)modelId;
            }


            var lang = _tokenManager.GetCurrentLanguage();

            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);

            // flesh out model-specific questions 
            if (modelId != null)
            {
                _context.FillEmptyMaturityQuestionsForModel(_assessmentId, (int)modelId);
            }

            var query = from a in _context.ANSWER
                        join m in _context.MATURITY_QUESTIONS.Include(x => x.Maturity_Level)
                            on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                        join p in _context.MATURITY_QUESTION_PROPS 
                            on m.Mat_Question_Id equals p.Mat_Question_Id
                        where a.Assessment_Id == _assessmentId
                            && m.Maturity_Model_Id == targetModelId
                            && a.Question_Type == "Maturity"
                            && !this.OutOfScopeQuestions.Contains(m.Mat_Question_Id)
                        orderby m.Grouping_Id, m.Maturity_Level_Id, m.Mat_Question_Id ascending
                        select new MatRelevantAnswers()
                        {
                            ANSWER = a,
                            Mat = m
                        };

            var responseList = query.ToList();
            var childQuestions = responseList.FindAll(x => x.Mat.Parent_Question_Id != null);

            // Set IsParentWithChildren property for all parent questions that have child questions
            foreach (var matAns in responseList)
            {
                if (childQuestions.Exists(x => x.Mat.Parent_Question_Id == matAns.Mat.Mat_Question_Id))
                {
                    matAns.IsParentWithChildren = true;
                }
            }


            // Do not include unanswerable questions
            responseList.RemoveAll(x => !x.Mat.Is_Answerable);


            foreach (var matAns in responseList)
            {
                var o = _overlay.GetMaturityQuestion(matAns.Mat.Mat_Question_Id, lang);
                if (o != null)
                {
                    matAns.Mat.Question_Title = o.QuestionTitle ?? matAns.Mat.Question_Title;
                    matAns.Mat.Question_Text = o.QuestionText;
                    matAns.Mat.Supplemental_Info = o.SupplementalInfo;
                }
            }


            // if a maturity level is defined, only report on questions at or below that level
            int? selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == _assessmentId
                && x.Level_Name == Constants.Constants.MaturityLevel).Select(x => int.Parse(x.Standard_Specific_Sal_Level)).FirstOrDefault();

            NullOutNavigationPropeties(responseList);

            // RRA should be always be defaulted to its maximum available level (3)
            // since the user can't configure it
            if (targetModelId == Constants.Constants.Model_RRA)
            {
                selectedLevel = 3;
            }

            if (selectedLevel != null && selectedLevel != 0)
            {
                responseList = responseList.Where(x => x.Mat.Maturity_Level.Level <= selectedLevel).ToList();
            }


            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that are considered deficient for the assessment.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMaturityDeficiencies(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;


            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }


            bool ignoreParentQuestions = false;

            // default answer values that are considered 'deficient' (in case we can't find a model config profile)
            List<string> deficientAnswerValues = new List<string>() { "N", "U" };


            // try to get a configuration for the actual model
            var modelProperties = new ModelProfile().GetModelProperties(targetModel.Maturity_Model_Id);
            if (modelProperties != null)
            {
                deficientAnswerValues = modelProperties.DeficientAnswers;
                ignoreParentQuestions = modelProperties.IgnoreParentQuestions;
            }


            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => deficientAnswerValues.Contains(x.ANSWER.Answer_Text)).ToList();


            // We don't consider parent questions that have children to be unanswered for certain maturity models
            // (i.e. for CRR, EDM since they just house the question extras)
            if (ignoreParentQuestions)
            {
                responseList = responseList.Where(x => !x.IsParentWithChildren).ToList();
            }


            // If the assessment is using a submodel, only keep the submodel's subset of questions
            var maturitySubmodel = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == _assessmentId && x.DataItemName == "MATURITY-SUBMODEL").FirstOrDefault();
            if (maturitySubmodel != null)
            {
                var whitelist = _context.MATURITY_SUB_MODEL_QUESTIONS.Where(x => x.Sub_Model_Name == maturitySubmodel.StringValue).Select(q => q.Mat_Question_Id).ToList();
                responseList = responseList.Where(x => whitelist.Contains(x.Mat.Mat_Question_Id)).ToList();
            }

            return responseList;
        }



        /// <summary>
        /// Returns a list of MatRelevantAnswers that contain comments.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetCommentsList(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;

            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }

            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => !string.IsNullOrWhiteSpace(x.ANSWER.Comment)).ToList();

            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that are marked for review.
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMarkedForReviewList(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;

            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }

            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => x.ANSWER.Mark_For_Review ?? false).ToList();

            return responseList;
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
                    GroupingId = sg.Grouping_Id,
                    GroupingType = sg.Type.Grouping_Type_Name,
                    GroupingLevel = sg.Group_Level ?? 1,
                    Title = sg.Title,
                    Description = sg.Description,
                    Abbreviation = sg.Abbreviation
                };

                g.SubGroupings.Add(newGrouping);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == newGrouping.GroupingId).ToList();

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
                        //freeResponseAnswer= answer?.a.Free_Response_Answer,
                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.FeedBack,
                        MarkForReview = answer?.a.Mark_For_Review ?? false,
                        Reviewed = answer?.a.Reviewed ?? false,
                        Is_Maturity = true,
                        MaturityLevel = myQ.Maturity_Level_Id,
                        IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id) || myQ.Parent_Question_Id == null,
                        SetName = string.Empty,
                        FreeResponseAnswer = answer?.a.Free_Response_Answer
                    };

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);

                        // db view still uses the term "HasDiscovery" - map to "HasObservation"
                        qa.HasObservation = answer.b.HasDiscovery ?? false;
                    }

                    newGrouping.Questions.Add(qa);
                }

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingId, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControlsDiagram(string applicationMode)

        {

            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            _questionRequirement.InitializeManager(_assessmentId);

            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            string level = _questionRequirement.StandardLevel == null ? "L" : _questionRequirement.StandardLevel;

            List<ControlRow> controlRows = new List<ControlRow>();

            var qQ = (from rs in _context.Answer_Components_Default
                      orderby rs.Question_Group_Heading
                      where rs.Assessment_Id == _assessmentId
                      select new { rs }).ToList();

            foreach (var q in qQ)
            {
                controlRows.Add(new ControlRow()
                {
                    Requirement_Id = q.rs.heading_pair_id,
                    Requirement_Text = q.rs.Sub_Heading_Question_Description,
                    Answer_Text = q.rs.Answer_Text,
                    Comment = q.rs.Comment,
                    Question_Id = q.rs.Question_Id,
                    Requirement_Title = q.rs.Question_Group_Heading,
                    Short_Name = q.rs.ComponentName,
                    Simple_Question = q.rs.QuestionText,
                    Standard_Category = q.rs.Question_Group_Heading,
                    Standard_Sub_Category = q.rs.Universal_Sub_Category,
                    Standard_Level = q.rs.SAL
                });
            }

            //get all the questions for this control 
            //determine the percent implemented.                 
            int prev_requirement_id = 0;
            int questionCount = 0;
            int questionsAnswered = 0;
            BasicReportData.RequirementControl control = null;
            List<BasicReportData.Control_Questions> questions = null;

            foreach (var a in controlRows)
            {
                if (prev_requirement_id != a.Requirement_Id)
                {
                    questionCount = 0;
                    questionsAnswered = 0;
                    questions = new List<BasicReportData.Control_Questions>();
                    control = new BasicReportData.RequirementControl()
                    {
                        ControlDescription = a.Requirement_Text,
                        RequirementTitle = a.Requirement_Title,
                        Level = a.Standard_Level,
                        StandardShortName = a.Short_Name,
                        Standard_Category = a.Standard_Category,
                        SubCategory = a.Standard_Sub_Category,
                        Control_Questions = questions
                    };
                    controls.Add(control);
                }
                questionCount++;

                switch (a.Answer_Text)
                {
                    case Constants.Constants.ALTERNATE:
                    case Constants.Constants.YES:
                        questionsAnswered++;
                        break;
                }

                questions.Add(new BasicReportData.Control_Questions()
                {
                    Answer = a.Answer_Text,
                    Comment = a.Comment,
                    Simple_Question = a.Simple_Question
                });

                control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                prev_requirement_id = a.Requirement_Id;
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
                             Question = q.Simple_Question,
                             QuestionId = q.Question_Id
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


        public async Task<List<StandardQuestions>> GetStandardQuestionAnswers(int assessId)
        {
            CsetwebContextProcedures context = new CsetwebContextProcedures(_context);
            var parmSub = new ParameterSubstitution(_context, _tokenManager);
            var dblist = await context.usp_GetQuestionsAsync(assessId);

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
                qlist.Add(new SimpleStandardQuestions()
                {
                    ShortName = a.ShortName,

                    Question = parmSub.ResolveParameters(a.QuestionOrRequirementID, a.AnswerID, a.QuestionText),
                    QuestionId = a.QuestionOrRequirementID,
                    Answer = a.AnswerText,
                    CategoryAndNumber = a.CategoryAndNumber
                });
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
                    QuestionId = q.Question_Id,
                    LayerName = q.LayerName,
                    SAL = q.SAL,
                    Zone = q.ZoneName,
                    IsOverride = (q.Answer_Id != null)
                });
            }

            return l;
        }


        public List<usp_GetOverallRankedCategoriesPage_Result> GetTop5Categories()
        {
            var lang = _tokenManager.GetCurrentLanguage();

            var categories = _context.usp_GetOverallRankedCategoriesPage(_assessmentId).Take(5).ToList();

            for (var i = 0; i < categories.Count; i++)
            {
                var cat = categories[i];
                cat.Question_Group_Heading = _overlay.GetValue("QUESTION_GROUP_HEADING", cat.QGH_Id.ToString(), lang)?.Value ?? cat.Question_Group_Heading;
            }

            return categories;
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

            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            // get any "A" answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
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
                                Id = req.Requirement_Id,
                                Answer = ans.Answer_Text,
                                AnswerId = ans.Answer_ID,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                AlternateJustification = ans.Alternate_Justification,
                                Question = req.Requirement_Text
                            };

                var reqs = query.ToList();

                foreach(var req in reqs)
                {
                    req.Question = parmSub.ResolveParameters(req.Id, req.AnswerId, req.Question);
                }

                return reqs;
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsWithAltJust()
                            {
                                Id = q.Question_Id,
                                Answer = ans.Answer_Text,
                                AnswerId = ans.Answer_ID,
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

            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
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
                                Question = parmSub.ResolveParameters(ans.Question_Or_Requirement_ID, ans.Answer_ID, req.Requirement_Text),
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
            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            var results = new List<QuestionsMarkedForReview>();

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
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
                                Id = req.Requirement_Id,
                                Answer = ans.Answer_Text,
                                AnswerId = ans.Answer_ID,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = req.Requirement_Text
                            };

                var reqs = query.ToList();

                foreach (var req in reqs)
                {
                    req.Question = parmSub.ResolveParameters(req.Id, req.AnswerId, req.Question);
                }

                return reqs;
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


        /// <summary>
        /// Returns a list of questions that have been reviewed.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsMarkedForReview> GetQuestionsReviewed()
        {
            var results = new List<QuestionsMarkedForReview>();

            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
                .Where(ans => ans.Reviewed)
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
                                Id = req.Requirement_Id,
                                Answer = ans.Answer_Text,
                                AnswerId = ans.Answer_ID,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = parmSub.ResolveParameters(ans.Question_Or_Requirement_ID, ans.Answer_ID, req.Requirement_Text)
                            };

                var reqs = query.ToList();

                foreach (var req in reqs)
                {
                    req.Question = parmSub.ResolveParameters(req.Id, req.AnswerId, req.Question);
                }

                return reqs;
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
            var lang = _tokenManager.GetCurrentLanguage();

            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            List<RankedQuestions> list = new List<RankedQuestions>();
            List<usp_GetRankedQuestions_Result> rankedQuestionList = _context.usp_GetRankedQuestions(_assessmentId).ToList();
            foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
            {
                if (q.RequirementId != null)
                {
                    var reqOverlay = _overlay.GetRequirement((int)q.RequirementId, lang);
                    if (reqOverlay != null)
                    {
                        q.QuestionText = reqOverlay.RequirementText;
                    }
                }

                q.QuestionText = parmSub.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);

                q.Category = _overlay.GetPropertyValue("STANDARD_CATEGORY", q.Category.ToLower(), lang) ?? q.Category;

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


        public List<PhysicalQuestions> GetQuestionsWithSupplementals()
        {
            var lang = _tokenManager.GetCurrentLanguage();

            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            List<PhysicalQuestions> list = new List<PhysicalQuestions>();
            List<usp_GetRankedQuestions_Result> rankedQuestionList = _context.usp_GetRankedQuestions(_assessmentId).ToList();


            var supplementalLookups = (from a in _context.NEW_REQUIREMENT
                                       join b in _context.REQUIREMENT_SETS on a.Requirement_Id equals b.Requirement_Id
                                       where b.Set_Name == "MOPhysical"
                                       select a).ToDictionary(x => x.Requirement_Id, x => x);

            foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
            {
                if (q.RequirementId != null)
                {
                    var reqOverlay = _overlay.GetRequirement((int)q.RequirementId, lang);
                    if (reqOverlay != null)
                    {
                        q.QuestionText = reqOverlay.RequirementText;
                    }

                }


                q.QuestionText = parmSub.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);

                q.Category = _overlay.GetPropertyValue("STANDARD_CATEGORY", q.Category.ToLower(), lang) ?? q.Category;
                var comment = _context.Answer_Requirements.Where(x => x.Question_Or_Requirement_Id == q.QuestionOrRequirementID).FirstOrDefault()?.Comment;
                var supplemental = supplementalLookups[q.RequirementId ?? 0].Supplemental_Info;
                list.Add(new PhysicalQuestions()
                {
                    Answer = q.AnswerText,
                    CategoryAndNumber = q.Category + " #" + q.QuestionRef,
                    Level = q.Level,
                    Question = q.QuestionText,
                    Rank = q.Rank ?? 0,
                    Supplemental = supplemental,
                    Comment = comment
                });
            }

            return list;
        }


        public BasicReportData.OverallSALTable GetNistSals()
        {
            var manager = new NistSalBusiness(_context, _assessmentUtil, _tokenManager);
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
            var info = TinyMapper.Map<INFORMATION, BasicReportData.INFORMATION>(infodb);

            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            info.Assessment_Date = assessment.Assessment_Date;

            info.Assessment_Effective_Date = assessment.AssessmentEffectiveDate;
            info.Assessment_Creation_Date = assessment.AssessmentCreatedDate;


            // Facilitator or Primary Assessor (Creator)
            USERS userCreator = _context.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
            var demoExtBiz = new DemographicExtBusiness(_context);
            var facilitatorId = (int?)demoExtBiz.GetX(_assessmentId, "FACILITATOR");
            
            if (facilitatorId != null)
                
            {
                USERS user = _context.USERS.FirstOrDefault(x => x.UserId == facilitatorId);
                info.Assessor_Name = user != null ? FormatName(user.FirstName, user.LastName) : string.Empty;
            }
            else
            {
                info.Assessor_Name = userCreator != null ? FormatName(userCreator.FirstName, userCreator.LastName) : string.Empty;
            }


           
            info.SelfAssessment = ((bool?)demoExtBiz.GetX(_assessmentId, "SELF-ASSESS")) ?? false;
         

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

            info.UseStandard = assessment.UseStandard;
            info.UseMaturity = assessment.UseMaturity;
            info.UseDiagram = assessment.UseDiagram;

            // ACET properties
            info.Credit_Union_Name = assessment.CreditUnionName;
            info.Charter = assessment.Charter;

            info.Assets = 0;
            bool a = long.TryParse(assessment.Assets, out long assets);
            if (a)
            {
                info.Assets = assets;
            }

            // Maturity properties
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            if (myModel != null)
            {
                info.QuestionsAlias = myModel.model.Questions_Alias;
            }

            return info;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Individual> GetObservationIndividuals()
        {
            List<Individual> individualList = [];

            var observations = (from f in _context.FINDING
                                join fc in _context.FINDING_CONTACT on f.Finding_Id equals fc.Finding_Id into fc1
                                from fc in fc1.DefaultIfEmpty()
                                join a in _context.ANSWER on f.Answer_Id equals a.Answer_Id
                                join mq in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals mq.Mat_Question_Id into mq1
                                from mq in mq1.DefaultIfEmpty()
                                join nr in _context.NEW_REQUIREMENT on a.Question_Or_Requirement_Id equals nr.Requirement_Id into nr1
                                from nr in nr1.DefaultIfEmpty()
                                join ac in _context.ASSESSMENT_CONTACTS on fc.Assessment_Contact_Id equals ac.Assessment_Contact_Id into ac1
                                from ac in ac1.DefaultIfEmpty()
                                join i in _context.IMPORTANCE on f.Importance_Id equals i.Importance_Id into i1
                                from i in i1.DefaultIfEmpty()
                                where a.Assessment_Id == _assessmentId
                                select new ObservationIngredients()
                                {
                                    Finding = f,
                                    FC = fc,
                                    Answer = a,
                                    MaturityQuestion = mq,
                                    NewRequirement = nr,
                                    Importance = i
                                }).ToList();

            var acc = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == _assessmentId).OrderBy(x => x.Assessment_Contact_Id).ToList();


            // Get any associated questions to get their display reference
            var standardQuestions = GetQuestionsForEachStandard();
            var componentQuestions = GetComponentQuestions();



            // First handle the 'assigned' Observations
            foreach (var contact in acc)
            {
                Individual individual = new Individual()
                {
                    FullName = FormatName(contact.FirstName, contact.LastName)
                };

                var obsList = observations.Where(x => x.FC?.Assessment_Contact_Id == contact.Assessment_Contact_Id).ToList();

                foreach (var m in obsList)
                {
                    var obs = GenerateObservation(m, standardQuestions, componentQuestions);

                    individual.Observations.Add(obs);
                }

                if (individual.Observations.Count > 0)
                {
                    individualList.Add(individual);
                }
            }


            // Include any 'unassigned' Observations
            var ind = new Individual();
            ind.FullName = "Unassigned";

            var unnasignedObs = observations.Where(x => x.FC == null).ToList();
            foreach (var obs in unnasignedObs)
            {
                var observation = GenerateObservation(obs, standardQuestions, componentQuestions);
                ind.Observations.Add(observation);
            }

            if (ind.Observations.Count > 0)
            {
                individualList.Add(ind);
            }

            return individualList;
        }


        /// <summary>
        /// Creates and populates an instance of Observation
        /// </summary>
        /// <param name="oi"></param>
        /// <returns></returns>
        private Observation GenerateObservation(ObservationIngredients oi, List<StandardQuestions> standardQuestions, List<ComponentQuestion> componentQuestions)
        {
            TinyMapper.Bind<FINDING, Observation>();
            Observation obs = TinyMapper.Map<Observation>(oi.Finding);
            obs.ObservationTitle = oi.Finding.Summary;
            obs.ResolutionDate = oi.Finding.Resolution_Date;
            obs.Importance = oi.Importance.Value;


            // get the question identifier and text
            GetQuestionTitleAndText(oi, standardQuestions, componentQuestions, oi.Answer.Answer_Id,
                out string qid, out string qtxt);

            obs.QuestionIdentifier = qid;
            obs.QuestionText = qtxt;


            // list names of all people assigned to the observation
            var othersList = (from a in oi.Finding.FINDING_CONTACT
                              join b in _context.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals b.Assessment_Contact_Id
                              select FormatName(b.FirstName, b.LastName)).ToList();
            obs.Assignees = string.Join(",", othersList);


            return obs;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
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
        public MaturityReportData.MaturityModel GetBasicMaturityModel()
        {
            var query = (
                from amm in _context.AVAILABLE_MATURITY_MODELS
                join mm in _context.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                where amm.Assessment_Id == _assessmentId
                select new { amm, mm }
                ).FirstOrDefault();


            var response = new MaturityReportData.MaturityModel()
            {
                MaturityModelName = query.mm.Model_Name,
                TargetLevel = null
            };

            var asl = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == _assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();

            if (asl != null)
            {
                response.TargetLevel = int.Parse(asl.Standard_Specific_Sal_Level);
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<MaturityReportData.MaturityModel> GetMaturityModelData()
        {
            List<MaturityQuestion> mat_questions = new List<MaturityQuestion>();
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
                && asl.Level_Name == Constants.Constants.MaturityLevel
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
                MaturityQuestion newQuestion = new MaturityQuestion();
                newQuestion.Mat_Question_Id = queryItem.mq.Mat_Question_Id;
                newQuestion.Question_Title = queryItem.mq.Question_Title;
                newQuestion.Question_Text = queryItem.mq.Question_Text;
                newQuestion.Supplemental_Info = queryItem.mq.Supplemental_Info;
                newQuestion.Examination_Approach = queryItem.mq.Examination_Approach;
                newQuestion.Grouping_Id = queryItem.mq.Grouping_Id ?? 0;
                newQuestion.Parent_Question_Id = queryItem.mq.Parent_Question_Id;
                newQuestion.Maturity_Level = queryItem.mq.Maturity_Level_Id;
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

    }
}