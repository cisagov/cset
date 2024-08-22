using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Question
{
    /// <summary>
    /// Translation info for a single Category
    /// </summary>
    public class KeyValueOverlay
    {
        /// <summary>
        /// The English category name
        /// </summary>
        public string Key { get; set; }

        /// <summary>
        /// The translated category name
        /// </summary>
        public string Value { get; set; }
    }


    /// <summary>
    /// Translation info for a single Requirement
    /// </summary>
    public class RequirementOverlay
    {
        public int RequirementId { get; set; }
        public string RequirementText { get; set; }
        public string SupplementalInfo { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class MaturityGroupingOverlay
    {
        public int GroupingId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class MaturityQuestionOverlay
    {
        public int MatQuestionId { get; set; }
        public string QuestionTitle { get; set; }
        public string QuestionText { get; set; }
        public string SupplementalInfo { get; set; }
        public string ExaminationApproach { get; set; }
        public string ReferenceText { get; set; }
        public string SecurityPractice {  get; set; }
        public string Outcome {  get; set; }
        public string Scope { get; set; }
        public string RecommendAction { get; set; }
        public string RiskAddressed { get; set; }
        public string Services { get; set; }
        public string Implementation_Guides { get; set; }

    }
}
