//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Common;
using CSET_Main.Common.EnumHelper;
using CSET_Main.DocumentLibrary;
using CSET_Main.Framework;
using DataLayer;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;

namespace CSET_Main.Questions.POCO
{
    public class QuestionPoco : IQuestionPoco
    {

        public static String CreateCategoryAndNumber(String category, string number)
        {
            return category +" "+ number;
        }
        public bool IsFrameworkMode { get; set; }
        public String QuestionGroupHeadingCategory
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.UniversalCategory;
                else if (NEW_REQUIREMENT != null)
                {
                    using (var db = new CSETWebEntities())
                    {
                        return db.QUESTION_GROUP_HEADING
                            .First(h => h.Question_Group_Heading_Id == NEW_REQUIREMENT.Question_Group_Heading_Id)
                            .Question_Group_Heading1;
                    }
                }
                else if (Question != null)
                {
                    using (var db = new CSETWebEntities())
                    {
                        var qq = from usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                                 join qgh in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                                 where usch.Heading_Pair_Id == Question.Heading_Pair_Id
                                 select qgh.Question_Group_Heading1;

                        return qq.First();
                    }
                }
                else
                    return "";
            }
        }

        private ObservableCollection<ParameterContainer> _parameters;
        public ObservableCollection<ParameterContainer> Parameters
        {
            get
            {
                return _parameters;
            }
            set
            {
                _parameters = value;
                _textSub = null;
                _textSubNoLinks = null;                

            } }
        public String Category
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.CategoryHeading;
                else if (NEW_REQUIREMENT != null)
                    return NEW_REQUIREMENT.Standard_Category;
                else if (Question != null)
                {
                    //return Question.Question_Group_Heading;
                    using (var db = new CSETWebEntities())
                    {
                        var qq = from usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS
                                 join qgh in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                                 where usch.Heading_Pair_Id == Question.Heading_Pair_Id
                                 select qgh.Question_Group_Heading1;

                        return qq.First();
                    }
                }
                else
                    return "";
           }
      }
        public int SortOrder
        {
            get; set;
        }
        //This Property is just used in deciding to dictionary of question by Universal Category or by Framework Category.
        public String CategoryAnalysis
        {
            get 
            {
                if (ProfileQuestionData != null)
                {
                    return ProfileQuestionData.CategoryHeading;
                }
                else
                {
                    return Category_Always_Universal;
                }
            }
        }

        // RKW - while refactoring for data structure changes I found that this property is not called from
        //       anywhere -- so I'm not going to waste time re-writing it.
        //public String UniversalSubCategory
        //{
        //    get
        //    {
        //        if (Question == null || Question.Universal_Sub_Category == null)
        //            return null;
        //        return Question.Universal_Sub_Category.Trim();
        //    }
        //}

        public QUESTION_GROUP_HEADING QuestionGroupHeading { get; set; }

        public String Category_Always_Universal
        {
            get
            {
                return QuestionGroupHeading.Question_Group_Heading1;
            }
        }

        public int CategoryWeight
        {
            get
            {
                return QuestionGroupHeading.Universal_Weight;
            }
        }

        public int QuestionGroupHeadingId
        {
            get
            {
                return QuestionGroupHeading.Question_Group_Heading_Id;
            }
        }

      

        private AnswerEnum questionAnswer;
        public AnswerEnum QuestionAnswer
        {
            get { return questionAnswer; }
            set { questionAnswer = value;  }
        }      

        private bool isAnswerYes;
        public bool IsAnswerYes
        {

            get
            {
                return QuestionAnswer == AnswerEnum.YES;
            }
            set
            {
                isAnswerYes = value;
                               
            }
        }

        private bool isAnsweNo;
        public bool IsAnswerNo
        {

            get
            {
                return QuestionAnswer == AnswerEnum.NO;
            }
            set
            {
                isAnsweNo = value;
                                
            }
        }

        private bool isAnswerNa;
        public bool IsAnswerNa
        {
            get
            {
                return QuestionAnswer == AnswerEnum.NA;
            }
            set
            {
                isAnswerNa = value;
                               
            }
        }

        private bool isAnswerAlt;
        public bool IsAnswerAlt
        {
            get
            {
                return QuestionAnswer == AnswerEnum.ALT;
            }
            set
            {
                isAnswerAlt = value;
                                
            }
        }

        public bool IsAnswerPassed
        {
            get
            {
                return (IsAnswerNa 
                    || IsAnswerYes
                    || IsAnswerAlt);
            }
        }

        public bool IsAnswerFailed
        {
            get
            {
                return (IsAnswerNo
                    || IsUnAnswered);
            }
        }

        public bool IsUnAnswered
        {
            get { return QuestionAnswer == AnswerEnum.UNANSWERED; }
        }

        public String AnswerValueText
        {
            get
            {
                string rtnVal = "";
                switch (QuestionAnswer)
                {
                    case AnswerEnum.YES:
                        rtnVal = "Yes";
                        break;
                    case AnswerEnum.NO:
                        rtnVal = "No";
                        break;
                    case AnswerEnum.NA:
                        rtnVal = "N/A";
                        break;
                    case AnswerEnum.ALT:
                        rtnVal = "Alternate";
                        break;
                    case AnswerEnum.UNANSWERED:
                        rtnVal = "Unanswered";
                        break;
                }
                return rtnVal;
            
            }
        }

        /// <summary>
        /// This property is for user documents associated to questions.
        /// </summary>
        public ICollection<DOCUMENT_FILE> DocumentLibrary
        {
            get
            {
                return Answer.DOCUMENT_FILE;
            }
        }

        public UNIVERSAL_SAL_LEVEL SALLevel { get; set; }
        private RequirementLevel RequirementLevel{get;set;}

        public String Level
        {
            get
            {
                //Note:The order of if statement important because NIST Framework is a requirement question.
                if (Answer.Is_Framework)
                {
                    if (SALLevel == null)
                    {
                        Debug.Assert(false,"SALLEVEL is null for NIST Framework question.");
                        return null;
                }

                    return SALLevel.Universal_Sal_Level1;
                    }
                else if (Answer.Is_Requirement)
            {
                    return RequirementLevel.StandardLevel;
            }
                else
        {
                    if (SALLevel == null)
            {
                        Debug.Assert(false, "SALLEVEL is null for Question mode question.");
                        return null;
                    }
                    return SALLevel.Universal_Sal_Level1; 
                }

            }
        }

        public bool IsSingleSetQuestionMode { get; set; }
        public int MinQuestionLevel { get; set; }
    
        public int Rank_Sal_Level_Order
        {
            get
            {
                if (RequirementLevel != null)
                    return RequirementLevel.LevelOrder;
                else if (IsSingleSetQuestionMode)
                {
                    return MinQuestionLevel;
                } 
                else
                {
                    if (SALLevel == null)
                    {
                        Debug.Assert(false, "SALLEVEL is null for NIST Framework question.");
                        return 1;
                    }
                    return SALLevel.Sal_Level_Order;
                }
            }
        }

        public int Sal_Level_Order
        {
            get
            {
                if (RequirementLevel != null)
                    return RequirementLevel.LevelOrder;
                else
                {
                    if (SALLevel == null)
                    {
                        Debug.Assert(false, "SALLEVEL is null for NIST Framework question.");
                        return 1;
                    }
                    return SALLevel.Sal_Level_Order;
                }
            }
        }
        public string RequirementTitle
        {
            get
            {
                if(ProfileQuestionData != null)
                {
                    return QuestionNumber;
                }
                else if (NEW_REQUIREMENT != null)
                    return NEW_REQUIREMENT.Requirement_Title;
                else if (Question != null&&IsComponent==false)
                    return String.Join(", ",Question.NEW_REQUIREMENT.Where(s=>DictionaryStandards.Keys.Contains(s.SET.Set_Name)&&s.SET.SETS_CATEGORY!=null&&s.SET.SETS_CATEGORY.Set_Category_Id!=9).OrderBy(s=>s.SET.Set_Name).ThenBy(s=>s.Requirement_Title).Select(s=>s.Requirement_Title).Distinct());
                else
                    return "";
            }
        }

        //public ObservableCollection<Tuple<string,string>> QuestionRequirements
        //{
        //    get
        //    {
        //        return Question.NEW_REQUIREMENT.GroupJoin(DictionaryStandards.Keys, s=>s.REQUIREMENT_SETS.Select(t=>t.Set_Name), s=>s,(s,t)=>new Tuple<string,string>(string.Join("/r/n",t), s.Requirement_Text));
        //    }
        //}
        private String text;
        public String Text
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.Question;

                else if (Question != null)
                    return Question.Simple_Question;
                else if (NEW_REQUIREMENT != null)
                    return NEW_REQUIREMENT.Requirement_Text;
                else
                    return "";

                }
            set
            {
                text = value;
                    
            }
        }

        private string _textSub;
        private string _textSubNoLinks;
        public string TextSub
        {
            get
            {
                if (IsFramework)
                    return Text;
                else if (IsRequirement)
                {
                    //substitute each parameter for 
                    //</Run><Hyperlink>[param value]</Hyperlink><Run>
                    //then wrap the whole thing in a a <Run></Run>
                    //in the end
                    if(_textSub==null)
                    {
                        buildParameterizedText();
                    }
                    return _textSub;
                }
                else
                {
                    var textBlock=Text;
                    if(RequirementTitle.Trim().Length>0)
                    {
                        var run = String.Format("<i>  (Req #: {0})</i>", RequirementTitle);
                        textBlock += run;
                    }
                    return textBlock;
                }
            }
            set
            {   
                
            }
        }

        public string TextSubNoLinks
        {
            get
            {
                if (IsRequirement&&!IsFramework)
                {
                    //substitute each parameter for 
                    //</Run><Hyperlink>[param value]</Hyperlink><Run>
                    //then wrap the whole thing in a a <Run></Run>
                    //in the end
                    if (_textSubNoLinks == null)
                    {
                        buildParameterizedText();
                    }

                    return _textSubNoLinks;
                }
                else
                    return TextSub;
            }
            set
            {
                
            }
        }
        public bool? Mark_For_Review
        {
            get
            {
                return Answer.Mark_For_Review;
            }
            set
            {
                if (Answer.Mark_For_Review != value)
                {
                    Answer.Mark_For_Review = value;                
                }
            }
        }

        public bool IsComment
        {
            get
            {
                if (String.IsNullOrWhiteSpace(Answer.Comment))
                    return false;
                else
                    return true;
            }
        }

        private string comment;
        public String Comment
        {
            get
            {
                if(!String.IsNullOrWhiteSpace(Answer.Comment)){
                    comment = Answer.Comment;
                }
                return comment;
            }
            set
            {
                if (String.IsNullOrWhiteSpace(value))
                {
                    Answer.Comment = null;
                    comment = value;
                }
                else
                    Answer.Comment = value;
                
            }
        }

        private int documentCount;
        public int DocumentCount
        {
            get { return documentCount; }
            set
            {
                documentCount = value;
                
            }
        }

        private int findingCount;
        public int FindingCount
        {
            get { return findingCount; }
            set
            {
                findingCount = value;
                
            }
        }


        /// <summary>
        /// TODO: Do we need to deal with Requirements Mode??
        /// </summary>
        private String categoryAndQuesitonNumber;
        public String CategoryAndQuestionNumber
        {
            get
            {
                if(IsRequirement)
                {
                    return CreateCategoryAndNumber(Category, this.RequirementTitle);
                }
                else
                {
                    return CreateCategoryAndNumber(Category, "#" + this.QuestionNumber);
                }
            }
            set
            {
                categoryAndQuesitonNumber = value;
                        
            }

        }

        public String FrameworkName { get; set; }

        private string stdname;
        public String StandardName
        {
            get
            {
                return stdname;
            }
        }

        public String StandardNameAnalysis
        {
            get
            {
                if (IsFramework)
                {
                    return FrameworkName;
                }
                else
                {
                    return StandardName;
                }
            }
 
        }

        public String CategoryAndQuestionNumberWithStandard
        {
            get
            {
                if (NEW_REQUIREMENT!=null)
                {
                    return stdname + " - " + CategoryAndQuestionNumber;
                }
                else
                {
                    return CategoryAndQuestionNumber;
                }
            }
        }
      


        public bool IsRequirement { get { return Answer.Is_Requirement; } }
        public bool IsQuestion { get { return !Answer.Is_Requirement; } }
        public bool IsFramework { get { return Answer.Is_Framework; } }

        public bool FrameworkExpanderVisibility 
        {

            get 
            {
                if (IsFramework)
                {
                    if (ProfileQuestionData != null)
                    {
                        if (ProfileQuestionData.IsCustomQuestion)
                            return false; // Visibility.Hidden;                       
                        else
                            return true; // Visibility.Visible;
                    }
                    else
                    {
                        Debug.WriteLine("QuestionPoco Error: ProfileQuestionData is null but it is framework question.");
                        return true;// Visibility.Visible;
                    }

                }
                else if (IsFrameworkMode)
                {
                    return false;// Visibility.Hidden;
                }
                else
                    return false; // Visibility.Collapsed; 
            } 
        }


        /// <summary>
        /// TODO: What is this for? Is it for associating the groups?
        /// </summary>
        public List<int> ChildQuestionIDs { get; set; }

        public String SetName { get; set; }
        public string DefaultSetName { get; set; }

        /* Will use QuestionNumberForQuestions when in QuestionMode or NISTFrameworkMode
         Otherwise will try to use dictionaryRequirementQuestionNumberBySet. The reason is in dictionary is because it can have different questionnumber
         depending on what standard is being viewed.
         */
        public string QuestionNumber
        {
            get
            {
                if (QuestionNumberForQuestion.HasValue)
                    return QuestionNumberForQuestion.GetValueOrDefault().ToString();
                
                else if (IsRequirement)
                {
                    return RequirementTitle;
                }
                else
                {
                    return 0.ToString();
                }
            }
        }
        private int? questionNumberForQuestion;
        //Will be set when in QuestionMode and StandardFramework.
        public int? QuestionNumberForQuestion
        {
            get { return questionNumberForQuestion; } 
            set { questionNumberForQuestion = value;  }
        }

        public int Question_or_Requirement_ID
        {
            get
            {
                return Answer.Question_Or_Requirement_Id;
            }
        }

        private bool isSelected;
        public bool IsSelected { get { return isSelected; } set { isSelected = value;  } }

        public bool IsComponent
        {

            get
            {
                return Answer.Is_Component;
            }

        }

        public bool IsDefaultComponent
        {
            get
            {
                if (Answer.Is_Component)
                {
                    if (Component_Id == 0)
                        return true;                    
                }
                return false;               
            }
        }

        public bool IsSpecificComponent
        {
            get 
            {
                if (Answer.Is_Component)
                {
                    if (!IsDefaultComponent)
                        return true;
                }
                return false;
            }
        }

        public bool IsStandardRequirement
        {
            get 
            {
                return !IsComponent;
            }
        }

        public int Weight
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.Weight;
                else if (NEW_REQUIREMENT != null)
                    return NEW_REQUIREMENT.Weight.GetValueOrDefault();
                else if (Question != null)
                    return Question.Weight.GetValueOrDefault();
                else
                    return 1;               
            }
        }
        public int Component_Id
        {
            get
            {
                return Answer.Component_Id;
            }
        }

        /// <summary>
        /// This is the new ranking of all questions in the database. Each question is ranked in order based on best guess.
        /// Categories ranks will be calculated based on these rankings.
        /// </summary>
        public int Ranking
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.Ranking;
                else if (NEW_REQUIREMENT != null&& Answer.Is_Requirement)
                    return NEW_REQUIREMENT.Ranking.GetValueOrDefault();
                else if (Question != null)
                    return Question.Ranking.GetValueOrDefault();
                else
                    return -1;
            }
        }

        //private Nerc_Rank_Lookup nercLookup = Nerc_Rank_Lookup.GetLookup();
        //public NERC_RISK_RANKING NERC_Rank
        //{
        //    get
        //    {
        //        return nercLookup.GetRank(this.Question_or_Requirement_ID, IsRequirement);
        //    }
        //}
        

        /// <summary>
        /// This appears to be a auto numbering of the questions in order of Rank.
        /// </summary>
        public int RankNumber { get; set; }
        //public NetworkComponent NetworkComponent { get; set; }
        public Boolean IsCNSSI { get; set; }
        public int CNSSINumber { get; set; }
        
        public String ProfileComments 
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.Comments;
                else
                    return "";                 
             }
        }

        public String ProfileReferences
        {
            get
            {
                if (ProfileQuestionData != null)
                    return ProfileQuestionData.References;
                else
                    return "";
            }
        }

     
        /// <summary>
        /// To make the code cleaner should try avoid acess directly from this database object. Instead should use was one fo the properties on this object.
        /// All of the data should be exposed through other properties. For example the Answer can be found on the QuestionAnser Property.
        /// </summary>
        public ANSWER Answer
        {
            get;
            private set;
        }

        private HashSet<int> setDocumentIds = new HashSet<int>();
        
        private Dictionary<String, int> dictionaryRequirementQuestionNumberBySet = new Dictionary<string, int>();

        /// <summary>
        /// Note: Warning these fields should only be set in the constructor of questionPoco. 
        /// NEW_REQUIREMENT is for Requirement Questions. Question is for question Mode questions.
        /// ProfileQuestionData is for profileQuestions
        /// </summary>
        public NEW_REQUIREMENT NEW_REQUIREMENT { get; set; }
        public NEW_QUESTION Question { get; private set; }

        public void SetRequirementForSet(REQUIREMENT_SETS set)
        {
            if(!IsRequirement)
            {
                SortSet = set==null?Question.SET:set.SET;
                NEW_REQUIREMENT = set==null?Question.NEW_REQUIREMENT.FirstOrDefault():set.NEW_REQUIREMENT;
            }
        }

        public SET SortSet
        {
            get;set;
        }

        public void ClearRequirement()
        {
            if (!IsRequirement)
                NEW_REQUIREMENT = null;
        }


        public ProfileQuestion ProfileQuestionData
        {
            get;
            set;
        }
        public ProfileCategory ProfileCategory
        {
            get {
                if (ProfileQuestionData == null)
                    return null;
                return ProfileQuestionData.Category;
            }
            
        }

        public Dictionary<String, SET> DictionaryStandards { get; set; }

        //If true then QuestionInformationTabData just shows the category and not the question number associated with it. 
        public bool IsFrameworkRelatedQuestion { get; set; }
        public int NercRankNumber { get; set; }

        public QuestionPoco(ANSWER answer, NEW_REQUIREMENT new_requirement, RequirementLevel requirementLevel)
            : this(answer)
        {
            this.NEW_REQUIREMENT = new_requirement;
            this.RequirementLevel = requirementLevel; 
        }

        public QuestionPoco(ANSWER answer, NEW_QUESTION question) :this(answer)
        {
            this.Question = question;
          
        }

        public QuestionPoco(ANSWER answer, SET set, ProfileQuestion profileQuestion)
            : this(answer)
        {
            this.ProfileQuestionData = profileQuestion;
            this.DictionaryStandards[set.Set_Name] = set;
        }

        private QuestionPoco(ANSWER answer, bool setParams=true)
        {
            this.DictionaryStandards = new Dictionary<String, SET>();
            this.Answer = answer;
            this.setDocumentIds = answer.DOCUMENT_FILE.Select(x => x.Document_Id).ToHashSet();
            DocumentCount = setDocumentIds.Count;
            if(setParams)
                this.Parameters = new ObservableCollection<ParameterContainer>();
            QuestionAnswer = EnumHelper.GetEnumValueFromDescription<AnswerEnum>(Answer.Answer_Text);
        }

        public void SetStandards(IEnumerable<SET> sets)
        {
            foreach (SET set in sets)
            {
                this.DictionaryStandards[set.Set_Name] = set;
            }
            SetStandardName();
        }


        /// <summary>
        /// Requirement questions should only have one set(i.e. Standard).  So just return first item in dictionary
        /// </summary>
        /// <returns></returns>
        public SET GetRequirementSet()
        {
            SET s;
            if(SetName!=null)
            if (DictionaryStandards.TryGetValue(SetName, out s))
            {
                return s;
            }
            
            foreach (SET si in DictionaryStandards.Values)
            {
                return si;
            }

            
            
            Debug.Assert(false, "There is no sets in dictionary for requirement questionPoco.");
            return null; 
        }
        internal ICollection<SET> GetRequirementSets()
        {
            return DictionaryStandards.Values;
        }


        public void SetAnswer(AnswerEnum answerValue)
        {
            Answer.Answer_Text = answerValue.GetStringAttribute();
            QuestionAnswer = answerValue;
            if(answerValue!=AnswerEnum.UNANSWERED && this.Parameters!=null)
            {
                var nonExplicits = this.Parameters.Where(s => !s.IsExplicitlySet).ToList();
                foreach(var parameter in nonExplicits)
                {
                    parameter.IsExplicitlySet = true;
                }
            }                        
        }
    

        public QuestionPocoTypeEnum GetQuestionType()
        {
            if (IsComponent)
            {
                if (Component_Id != 0)
                {
                    return QuestionPocoTypeEnum.SpecificComponent;
                }
                else
                {
                    return QuestionPocoTypeEnum.DefaultComponent;
                }
            }
            else
            {
                if (IsRequirement)
                {
                    return QuestionPocoTypeEnum.Requirement;
                }
                else
                {
                    return QuestionPocoTypeEnum.Question;
                }
            }
        }
        

        public String GetQuestionDocumentLabel()
        {
            QuestionPocoTypeEnum typeQuestion = GetQuestionType();
            if (typeQuestion == QuestionPocoTypeEnum.DefaultComponent)
            {
                return "Component Defaults" + "  " + CategoryAndQuestionNumberWithStandard;
            }
            else if (typeQuestion == QuestionPocoTypeEnum.SpecificComponent)
            {
                String componentName = "";
                //if (NetworkComponent != null)
                //{
                //    //TODO: need to get the diagram component label and set it here
                //    //if (NetworkComponent.TextNodeLabel != null)
                //    //{
                //    //    componentName = "Name: " + NetworkComponent.TextNodeLabel + " Question: ";
                //    //}
                //}
                return "Component Specific  " + componentName + CategoryAndQuestionNumber;
            }
            else
            {
                return ((IsFramework) ? "Framework" : "Standards") + "  " + CategoryAndQuestionNumber;
            }
        }
        private void buildParameterizedText()
        {
            var builder = new ParameterTextBuilder(this);
            var text = builder.ReplaceParameterText();
            _textSub = text.Item1;
            _textSubNoLinks = text.Item2;
        }
        public string TextWithParameters
        {
            get
            { 
                var str = Text;
                Parameters.ToList().ForEach(t => str=str.Replace(t.Name,t.Value));
                if (!IsRequirement&&!IsFramework&&!String.IsNullOrEmpty(RequirementTitle))
                {
                    str+=String.Format("  (Req #: {0})", RequirementTitle);
                }
                return str;
            }
            
        }
        private string shortSupplemental;
        public string ShortSupplemental
        {
            get
            {
                if (shortSupplemental==null)
                {
                    var standard = DictionaryStandards.FirstOrDefault();
                    var requirements = new List<NEW_REQUIREMENT>();
                    NEW_REQUIREMENT standardRequirement=null;
                    var standardList = new List<string>();
                    if(Question?.NEW_REQUIREMENT!=null)
                    {
                        foreach (var item in DictionaryStandards)
                        {
                            if (item.Value.Is_Custom)
                            {
                                var standards = item.Value.CUSTOM_STANDARD_BASE_STANDARD.Select(s => s.Base_Standard).ToList();
                                standardList = standardList.Concat(standards).ToList();
                            }
                            standardList.Add(item.Key);
                        }
                        foreach (var setName in standardList)
                        {
                            standardRequirement = Question?.NEW_REQUIREMENT?.FirstOrDefault(t => !String.IsNullOrEmpty(t.Supplemental_Info)&&t.REQUIREMENT_SETS.Select(s => s.Set_Name).Contains(setName));
                            if (standardRequirement!=null)
                            {
                                break;
                            }
                        }
                    }
                    var supplemental = ProfileQuestionData?.SupplementalInfo ??
                        (standardRequirement ??
                        Question?.NEW_REQUIREMENT?.FirstOrDefault() ?? 
                        NEW_REQUIREMENT)?.Supplemental_Info.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>");
                    if (String.IsNullOrEmpty(supplemental))
                    {
                        shortSupplemental = "";
                    }
                    else
                    {
                        string text = supplemental;
                        //TODO this needs to be replaced with the html render instead of supplemental
                        //if(supplemental.IsFlowDocAlready())
                        //{
                        //    var flowDoc = (FlowDocument)XamlReader.Parse(supplemental);
                        //    text = "";
                        //    foreach(var block in flowDoc.Blocks)
                        //    {
                        //        text += new TextRange(block.ContentStart, block.ContentEnd).Text;
                        //        text += Environment.NewLine;
                        //    }
                        //}
                        //else
                        //{
                        //    text = supplemental;
                        //}
                        shortSupplemental= text;
                    }
                }
                return shortSupplemental;
            }
        }
        internal void AddSet(SET set)
        {
            this.DictionaryStandards[set.Set_Name] = set;
        }
      
        internal void AddSetAndSetStandardName(SET set)
        {
            AddSet(set);
            SetStandardName();
        }

        internal void SetStandardName()
        {
              stdname = String.Join(", ", DictionaryStandards.Values.Select(x=>x.Full_Name));
        }

    
        internal void SetRequirementQuestionNumber(string setName, int i)
        {
            if(!dictionaryRequirementQuestionNumberBySet.ContainsKey(setName))
                dictionaryRequirementQuestionNumberBySet.Add(setName, i);
        }

        internal bool IsDefaultFrameworkQuestion()
        {
                if (ProfileQuestionData != null)
                {
                    if (!ProfileQuestionData.IsCustomQuestion)
                        return true;
                }
                return false;           
        }

       
    }
}


