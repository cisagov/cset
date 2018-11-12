//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data.ControlData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Collections.ObjectModel;
using CSET_Main.Data.ControlData.DiagramSymbolPalette;
using System.Diagnostics;
using CSET_Main.Questions.ComponentOverride;
using DataLayer;
using CSET_Main.Questions.POCO;
using CSET_Main.Questions.QuestionList;
using CSET_Main.Data.AssessmentData;
using CSET_Main.Common;

namespace CSET_Main.Questions.InformationTabData
{
    public class QuestionInformationTabData : TabObject
    {
        public String RequirementFrameworkTitle { get; set; }
        public String RelatedFrameworkCategory { get; set; }
        public bool ShowRequirementFrameworkTitle { get; set; }
        public bool ShowRelatedFrameworkCategory { get { return true; } set { } }
        public int Question_or_Requirement_Id { get; set; }


        public RequirementTabData RequirementsData { get; set; }
        public List<CustomDocument> ResourceDocumentList { get; set; }
        public List<CustomDocument> SourceDocumentsList { get; set; }
        public string References { get; set; }

        /// <summary>
        /// Contains a list of multiServiceComponent types for the current multiServiceComponent question
        /// </summary>
        private List<ComponentOverrideLinkInfo> componentTypes;
        public List<ComponentOverrideLinkInfo> ComponentTypes
        {
            get
            {
                return componentTypes;
            }
            set
            {
                componentTypes = value;

            }
        }

        /// <summary>
        /// Property to allow for setting visibility on the multiServiceComponent types in the components tab
        /// </summary>     
        public bool ComponentVisibility { get; set; }

        private bool questionsVisible;
        public bool QuestionsVisible
        {
            get { return questionsVisible; }
            set { questionsVisible = value; }
        }

        private bool showSALLevel;
        public bool ShowSALLevel
        {
            get { return showSALLevel; }
            set { showSALLevel = value; }
        }

        private bool showRequirementStandards;
        public bool ShowRequirementStandards
        {
            get { return showRequirementStandards; }
            set { showRequirementStandards = value; }
        }

        private ObservableCollection<FrameworkQuestionItem> frameworkQuestions;
        public ObservableCollection<FrameworkQuestionItem> FrameworkQuestions
        {
            get { return frameworkQuestions; }
            set { frameworkQuestions = value; }
        }

        private String levelName;
        public String LevelName
        {
            get { return levelName; }
            set { levelName = value; }
        }


        public bool IsCustomQuestion
        {
            get;
            set;
        }

        public bool IsComponent { get; set; }

        public List<String> SetsList { get; set; }
        public List<String> QuestionsList { get; set; }

        private bool showNoQuestionInformation;
        public bool ShowNoQuestionInformation
        {
            get { return showNoQuestionInformation; }
            set { showNoQuestionInformation = value; }
        }

        public QuestionInformationTabData()
        {
            SourceDocumentsList = new List<CustomDocument>();
            this.ComponentVisibility = false;
            this.ComponentTypes = new List<ComponentOverrideLinkInfo>();
            this.FrameworkQuestions = new ObservableCollection<FrameworkQuestionItem>();

        }

        public void BuildQuestionTab(QuestionInfoData infoData, SET set, CSETWebEntities controlContext)
        {
            ShowRequirementFrameworkTitle = true;
            BuildFromNewQuestion(infoData, set, controlContext);
        }

        internal void BuildRelatedQuestionTab(RelatedQuestionInfoData questionInfoData, SET set, CSETWebEntities controlContext)
        {
            BuildFromNewQuestion(questionInfoData, set, controlContext);
            ShowRelatedFrameworkCategory = true;
            ShowRequirementFrameworkTitle = true;
            RelatedFrameworkCategory = questionInfoData.Category;
        }

        private NEW_QUESTION BuildFromNewQuestion(BaseQuestionInfoData infoData, SET set, CSETWebEntities controlContext)
        {
            NEW_QUESTION question = infoData.Question;
            NEW_REQUIREMENT requirement = null;
            RequirementTabData tabData = new RequirementTabData();
            String shortStandardName = set.Short_Name;
            HeaderName = shortStandardName;
            Question_or_Requirement_Id = infoData.QuestionID;

            this.LevelName = (from a in controlContext.NEW_QUESTION_SETS.Where(t => t.Question_Id == infoData.QuestionID && t.Set_Name == infoData.Set.Set_Name)
                              join l in controlContext.NEW_QUESTION_LEVELS on a.New_Question_Set_Id equals l.New_Question_Set_Id
                              join u in controlContext.UNIVERSAL_SAL_LEVEL on l.Universal_Sal_Level equals u.Universal_Sal_Level1
                              orderby u.Sal_Level_Order
                              select u.Full_Name_Sal).FirstOrDefault();

            // Gets requirements for the current standard (Set)
            IEnumerable<NEW_REQUIREMENT> requires=null;
            if (set.Is_Custom)
            {
                //Legacy only
                var tempRequires = new List<NEW_REQUIREMENT>();
                foreach (var setName in set.CUSTOM_STANDARD_BASE_STANDARD.Select(s => s.Base_Standard).ToList())
                {
                    tempRequires = tempRequires.Concat(question.NEW_REQUIREMENT.Where(t => t.REQUIREMENT_SETS.Select(s => s.Set_Name).Contains(setName)).ToList()).ToList();
                }
                requires = tempRequires;
            }
            if (requires == null || !requires.Any())
            {

                requires = from a in controlContext.NEW_REQUIREMENT
                           join b in controlContext.REQUIREMENT_QUESTIONS_SETS on a.Requirement_Id equals b.Requirement_Id
                           where b.Question_Id == infoData.QuestionID && b.Set_Name == set.Set_Name
                           select a;
            }
            
            requirement = requires.FirstOrDefault();
            if (requirement != null)
            {
                tabData.Set_Name = set.Set_Name;
                tabData.Text = FormatRequirementText(requirement.Requirement_Text);
                if (!IsComponent)
                    RequirementFrameworkTitle = requirement.Requirement_Title;


                RelatedFrameworkCategory = requirement.Standard_Sub_Category;

                if (RelatedFrameworkCategory == null)
                {
                    var query = from qgh in controlContext.QUESTION_GROUP_HEADING
                                join usch in controlContext.UNIVERSAL_SUB_CATEGORY_HEADINGS on qgh.Question_Group_Heading_Id equals usch.Question_Group_Heading_Id
                                join q in controlContext.NEW_QUESTION on usch.Heading_Pair_Id equals q.Heading_Pair_Id
                                where q.Question_Id == question.Question_Id
                                select qgh.Question_Group_Heading1;
                    RelatedFrameworkCategory = query.FirstOrDefault();
                }

                tabData.SupplementalInfo = requires.FirstOrDefault(s => !String.IsNullOrEmpty(s.Supplemental_Info))?.Supplemental_Info;
                tabData.SupplementalInfo = FormatSupplementalInfo(tabData.SupplementalInfo);

                BuildDocuments(requirement.Requirement_Id, controlContext);
            }
            QuestionsVisible = false;
            ShowRequirementStandards = false;
            ShowSALLevel = true;
            RequirementsData = tabData;
            return question;
        }



        public void BuildRequirementInfoTab(RequirementInfoData requirementData, IStandardSpecficLevelRepository levelManager, CSETWebEntities controlContext)
        {
            ShowRequirementFrameworkTitle = true;

            try
            {
                controlContext.Database.Connection.Open();
            }
            catch (Exception e)
            {
                //CSETLogger.Fatal(e.Message, e);
            }

            NEW_REQUIREMENT requirement = requirementData.Requirement;
            Question_or_Requirement_Id = requirement.Requirement_Id;

            this.SetsList = new List<string>(requirementData.Sets.Select(s => s.Value.Short_Name));
            this.QuestionsList = controlContext.NEW_QUESTION.Where(t => t.NEW_REQUIREMENT.Select(s => s.Requirement_Id).Contains(requirementData.RequirementID)).Select(x => x.Simple_Question).ToList();
            RequirementTabData tabData = new RequirementTabData();
            tabData.Text = FormatRequirementText(requirement.Requirement_Text);
            tabData.SupplementalInfo = FormatSupplementalInfo(requirement.Supplemental_Info);
            tabData.Set_Name = requirementData.SetName;

            RequirementsData = tabData;
            int requirement_id = requirement.Requirement_Id;
            var questions = requirement.NEW_QUESTION;
            SET set;
            if (!requirementData.Sets.TryGetValue(requirementData.SetName, out set))
            {
                set = controlContext.SETS.Where(x => x.Set_Name == requirementData.SetName).FirstOrDefault();
            }
            String shortStandardName = set.Short_Name;
            HeaderName = shortStandardName;
            if (!IsComponent)
                RequirementFrameworkTitle = requirement.Requirement_Title;

            RelatedFrameworkCategory = requirement.Standard_Sub_Category;

            if (requirementData.SetName == StandardManager.CNSSI_1253_DB || requirementData.SetName == StandardManager.CNSSI_ICS_PIT_DB
                || requirementData.SetName == StandardManager.CNSSI_ICS_V1_DB || requirementData.SetName == StandardManager.CNSSI_1253_V2_DB)
            {

                var levels = requirement.REQUIREMENT_LEVELS.Select(x => new
                {
                    FullName = levelManager.GetFullName(levelManager.GetStandard(x.Standard_Level), levelManager.GetLevelOrder(x.Standard_Level)),
                    LevelOrder = levelManager.GetLevelOrder(x.Standard_Level),
                    LevelType = x.Level_Type
                }).ToList();

                Tuple<int, string> availableLevel = Tuple.Create(-1, "None");
                Tuple<int, string> confidenceLevel = Tuple.Create(-1, "None");
                Tuple<int, string> integretityLevel = Tuple.Create(-1, "None");

                foreach (var item in levels)
                {
                    if (item.LevelType == "A")
                    {
                        if (availableLevel.Item1 == -1)
                        {
                            availableLevel = Tuple.Create(item.LevelOrder, item.FullName);
                        }
                        else
                        {
                            if (availableLevel.Item1 > item.LevelOrder)
                            {
                                availableLevel = Tuple.Create(item.LevelOrder, item.FullName);
                            }
                        }

                    }
                    else if (item.LevelType == "C")
                    {
                        if (confidenceLevel.Item1 == -1)
                        {
                            confidenceLevel = Tuple.Create(item.LevelOrder, item.FullName);
                        }
                        else
                        {
                            if (confidenceLevel.Item1 > item.LevelOrder)
                            {
                                confidenceLevel = Tuple.Create(item.LevelOrder, item.FullName);
                            }
                        }
                    }
                    else if (item.LevelType == "I")
                    {
                        if (integretityLevel.Item1 == -1)
                        {
                            integretityLevel = Tuple.Create(item.LevelOrder, item.FullName);
                        }
                        else
                        {
                            if (integretityLevel.Item1 > item.LevelOrder)
                            {
                                integretityLevel = Tuple.Create(item.LevelOrder, item.FullName);
                            }
                        }
                    }

                }

                this.LevelName = "Availability: " + availableLevel.Item2 + "\n" +
                    "Confidentiality: " + confidenceLevel.Item2 + "\n" +
                   "Integrity:" + integretityLevel.Item2;
            }
            else
            {
                var parameters = requirementData.Requirement.REQUIREMENT_LEVELS.Select(s => new Tuple<string, int>(levelManager.GetStandard(s.Standard_Level), levelManager.GetLevelOrder(s.Standard_Level))).OrderBy(s => s.Item2).FirstOrDefault();
                if (parameters != null)
                    this.LevelName = levelManager.GetFullName(parameters.Item1, parameters.Item2);
            }


            QuestionsVisible = true;
            ShowRequirementStandards = true;
            ShowSALLevel = true;
            BuildDocuments(requirementData.RequirementID, controlContext);
        }

        public void BuildFrameworkInfoTab(FrameworkInfoData frameworkData, CSETWebEntities controlContext)
        {

            QuestionsList = new List<String>();
            IsCustomQuestion = frameworkData.IsCustomQuestion;
            References = frameworkData.References;
            if (!IsComponent)
                RequirementFrameworkTitle = frameworkData.Title;
            RelatedFrameworkCategory = frameworkData.Category;
            ShowRequirementFrameworkTitle = true;
            String shortStandardName = controlContext.SETS.Where(x => x.Set_Name == frameworkData.SetName).FirstOrDefault().Short_Name;
            HeaderName = shortStandardName;

            if (String.IsNullOrWhiteSpace(References))
                References = "None";
            Question_or_Requirement_Id = frameworkData.RequirementID;

            RequirementTabData tabData = new RequirementTabData();
            if (frameworkData.IsCustomQuestion)
            {
                tabData.Text = frameworkData.Question;
                tabData.SupplementalInfo = FormatSupplementalInfo(frameworkData.SupplementalInfo);
                if (String.IsNullOrWhiteSpace(tabData.SupplementalInfo))
                    tabData.SupplementalInfo = "None";
                QuestionsVisible = false;
                ShowRequirementStandards = false;
                ShowSALLevel = false;
            }
            else
            {
                var requirement = controlContext.NEW_REQUIREMENT.Where(x => x.Requirement_Id == frameworkData.RequirementID).Select(t => new
                {
                    Text = FormatRequirementText(t.Requirement_Text),
                    SupplementalInfo = FormatSupplementalInfo(t.Supplemental_Info),
                    Questions = t.NEW_QUESTION.Select(s => s.Simple_Question),
                    LevelName = t.REQUIREMENT_LEVELS.Select(s => s.STANDARD_SPECIFIC_LEVEL).OrderBy(s => s.Level_Order).Select(s => s.Full_Name).FirstOrDefault()
                }).FirstOrDefault();
                if (requirement != null)
                {
                    QuestionsList = requirement.Questions.ToList();
                    this.LevelName = requirement.LevelName;
                    tabData.Text = requirement.Text;
                    tabData.SupplementalInfo = FormatSupplementalInfo(requirement.SupplementalInfo);

                    QuestionsVisible = false;

                    ShowSALLevel = true;
                    BuildDocuments(frameworkData.RequirementID, controlContext);
                    SetFrameworkQuestions(frameworkData.RequirementID, controlContext);
                }
            }
            RequirementsData = tabData;
        }

        public void BuildComponentInfoTab(ComponentQuestionInfoData info, CSETWebEntities controlContext)
        {
            try
            {
                IsComponent = true;
                ShowRequirementFrameworkTitle = false;
                NEW_QUESTION question = BuildFromNewQuestion(info, info.Set, controlContext);
                ComponentVisibility = true;
                // Build multiServiceComponent types list if any
                ComponentTypes.Clear();
                int salLevel = question.UNIVERSAL_SAL_LEVEL1.Sal_Level_Order;

                List<ComponentOverrideLinkInfo> tmpList = new List<ComponentOverrideLinkInfo>();

                foreach (COMPONENT_QUESTIONS componentType in question.COMPONENT_QUESTIONS)
                {
                    bool enabled = info.HasComponentsForTypeAtSal(componentType.Component_Type, salLevel);
                    SymbolComponentInfoData componentTypeData = info.DictionaryComponentInfo[componentType.Component_Type];
                    tmpList.Add(new ComponentOverrideLinkInfo()
                    {
                        TypeComponetXML = componentTypeData.XMLName,
                        Type = componentTypeData.DisplayName,
                        Enabled = enabled
                    });
                }
                ComponentTypes = tmpList.OrderByDescending(x => x.Enabled).ThenBy(x => x.Type).ToList();
            }
            catch (Exception ex)
            {
                //CSETLogger.Fatal("Failed to get component information tab data.", ex);
            }
        }

        private void BuildDocuments(int requirement_ID, CSETWebEntities controlContext)
        {
            var documents = controlContext.REQUIREMENT_SOURCE_FILES.Where(s => s.Requirement_Id == requirement_ID).Select(s => new { s.GEN_FILE.Title, s.GEN_FILE.File_Name, s.Section_Ref, IsSource = true, s.GEN_FILE.Is_Uploaded }).Concat(
                controlContext.REQUIREMENT_REFERENCES.Where(s => s.Requirement_Id == requirement_ID).Select(s => new { s.GEN_FILE.Title, s.GEN_FILE.File_Name, s.Section_Ref, IsSource = false, s.GEN_FILE.Is_Uploaded })
                ).ToList();
            // Source Documents        
            var sourceDocuments = documents.Where(t => t.IsSource).Select(s => new CustomDocument { Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded=s.Is_Uploaded??false });
            SourceDocumentsList = sourceDocuments.ToList();

            // Help Documents
            // This gets all help documents for the question
            var helpDocuments = documents.Where(t => !t.IsSource).Select(s => new CustomDocument { Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false });
            ResourceDocumentList = helpDocuments.ToList();
        }


        internal void SetFrameworkQuestions(int requirement_ID, CSETWebEntities controlEntity)
        {
            this.FrameworkQuestions.Clear();

            Stopwatch stopWatch = new Stopwatch();
            stopWatch.Start();


            var newQuestionItems = (from nr in controlEntity.NEW_REQUIREMENT
                                    from newquestions in nr.NEW_QUESTION
                                    join newquestionSets in controlEntity.NEW_QUESTION_SETS.Include(x => x.SET) on newquestions.Question_Id equals newquestionSets.Question_Id into questionSets
                                    join level in controlEntity.UNIVERSAL_SAL_LEVEL on newquestions.Universal_Sal_Level equals level.Universal_Sal_Level1
                                    join subheading in controlEntity.UNIVERSAL_SUB_CATEGORY_HEADINGS on newquestions.Heading_Pair_Id equals subheading.Heading_Pair_Id
                                    join questionGroupHeading in controlEntity.QUESTION_GROUP_HEADING on subheading.Question_Group_Heading_Id equals questionGroupHeading.Question_Group_Heading_Id
                                    where nr.Requirement_Id == requirement_ID
                                    select new
                                    {
                                        NewRequirement = nr,
                                        Question = newquestions,
                                        Level = level,
                                        QuestionGroupHeading = questionGroupHeading,
                                        QuestionSets = questionSets
                                    });
            foreach (var item in newQuestionItems)
            {

                FrameworkQuestionItem questionItem = new FrameworkQuestionItem();
                questionItem.QuestionText = item.Question.Simple_Question;
                questionItem.RequirementID = item.Question.Question_Id;
                questionItem.SALLevel = item.Level;
                questionItem.QuestionGroupHeading = item.QuestionGroupHeading;

                SET set = item.QuestionSets.OrderBy(x => x.SET.Order_Framework_Standards).Select(x => x.SET).FirstOrDefault();
                questionItem.Standard = set.Short_Name;
                questionItem.SetName = set;
                questionItem.Question = item.Question;
                questionItem.Reference = "Ref";
                this.FrameworkQuestions.Add(questionItem);
            }

            stopWatch.Stop();
            //CSETLogger.Info("Time to get framework questions Time: " + stopWatch.ElapsedMilliseconds);
        }


        /// <summary>
        /// Formats a SupplementalInfo for browser display as follows:
        ///  - if null, returns null.
        ///  - if it is a XAML FlowDocument, it is converted to HTML.
        ///  - any CRLF linefeed characters in the string are converted to <br /> tags.
        /// </summary>
        /// <param name="supp"></param>
        /// <returns></returns>
        private string FormatSupplementalInfo(string supp)
        {
            if (supp == null)
            {
                return "None";
            }

            if (supp.StartsWith("<FlowDocument"))
            {
                string html = HtmlFromXamlConverter.ConvertXamlToHtml(supp);
                return html.Replace("margin:0 0 0 0;", "").Replace("padding:0 0 0 0;", "");
            }

            // Convert any linefeed characters to HTML line break tags
            return supp.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>");
        }


        /// <summary>
        /// Converts text for browser HTML display.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        private string FormatRequirementText(string text)
        {
            return text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>");
        }
    }
}


