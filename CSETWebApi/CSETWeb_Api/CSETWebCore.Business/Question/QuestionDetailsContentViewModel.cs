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
using Newtonsoft.Json;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Model.Observations;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Business.Question
{
    public class QuestionDetailsContentViewModel
    {
        private int selectedStandardTabIndex;
        public int SelectedStandardTabIndex
        {
            get { return selectedStandardTabIndex; }
            set { selectedStandardTabIndex = value; }
        }


        private string noQuestionInformationText;
        public string NoQuestionInformationText
        {
            get { return noQuestionInformationText; }
            set { noQuestionInformationText = value; }
        }

        private bool showQuestionDetailTab;
        public bool ShowQuestionDetailTab
        {
            get { return showQuestionDetailTab; }
            set { showQuestionDetailTab = value; }
        }

        private bool isDetailAndInfo;
        public bool IsDetailAndInfo
        {
            get { return isDetailAndInfo; }
            set { isDetailAndInfo = value; }
        }

        private bool isNoQuestion;
        public bool IsNoQuestion
        {
            get { return isNoQuestion; }
            set { isNoQuestion = value; }
        }

        private int selectedTabIndex;
        public int SelectedTabIndex
        {
            get { return selectedTabIndex; }
            set { selectedTabIndex = value; }
        }


        /// <summary>
        /// 
        /// </summary>
        public List<QuestionInformationTabData> ListTabs { get; set; }

        /// <summary>
        /// 
        /// </summary>
        private InformationTabBuilder informationTabBuilder;


        /// <summary>
        /// 
        /// </summary>
        private CSETContext _context { get; }


        /// <summary>
        /// List contains only the title, finding_id and answer id
        /// call finding details for complete observation information
        /// </summary>
        public List<Observation> Observations { get; private set; }


        /// <summary>
        /// A list of documents attached to the answer.
        /// </summary>
        public List<Model.Document.Document> Documents { get; private set; }
        public bool Is_Component { get; private set; }



        /// <summary>
        /// 
        /// </summary>
        private IStandardSpecficLevelRepository levelManager;

        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _document;

        /// <summary>
        /// may need to add ISymbolRepository symbolRepository back into the constructor.
        /// </summary>
        /// <param name="levelManager"></param>
        /// <param name="informationTabBuilder"></param>
        /// <param name="datacontext"></param>
        public QuestionDetailsContentViewModel(
                                                IStandardSpecficLevelRepository levelManager,
                                                InformationTabBuilder informationTabBuilder,
                                                CSETContext datacontext, ITokenManager tokenManager,
                                                IDocumentBusiness document)
        {
            //this.symbolRepository = symbolRepository;
            this.informationTabBuilder = informationTabBuilder;
            this.levelManager = levelManager;
            this.NoQuestionInformationText = "No Question/Requirement information to show.";
            this.IsNoQuestion = true;
            ListTabs = new List<QuestionInformationTabData>();
            _tokenManager = tokenManager;
            _document = document;
            _context = datacontext;
        }


        /// <summary>
        /// 
        /// </summary>
        internal void SetQuestionInfoTabToEmpty()
        {
            this.IsDetailAndInfo = false;
            this.IsNoQuestion = true;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionId"></param>
        /// <param name="assessmentId"></param>
        /// <param name="IsComponent"></param>
        /// <param name="IsMaturity"></param>
        /// <returns></returns>
        internal List<QuestionInformationTabData> GetQuestionDetails(int? questionId, int assessmentId, bool IsComponent, bool IsMaturity)
        {
            if (questionId == null)
            {
                SetQuestionInfoTabToEmpty();
                return ListTabs;
            }

            this.IsNoQuestion = false;
            this.IsDetailAndInfo = true;
            this.ShowQuestionDetailTab = false;


            if (questionId != null)
            {
                AssessmentModeData mode = new AssessmentModeData(this._context, _tokenManager);
                bool IsQuestion = mode.IsQuestion;
                bool IsRequirement = IsComponent ? !IsComponent : mode.IsRequirement;
                var newqp = this._context.NEW_QUESTION.Where(q => q.Question_Id == questionId).FirstOrDefault();
                var newAnswer = this._context.ANSWER.Where(a => a.Question_Or_Requirement_Id == questionId
                    && a.Is_Requirement == IsRequirement && a.Assessment_Id == assessmentId).FirstOrDefault();
                var gettheselectedsets = this._context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId);



                if (newAnswer == null)
                {
                    newAnswer = new ANSWER()
                    {
                        Is_Requirement = IsRequirement,
                        Is_Maturity = IsMaturity,
                        Question_Or_Requirement_Id = questionId ?? 0,
                        Answer_Text = AnswerEnum.UNANSWERED.GetStringAttribute(),
                        Mark_For_Review = false,
                        Reviewed = false,
                        Is_Component = false
                    };

                    // set the question type
                    newAnswer.Question_Type = "Question";
                    if ((bool)newAnswer.Is_Requirement)
                    {
                        newAnswer.Question_Type = "Requirement";
                    }
                    if ((bool)newAnswer.Is_Maturity)
                    {
                        newAnswer.Question_Type = "Maturity";
                    }
                    if ((bool)newAnswer.Is_Component)
                    {
                        newAnswer.Question_Type = "Component";
                    }

                    _context.ANSWER.Add(newAnswer);
                }

                QuestionPoco qp = null;

                if (IsMaturity)
                {
                    var matQuestion = this._context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == questionId).FirstOrDefault();
                    qp = new QuestionPoco(_context, newAnswer, matQuestion);
                }
                else
                {
                    qp = new QuestionPoco(_context, newAnswer, newqp);
                }

                qp.DictionaryStandards = (from a in this._context.AVAILABLE_STANDARDS
                                          join b in this._context.SETS on a.Set_Name equals b.Set_Name
                                          where a.Selected == true
                                          && a.Assessment_Id == assessmentId
                                          select b
                                         ).ToDictionary(x => x.Set_Name, x => x);

                qp.DefaultSetName = qp.DictionaryStandards.Keys.FirstOrDefault();
                qp.SetName = qp.DictionaryStandards.Keys.FirstOrDefault();

                LoadData(qp, assessmentId);

                // Get any observations for the question
                var fm = new ObservationsManager(this._context, assessmentId);
                this.Observations = fm.AllObservations(newAnswer.Answer_Id);

                // Get any documents attached to the question
                _document.SetUserAssessmentId(assessmentId);
                this.Documents = _document.GetDocumentsForAnswer(newAnswer.Answer_Id);

                //Get any components

            }

            var json = JsonConvert.SerializeObject(ListTabs);
            return ListTabs;
        }


        private Dictionary<int, COMPONENT_SYMBOLS> symbolInfo;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="question"></param>
        /// <param name="assessment_id"></param>
        private void LoadData(QuestionPoco question, int assessment_id)
        {
            List<QuestionInformationTabData> list = new List<QuestionInformationTabData>();

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
                list = informationTabBuilder.CreateFrameworkInformationTab(frameworkData);
            }
            else if (question.IsMaturity)
            {
                MaturityQuestionInfoData maturityData = new MaturityQuestionInfoData()
                {
                    QuestionID = question.MaturityQuestion.Mat_Question_Id,
                    MaturityQuestion = question.MaturityQuestion
                };
                list = informationTabBuilder.CreateMaturityInformationTab(maturityData);
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
                list = informationTabBuilder.CreateQuestionInformationTab(questionInfoData);
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
                            join l in this._context.UNIVERSAL_SAL_LEVEL on a.SAL equals l.Full_Name_Sal
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
                if (symbolInfo == null)
                    symbolInfo = this._context.COMPONENT_SYMBOLS
                    .ToDictionary(x => x.Component_Symbol_Id, data => data);


                //select component_type, ComponentName, SAL from Answer_Components_Exploded
                //where Assessment_Id = 6 and question_id = 1586
                ;
                ComponentQuestionInfoData componentQuestionInfoData = new ComponentQuestionInfoData()
                {
                    QuestionID = question.Question_or_Requirement_ID,
                    Question = question.Question,
                    Set = this._context.SETS.Where(x => x.Set_Name == "Components").First(),
                    DictionaryComponentTypes = dictionaryComponentTypes,
                    DictionaryComponentInfo = symbolInfo
                };
                list = informationTabBuilder.CreateComponentInformationTab(componentQuestionInfoData);
            }
            else if (question.IsRequirement)
            {
                var sets = question.GetRequirementSets().Distinct().ToDictionary(s => s.Set_Name);

                var set = question.GetRequirementSet().Set_Name;

                if (question.NEW_REQUIREMENT == null)
                {
                    //var rs = this.DataContext.REQUIREMENT_QUESTIONS_SETS.Where(x => x.Question_Id == question.Question_or_Requirement_ID && x.Set_Name == set).First();
                    question.NEW_REQUIREMENT = this._context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == question.Question_or_Requirement_ID).FirstOrDefault();
                }
                RequirementInfoData reqInfoData = new RequirementInfoData()
                {
                    RequirementID = question.Question_or_Requirement_ID,
                    SetName = set,
                    Category = question.Category,
                    Sets = sets,
                    Requirement = question.NEW_REQUIREMENT
                };

                reqInfoData.Requirement.REQUIREMENT_LEVELS = this._context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == question.Question_or_Requirement_ID).ToList();

                list = informationTabBuilder.CreateRequirementInformationTab(reqInfoData, levelManager);
            }



            SetTabDataList(list);
            this.Is_Component = question.IsComponent;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionViewItem"></param>
        internal async void SetFrameworkQuestionInfoTab(FrameworkQuestionItem questionViewItem)
        {
            List<QuestionInformationTabData> list = new List<QuestionInformationTabData>();

            RelatedQuestionInfoData questionInfoData = new RelatedQuestionInfoData()
            {
                Category = questionViewItem.QuestionGroupHeading.Question_Group_Heading1,
                QuestionID = questionViewItem.RequirementID,
                Question = questionViewItem.Question,
                Set = questionViewItem.SetName,
                Sets = questionViewItem.GetSetAsDictionary()
            };
            Task<List<QuestionInformationTabData>> task = Task.Run<List<QuestionInformationTabData>>(() => informationTabBuilder.CreateRelatedQuestionInformationTab(questionInfoData));
            list = await task;

            SetTabDataList(list, true);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="list"></param>
        /// <param name="isFrameworkInfo"></param>
        private void SetTabDataList(List<QuestionInformationTabData> list, bool isFrameworkInfo = false)
        {
            this.ListTabs = list;
            int previousSelectIndexIndex = SelectedTabIndex;

            if (previousSelectIndexIndex > 0)
            {
                if (previousSelectIndexIndex > (ListTabs.Count - 1))
                {
                    if (ListTabs.Count >= 2)
                        SelectedTabIndex = 1;
                    else
                        SelectedTabIndex = 0;
                }
                else
                    SelectedTabIndex = previousSelectIndexIndex;
            }
            else
            {
                SelectedTabIndex = 0;
            }

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionViewItem"></param>
        internal void ShowFrameworkQuestionInfo(FrameworkQuestionItem questionViewItem)
        {
            this.IsNoQuestion = false;
            this.IsDetailAndInfo = true;
            this.ShowQuestionDetailTab = false;
            SetFrameworkQuestionInfoTab(questionViewItem);
        }
    }
}
