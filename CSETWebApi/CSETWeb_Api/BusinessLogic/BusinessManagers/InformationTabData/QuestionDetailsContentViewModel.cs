//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using CSET_Main.Data.ControlData;
using CSET_Main.Data.ControlData.DiagramSymbolPalette;
using CSET_Main.Questions.InformationTabData;
using CSET_Main.Questions.POCO;
using CSET_Main.Questions.QuestionList;
using CSET_Main.Common.EnumHelper;
using CSET_Main.Data.AssessmentData;
using CSETWeb_Api.Data.ControlData;
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;
using DataLayerCore.Model;

namespace CSET_Main.Views.Questions.QuestionDetails
{
    /// <summary>
    /// 
    /// </summary>
    public class QuestionDetailsContentViewModel
    {

        private int selectedStandardTabIndex;
        public int SelectedStandardTabIndex
        {
            get { return selectedStandardTabIndex; }
            set { selectedStandardTabIndex = value;  }
        }


        private string noQuestionInformationText;
        public string NoQuestionInformationText
        {
            get { return noQuestionInformationText; }
            set { noQuestionInformationText = value;  }
        }

        private bool showQuestionDetailTab;
        public bool ShowQuestionDetailTab
        {
            get { return showQuestionDetailTab; }
            set { showQuestionDetailTab = value;  }
        }

        private bool isDetailAndInfo;
        public bool IsDetailAndInfo
        {
            get { return isDetailAndInfo; }
            set { isDetailAndInfo = value;  }
        }

        private bool isNoQuestion;
        public bool IsNoQuestion
        {
            get { return isNoQuestion; }
            set { isNoQuestion = value;  }
        }

        private int selectedTabIndex;
        public int SelectedTabIndex
        {
            get { return selectedTabIndex; }
            set { selectedTabIndex = value;  }
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
        private CSET_Context DataContext { get; }


        /// <summary>
        /// List contains only the title, finding_id and answer id
        /// call finding details for complete finding information
        /// </summary>
        public List<Finding> Findings { get; private set; }


        /// <summary>
        /// A list of documents attached to the answer.
        /// </summary>
        public List<Document> Documents { get; private set; }
        public bool Is_Component { get; private set; }



        /// <summary>
        /// 
        /// </summary>
        private IStandardSpecficLevelRepository levelManager;


        /// <summary>
        /// may need to add ISymbolRepository symbolRepository back into the constructor.
        /// </summary>
        /// <param name="levelManager"></param>
        /// <param name="informationTabBuilder"></param>
        /// <param name="datacontext"></param>
        public QuestionDetailsContentViewModel(
                                                IStandardSpecficLevelRepository levelManager,
                                                InformationTabBuilder informationTabBuilder,
                                                CSET_Context datacontext)
        {
            this.DataContext = datacontext;
            //this.symbolRepository = symbolRepository;
            this.informationTabBuilder = informationTabBuilder;
            this.levelManager = levelManager;
            this.NoQuestionInformationText = "No Question/Requirement information to show.";
            this.IsNoQuestion = true;
            ListTabs = new List<QuestionInformationTabData>();
        }

        

        internal void SetQuestionInfoTabToEmpty()
        {
            this.IsDetailAndInfo = false;        
            this.IsNoQuestion = true;       
        }
        
        internal List<QuestionInformationTabData> getQuestionDetails(int? questionId, int assessmentId, bool IsComponent)
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
                AssessmentModeData mode = new AssessmentModeData(this.DataContext, assessmentId);
                bool IsRequirement = IsComponent ? !IsComponent : mode.IsRequirement;
                var newqp = this.DataContext.NEW_QUESTION.Where(q => q.Question_Id == questionId).FirstOrDefault();
                var newAnswer = this.DataContext.ANSWER.Where(a => a.Question_Or_Requirement_Id == questionId 
                    && a.Is_Requirement == IsRequirement  && a.Assessment_Id == assessmentId).FirstOrDefault();
                var gettheselectedsets = this.DataContext.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId);

                if (newAnswer == null)                    
                {
                    newAnswer = new ANSWER()
                    {
                        Is_Requirement = IsRequirement,
                        Question_Or_Requirement_Id = questionId ?? 0,
                        Answer_Text = AnswerEnum.UNANSWERED.GetStringAttribute(),
                        Mark_For_Review = false,
                        Reviewed = false,                        
                        Is_Component = false
                    };
                    DataContext.ANSWER.Add(newAnswer);                    
                }
                var qp = new QuestionPoco(newAnswer, newqp);
                qp.DictionaryStandards = (from a in this.DataContext.AVAILABLE_STANDARDS
                                          join b in this.DataContext.SETS on a.Set_Name equals b.Set_Name
                                          where a.Selected == true
                                          && a.Assessment_Id == assessmentId
                                          select b
                                         ).ToDictionary(x => x.Set_Name, x=> x);

                qp.DefaultSetName = qp.DictionaryStandards.Keys.FirstOrDefault();
                qp.SetName = qp.DictionaryStandards.Keys.FirstOrDefault();
                LoadData(qp,assessmentId);

                // Get any findings/discoveries for the question
                FindingsViewModel fm = new FindingsViewModel(this.DataContext, assessmentId, newAnswer.Answer_Id);
                this.Findings = fm.AllFindings();

                // Get any documents attached to the question
                DocumentManager dm = new DocumentManager(assessmentId);
                this.Documents = dm.GetDocumentsForAnswer(newAnswer.Answer_Id);

                //Get any components

            }

            return ListTabs;            
        }

        private QuestionPoco buildQuestionPocoForNonExistentAnswer(int? questionId, int assessmentId)
        {
            QuestionPoco req = null;
            /***
             * TODO:  this is where we will build each question as it comes in. 
             * The cases are all defined here we just need to pull the mode from 
             * the database (determine the question mode type. Calculate the questions type based on the following
             * rules 
             * 1. I'm a simple question, (questions mode not in framework or components)
             * 2. I have a question_sets record of type framework 
             * 3. I have a component sets record and I either have a guid or not
             * 4. I'm a requirement. (requirements mode not in framework or components)
             */

            //if (question.IsFramework)
            //{





            //}
            //else if (question.IsQuestion && !question.IsComponent)
            //{

            //}
            //else if (question.IsComponent)
            //{

            //}
            //else if (question.IsRequirement)
            //{
            //    var rlist = DataContext.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == questionId).ToList();
            //    var tmpreq = (from r in DataContext.NEW_REQUIREMENT
            //                  join a in DataContext.ANSWER on r.Requirement_Id equals a.Question_Or_Requirement_Id
            //                  where r.Requirement_Id == questionId && a.Assessment_Id == assessmentId && a.Is_Requirement == true
            //                  select new QuestionPoco(a, r, levelManager.GetRequirementLevel(rlist)));
            //}
            return req;
        }

        private Dictionary<int, COMPONENT_SYMBOLS> symbolInfo;

        private void LoadData(QuestionPoco question, int assessment_id)
        {
            List<QuestionInformationTabData> list = new List<QuestionInformationTabData>();

            bool isRequirement = question.IsRequirement;
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
            else if (question.IsQuestion && !question.IsComponent)
            {
                QuestionInfoData questionInfoData = new QuestionInfoData()
                {
                    QuestionID = question.Question_or_Requirement_ID,
                    Set = question.SetName==null?null:question.DictionaryStandards[question.SetName],
                    Sets = question.DictionaryStandards,
                    Question=question.Question,
                    Requirement=question.NEW_REQUIREMENT??question.Question.NEW_REQUIREMENTs().FirstOrDefault(t=>t.REQUIREMENT_SETS.Select(s=>s.Set_Name).Contains(question.SetName??question.DictionaryStandards.Keys.FirstOrDefault()))
                };                
                list = informationTabBuilder.CreateQuestionInformationTab(questionInfoData);
            }
            else if (question.IsComponent)
            {
                var stuff = from a in this.DataContext.Answer_Components_Exploded
                            join l in this.DataContext.UNIVERSAL_SAL_LEVEL on a.SAL equals l.Full_Name_Sal
                            where a.Assessment_Id == assessment_id && a.Question_Id == question.Question_or_Requirement_ID
                            select new { a.Component_Symbol_Id, a.SAL, l.Sal_Level_Order };

                Dictionary<int, ComponentTypeSalData> dictionaryComponentTypes = new Dictionary<int, ComponentTypeSalData>();
                foreach(var item in stuff.ToList())
                {
                    ComponentTypeSalData salData;
                    if (dictionaryComponentTypes.TryGetValue(item.Component_Symbol_Id,out salData)){
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
                    symbolInfo = this.DataContext.COMPONENT_SYMBOLS
                    .ToDictionary(x => x.Component_Symbol_Id, data => data);


                //select component_type, ComponentName, SAL from Answer_Components_Exploded
                //where Assessment_Id = 6 and question_id = 1586
                ;
                ComponentQuestionInfoData componentQuestionInfoData = new ComponentQuestionInfoData()
                {
                    QuestionID = question.Question_or_Requirement_ID,
                    Question = question.Question,
                    Set = this.DataContext.SETS.Where(x => x.Set_Name == "Components").First(),                    
                    DictionaryComponentTypes = dictionaryComponentTypes,
                    DictionaryComponentInfo = symbolInfo
                };                
                list = informationTabBuilder.CreateComponentInformationTab(componentQuestionInfoData);
            }
            else if (question.IsRequirement)
            {
                var sets = question.GetRequirementSets().Distinct().ToDictionary(s=>s.Set_Name);

                var set = question.GetRequirementSet().Set_Name;
                
                if (question.NEW_REQUIREMENT == null)
                {
                    //var rs = this.DataContext.REQUIREMENT_QUESTIONS_SETS.Where(x => x.Question_Id == question.Question_or_Requirement_ID && x.Set_Name == set).First();
                    question.NEW_REQUIREMENT = this.DataContext.NEW_REQUIREMENT.Where(x => x.Requirement_Id == question.Question_or_Requirement_ID).FirstOrDefault();
                }
                RequirementInfoData reqInfoData = new RequirementInfoData()
                {
                    RequirementID = question.Question_or_Requirement_ID,
                    SetName = set,
                    Category = question.Category,
                    Sets = sets,
                    Requirement=question.NEW_REQUIREMENT
                };                
                list = informationTabBuilder.CreateRequirementInformationTab(reqInfoData, levelManager);
            }
          

            SetTabDataList(list);
            this.Is_Component = question.IsComponent;
        }

        internal async void SetFrameworkQuestionInfoTab(CSET_Main.Questions.QuestionList.FrameworkQuestionItem questionViewItem)
        {
            List<QuestionInformationTabData> list = new List<QuestionInformationTabData>();

            RelatedQuestionInfoData questionInfoData = new RelatedQuestionInfoData()
            {
                Category = questionViewItem.QuestionGroupHeading.Question_Group_Heading1,
                QuestionID = questionViewItem.RequirementID,
                Question=questionViewItem.Question,
                Set = questionViewItem.SetName,
                Sets = questionViewItem.GetSetAsDictionary()
            };
            Task<List<QuestionInformationTabData>> task = Task.Run<List<QuestionInformationTabData>>(() => informationTabBuilder.CreateRelatedQuestionInformationTab(questionInfoData));
            list = await task;

            SetTabDataList(list,true);
        }

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

        internal void ShowFrameworkQuestionInfo(FrameworkQuestionItem questionViewItem)
        {
            this.IsNoQuestion = false;   
            this.IsDetailAndInfo = true;
            this.ShowQuestionDetailTab = false;
            SetFrameworkQuestionInfoTab(questionViewItem);      
        }

    }
}


