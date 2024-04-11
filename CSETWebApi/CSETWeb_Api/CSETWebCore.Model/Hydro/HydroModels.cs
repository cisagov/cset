//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Hydro
{

    public class ModelStructure
    {
        public string ModelName { get; set; }
        public string ModelTitle { get; set; }
        public int ModelId { get; set; }
        public List<Grouping> Groupings { get; set; } = new List<Grouping>();
    }

    public class HydroDonutData
    {
        public MATURITY_QUESTIONS Question { get; set; }
        public MATURITY_ANSWER_OPTIONS AnswerOption { get; set; }
        public HYDRO_DATA Actions { get; set; }
        //public ANSWER Answer { get; set; }
    }

    public class HydroActionsByDomain
    {
        public string DomainName { get; set; }
        public int DomainSequence { get; set; }
        public List<HydroActionQuestion> ActionsQuestions { get; set; }
    }

    public class HydroActionQuestion
    {
        public MATURITY_QUESTIONS Question { get; set; }
        public HYDRO_DATA Action { get; set; } //ended here. make a method to tie actions with questions for results page
        public HYDRO_DATA_ACTIONS ActionData { get; set; }
    }

    public class HydroGroupingInfo
    {
        public List<QuestionWithAnswers> QuestionsWithAnswers { get; set; }
        public int GroupingId { get; set; }
        public int TotalSubGroupings { get; set; }
        public int ParentGroupingId { get; set; }

    }

    public class QuestionWithAnswers
    {
        public MATURITY_QUESTIONS Question { get; set; }
        public List<ANSWER> Answers { get; set; }
    }

    public class HydroResults
    {
        public List<HYDRO_DATA> HydroData { get; set; }
        public HydroImpacts impactTotals { get; set; }
        public HydroFeasibilities feasibilityTotals { get; set; }
        public int parentSequence { get; set; }
        public int parentGroupId { get; set; }

    }

    public class HydroImpacts
    {
        public int Economic { get; set; }
        public int Environmental { get; set; }
        public int Operational { get; set; }
        public int Safety { get; set; }
    }

    public class HydroFeasibilities
    {
        public int Hard { get; set; }
        public int Medium { get; set; }
        public int Easy { get; set; }
    }

    public class Grouping
    {
        public string GroupType { get; set; }
        public string Description { get; set; }
        public string Abbreviation { get; set; }
        public int GroupingId { get; set; }
        public string Prefix { get; set; }
        public string Title { get; set; }

        /// <summary>
        /// The grouping's score based on answers/options
        /// </summary>
        public Score Score { get; set; }

        public Aggregation.HorizBarChart Chart { get; set; }

        public List<Grouping> Groupings { get; set; } = new List<Grouping>();
        public List<Question> Questions { get; set; } = new List<Question>();
    }

    public class Question
    {
        public int QuestionId { get; set; }
        public string QuestionType { get; set; }
        public int Sequence { get; set; }
        public int MaturityLevel { get; set; }
        public string MaturityLevelName { get; set; }
        public string DisplayNumber { get; set; }
        public string QuestionText { get; set; }
        public int Ranking { get; set; }

        public string AnswerText { get; set; }
        public string AnswerMemo { get; set; }
        public string AltAnswerText { get; set; }

        public string SupplementalInfo { get; set; }
        public string ReferenceText { get; set; }

        public List<GenFileView> SourceDocuments { get; set; }
        public List<GenFileView> AdditionalDocuments { get; set; }

        public int? ParentQuestionId { get; set; }
        public int? ParentOptionId { get; set; }
        public List<Option> Options { get; set; } = new List<Option>();
        public List<Question> Followups { get; set; } = new List<Question>();

        public string Comment { get; set; }
        public string Feedback { get; set; }
        public bool MarkForReview { get; set; }
        public List<int> DocumentIds { get; set; } = new List<int>();

        public string BaselineAnswerText { get; set; }
        public string BaselineAnswerMemo { get; set; }
    }

    public class Option
    {
        public int OptionId { get; set; }
        public string OptionType { get; set; }
        public string OptionText { get; set; }
        public int Sequence { get; set; }

        public decimal? Weight { get; set; }

        /// <summary>
        /// Identifies an option that should not be selected
        /// if any of its peers is selected, e.g., "none of the above"
        /// </summary>
        public bool IsNone { get; set; }

        public bool Selected { get; set; }

        public int? AnswerId { get; set; }

        /// <summary>
        /// Indicates if the option also renders an input field.
        /// </summary>
        public bool HasAnswerText { get; set; }

        /// <summary>
        /// The user's answer.
        /// </summary>
        public string AnswerText { get; set; }

        /// <summary>
        /// Baseline selections can be populated for comparison against
        /// the current assessment's option.
        /// </summary>
        public bool BaselineSelected { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BaselineAnswerText { get; set; }



        public List<Question> Followups { get; set; } = new List<Question>();
    }


    public class IntegrityCheckOption
    {
        public int OptionId { get; set; }
        public bool Selected { get; set; }
        public List<InconsistentOption> InconsistentOptions { get; set; } = new List<InconsistentOption>();
    }


    public class InconsistentOption
    {
        public int OptionId { get; set; }
        public string ParentQuestionText { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class Score
    {
        public int GroupingId { get; set; }
        public int GroupingScore { get; set; }
        public int High { get; set; }
        public int Median { get; set; }
        public int Low { get; set; }
    }


    /// <summary>
    /// Represents a node in the navigation tree.  This is created
    /// for use with the CIS model because the tree is large
    /// and not worth hard coding.  This class could be promoted
    /// to some place more general for other usage if needed.
    /// </summary>
    public class NavNode
    {
        public int? Id { get; set; }
        public string Title { get; set; }
        public int Level { get; set; }
        public bool HasChildren { get; set; } = false;
    }

    public class FlatQuestion
    {
        public string QuestionText { get; set; }
        public decimal? Weight { get; set; }
        public bool Selected { get; set; }
        public string Type { get; set; }
    }

    public class GroupedQuestions
    {
        public string QuestionText { get; set; }
        public List<FlatQuestion> OptionQuestions { get; set; }
    }

    public class RollupOptions
    {
        public string Type { get; set; }
        public decimal? Weight { get; set; }
    }

    public class CisAssessmentsResponse
    {
        public int? BaselineAssessmentId { get; set; }
        public List<AssessmentDetail> MyCisAssessments { get; set; } = new List<AssessmentDetail>();
    }

    public class CisImportRequest
    {
        public int Dest { get; set; }
        public int Source { get; set; }
    }
}
