//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Enum.EnumHelper;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Question;
using Newtonsoft.Json;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Question
{
    public class QuestionDetailsBusiness
    {
        /// <summary>
        /// 
        /// </summary>
        private readonly IStandardSpecficLevelRepository _levelManager;
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _documentBusiness;
        private InformationTabBuilder _informationTabBuilder;


        private QuestionDetails response;


        /// <summary>
        /// may need to add ISymbolRepository symbolRepository back into the constructor.
        /// </summary>
        public QuestionDetailsBusiness(
            IStandardSpecficLevelRepository levelManager,
            InformationTabBuilder informationTabBuilder,
            CSETContext context,
            ITokenManager tokenManager,
            IDocumentBusiness documentBusiness)
        {
            // create the response model
            response = new QuestionDetails();
            response.NoQuestionInformationText = "No Question/Requirement information to show.";
            response.IsNoQuestion = true;
            response.ListTabs = new List<QuestionInformationTabData>();

            // set injected services
            _context = context;
            _informationTabBuilder = informationTabBuilder;
            _levelManager = levelManager;
            _tokenManager = tokenManager;
            _documentBusiness = documentBusiness;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public QuestionDetails GetQuestionDetails(int? questionId, int assessmentId, string questionType)
        {
            if (_context.MATURITY_QUESTION_TYPES.ToList().Exists(x => x.Mat_Question_Type.Equals(questionType, StringComparison.OrdinalIgnoreCase)))
            {
                questionType = "Maturity";
            }

            _documentBusiness.SetUserAssessmentId(assessmentId);
            if (questionId == null)
            {
                SetQuestionInfoTabToEmpty();
                return response;
            }

            response.AssessmentId = assessmentId;
            response.QuestionId = (int)questionId;
            response.IsNoQuestion = false;
            response.IsDetailAndInfo = true;
            response.ShowQuestionDetailTab = false;


            if (questionId != null)
            {
                AssessmentModeData mode = new AssessmentModeData(_context, _tokenManager);
                bool IsQuestion = mode.IsQuestion;
                // bool IsRequirement = IsComponent ? !IsComponent : mode.IsRequirement;
                var newqp = _context.NEW_QUESTION.Where(q => q.Question_Id == questionId).FirstOrDefault();
                var newAnswer = this._context.ANSWER.Where(a =>
                    a.Question_Or_Requirement_Id == questionId
                    && a.Assessment_Id == assessmentId
                    && a.Question_Type == questionType).FirstOrDefault();


                if (newAnswer == null)
                {
                    newAnswer = new ANSWER()
                    {
                        Question_Type = questionType,
                        Question_Or_Requirement_Id = questionId ?? 0,
                        Answer_Text = AnswerEnum.UNANSWERED.GetStringAttribute(),
                        Mark_For_Review = false,
                        Reviewed = false,
                        Is_Component = false
                    };

                    // set the question type booleans, for consistency
                    newAnswer.Is_Component = newAnswer.Question_Type == "Component";
                    newAnswer.Is_Requirement = newAnswer.Question_Type == "Requirement";
                    newAnswer.Is_Maturity = newAnswer.Question_Type == "Maturity";

                    _context.ANSWER.Add(newAnswer);
                }

                QuestionPoco qp = null;

                if (questionType == "Maturity")
                {
                    var matQuestion = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == questionId).FirstOrDefault();
                    qp = new QuestionPoco(_context, newAnswer, matQuestion);
                }
                else
                {
                    qp = new QuestionPoco(_context, newAnswer, newqp);
                }

                qp.DictionaryStandards = (from a in _context.AVAILABLE_STANDARDS
                                          join b in _context.SETS on a.Set_Name equals b.Set_Name
                                          where a.Selected == true
                                          && a.Assessment_Id == assessmentId
                                          select b
                                         ).ToDictionary(x => x.Set_Name, x => x);

                qp.DefaultSetName = qp.DictionaryStandards.Keys.FirstOrDefault();
                qp.SetName = qp.DictionaryStandards.Keys.FirstOrDefault();

                LoadData(qp, assessmentId);

                // Get any observations for the question
                ObservationsManager obsMan = new(_context, assessmentId);
                response.Observations = obsMan.AllObservations(newAnswer.Answer_Id);

                // Get any documents attached to the question
                response.Documents = _documentBusiness.GetDocumentsForAnswer(newAnswer.Answer_Id);

                //Get any components

            }

            // var json = JsonConvert.SerializeObject(response.ListTabs);

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        internal void SetQuestionInfoTabToEmpty()
        {
            response.IsDetailAndInfo = false;
            response.IsNoQuestion = true;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="question"></param>
        /// <param name="assessment_id"></param>
        private void LoadData(QuestionPoco question, int assessment_id)
        {
            var list = new List<QuestionInformationTabData>();

            if (question.IsFramework)
            {
                FrameworkInfoData frameworkData = new FrameworkInfoData()
                {
                    SupplementalInfo = question.ProfileQuestionData.SupplementalInfo,
                    SetName = question.GetRequirementSet().Set_Name,
                    IsCustomQuestion = question.ProfileQuestionData.IsCustomQuestion,
                    References = question.ProfileQuestionData.References,
                    Title = question.ProfileQuestionData.Category.ProfileFunction.Function_ID + "." + question.ProfileQuestionData.Category.SubLabel + "-" + question.QuestionNumber,
                    Category = question.ProfileQuestionData.CategoryHeading,
                    RequirementID = question.Question_or_Requirement_ID
                };
                list = _informationTabBuilder.CreateFrameworkInformationTab(frameworkData);
            }
            else if (question.IsMaturity)
            {
                MaturityQuestionInfoData maturityData = new MaturityQuestionInfoData()
                {
                    QuestionID = question.MaturityQuestion.Mat_Question_Id,
                    MaturityQuestion = question.MaturityQuestion
                };
                list = _informationTabBuilder.CreateMaturityInformationTab(maturityData);
            }
            else if (question.IsQuestion && !question.IsComponent)
            {
                QuestionInfoData questionInfoData = new QuestionInfoData()
                {
                    QuestionID = question.Question_or_Requirement_ID,
                    Set = question.SetName == null ? null : question.DictionaryStandards[question.SetName],
                    Sets = question.DictionaryStandards,
                    Question = question.Question,
                    Requirement = question.NEW_REQUIREMENT ?? question.Question.NEW_REQUIREMENTs(_context).FirstOrDefault(t => t.REQUIREMENT_SETS.Select(s => s.Set_Name).Contains(question.SetName ?? question.DictionaryStandards.Keys.FirstOrDefault()))
                };
                list = _informationTabBuilder.CreateQuestionInformationTab(questionInfoData);
            }
            else if (question.IsComponent)
            {
                List<usp_getExplodedComponent> exploded = null;

                _context.LoadStoredProc("[usp_getExplodedComponent]")
                  .WithSqlParam("assessment_id", assessment_id)
                  .ExecuteStoredProc((handler) =>
                  {
                      exploded = handler.ReadToList<usp_getExplodedComponent>().ToList();
                  });

                var stuff = from a in exploded
                            join l in _context.UNIVERSAL_SAL_LEVEL on a.SAL equals l.Full_Name_Sal
                            where a.Assessment_Id == assessment_id && a.Question_Id == question.Question_or_Requirement_ID
                            select new { a.Component_Symbol_Id, a.SAL, l.Sal_Level_Order };

                Dictionary<int, ComponentTypeSalData> dictionaryComponentTypes = new Dictionary<int, ComponentTypeSalData>();
                foreach (var item in stuff.ToList())
                {
                    ComponentTypeSalData salData;

                    if (dictionaryComponentTypes.TryGetValue(item.Component_Symbol_Id, out salData))
                    {
                        salData.SALLevels.Add(item.Sal_Level_Order);
                    }
                    else
                    {
                        HashSet<int> SALLevels = new HashSet<int>();
                        SALLevels.Add(item.Sal_Level_Order);
                        salData = new ComponentTypeSalData()
                        {
                            Component_Symbol_Id = item.Component_Symbol_Id,
                            SALLevels = SALLevels
                        };

                        dictionaryComponentTypes.Add(item.Component_Symbol_Id, salData);
                    }
                }
                if (response.SymbolInfo == null)
                    response.SymbolInfo = _context.COMPONENT_SYMBOLS
                    .ToDictionary(x => x.Component_Symbol_Id, data => data);


                //select component_type, ComponentName, SAL from Answer_Components_Exploded
                //where Assessment_Id = 6 and question_id = 1586
                ;
                ComponentQuestionInfoData componentQuestionInfoData = new ComponentQuestionInfoData()
                {
                    QuestionID = question.Question_or_Requirement_ID,
                    Question = question.Question,
                    Set = _context.SETS.Where(x => x.Set_Name == "Components").First(),
                    DictionaryComponentTypes = dictionaryComponentTypes,
                    DictionaryComponentInfo = response.SymbolInfo
                };
                list = _informationTabBuilder.CreateComponentInformationTab(componentQuestionInfoData);
            }
            else if (question.IsRequirement)
            {
                var sets = question.GetRequirementSets().Distinct().ToDictionary(s => s.Set_Name);

                var set = question.GetRequirementSet().Set_Name;

                if (question.NEW_REQUIREMENT == null)
                {
                    question.NEW_REQUIREMENT = _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == question.Question_or_Requirement_ID).FirstOrDefault();
                }
                RequirementInfoData reqInfoData = new RequirementInfoData()
                {
                    RequirementID = question.Question_or_Requirement_ID,
                    SetName = set,
                    Category = question.Category,
                    Sets = sets,
                    Requirement = question.NEW_REQUIREMENT
                };

                reqInfoData.Requirement.REQUIREMENT_LEVELS = _context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == question.Question_or_Requirement_ID).ToList();

                list = _informationTabBuilder.CreateRequirementInformationTab(reqInfoData, _levelManager);
            }



            SetTabDataList(list);
            response.Is_Component = question.IsComponent;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="list"></param>
        /// <param name="isFrameworkInfo"></param>
        private void SetTabDataList(List<QuestionInformationTabData> list, bool isFrameworkInfo = false)
        {
            response.ListTabs = list;
            int previousSelectIndexIndex = response.SelectedTabIndex;

            if (previousSelectIndexIndex > 0)
            {
                if (previousSelectIndexIndex > (response.ListTabs.Count - 1))
                {
                    if (response.ListTabs.Count >= 2)
                        response.SelectedTabIndex = 1;
                    else
                        response.SelectedTabIndex = 0;
                }
                else
                    response.SelectedTabIndex = previousSelectIndexIndex;
            }
            else
            {
                response.SelectedTabIndex = 0;
            }

        }
    }
}
