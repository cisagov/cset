//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CSETWebCore.Enum;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Interfaces.Question
{
    public interface IQuestionPoco
    {
        ANSWER Answer { get; }
        string AnswerValueText { get; }

        string Category { get; }
        string CategoryAnalysis { get; }
        string CategoryAndQuestionNumber { get; set; }
        string CategoryAndQuestionNumberWithStandard { get; }
        int CategoryWeight { get; }
        string Category_Always_Universal { get; }
        List<int> ChildQuestionIDs { get; set; }
        int CNSSINumber { get; set; }
        string Comment { get; set; }
        string DefaultSetName { get; set; }
        Dictionary<string, SETS> DictionaryStandards { get; set; }
        int DocumentCount { get; set; }
        ICollection<DOCUMENT_FILE> DocumentLibrary { get; }
        int ObservationCount { get; set; }
        bool FrameworkExpanderVisibility { get; }
        string FrameworkName { get; set; }
        bool IsAnswerAlt { get; set; }
        bool IsAnswerFailed { get; }
        bool IsAnswerNa { get; set; }
        bool IsAnswerNo { get; set; }
        bool IsAnswerPassed { get; }
        bool IsAnswerYes { get; set; }
        bool IsCNSSI { get; set; }
        bool IsComment { get; }
        bool IsComponent { get; }
        bool IsDefaultComponent { get; }
        bool IsFramework { get; }
        bool IsFrameworkMode { get; set; }
        bool IsFrameworkRelatedQuestion { get; set; }
        bool IsQuestion { get; }
        bool IsRequirement { get; }
        bool IsSelected { get; set; }
        bool IsSingleSetQuestionMode { get; set; }
        bool IsSpecificComponent { get; }
        bool IsStandardRequirement { get; }
        bool IsUnAnswered { get; }
        string Level { get; }
        bool? Mark_For_Review { get; set; }
        int MinQuestionLevel { get; set; }
        int NercRankNumber { get; set; }
        //NERC_RISK_RANKING NERC_Rank { get; }

        NEW_REQUIREMENT NEW_REQUIREMENT { get; }
        //ObservableCollection<ParameterContainer> Parameters { get; set; }

        string ProfileComments { get; }

        string ProfileReferences { get; }
        NEW_QUESTION Question { get; }
        AnswerEnum QuestionAnswer { get; set; }
        QUESTION_GROUP_HEADING QuestionGroupHeading { get; set; }
        string QuestionGroupHeadingCategory { get; }
        int QuestionGroupHeadingId { get; }
        string QuestionNumber { get; }
        int? QuestionNumberForQuestion { get; set; }
        int Question_or_Requirement_ID { get; }
        int Ranking { get; }
        int RankNumber { get; set; }
        int Rank_Sal_Level_Order { get; }
        string RequirementTitle { get; }
        UNIVERSAL_SAL_LEVEL SALLevel { get; set; }
        int Sal_Level_Order { get; }
        string SetName { get; set; }
        string ShortSupplemental { get; }
        int SortOrder { get; set; }
        SETS SortSet { get; set; }
        string StandardName { get; }
        string StandardNameAnalysis { get; }
        string Text { get; set; }
        string TextSub { get; set; }
        string TextSubNoLinks { get; set; }
        string TextWithParameters { get; }
        // RKW - not called by anything in CSET 9.0 -- string UniversalSubCategory { get; }
        int Weight { get; }

        void ClearRequirement();
        string GetQuestionDocumentLabel();
        QuestionPocoTypeEnum GetQuestionType();
        SETS GetRequirementSet();
        void SetAnswer(AnswerEnum answerValue);
        void SetRequirementForSet(REQUIREMENT_SETS set);
        void SetStandards(IEnumerable<SETS> sets);
    }
}