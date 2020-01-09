using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class Aggregation
    {
        public int AggregationId { get; set; }
        public string AggregationName { get; set; }
        public DateTime? AggregationDate { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class MergeStructure
    {
        public Guid MergeID;
        public List<string> Aliases = new List<string>();
        public List<MergeCategory> QuestionsCategories = new List<MergeCategory>();
        public List<MergeCategory> ComponentDefaultCategories = new List<MergeCategory>();
        public List<MergeCategory> ComponentOverrideCategories = new List<MergeCategory>();
    }


    /// <summary>
    /// 
    /// </summary>
    public class MergeCategory
    {
        public string Category;
        public List<MergeQuestion> Questions = new List<MergeQuestion>();
    }


    /// <summary>
    /// 
    /// </summary>
    public class MergeQuestion
    {
        public int QuestionID;
        public string QuestionText;
        public int CombinedAnswerID;
        public List<MergeAnswer> SourceAnswers = new List<MergeAnswer>();
        public string DefaultAnswer;
        public int CategoryID;
        public string CategoryText;
        public bool Is_Component;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="abc"></param>
        public MergeQuestion(int abc)
        {
            for (int i = 0; i < abc; i++)
            {
                this.SourceAnswers.Add(new MergeAnswer());
            }
        }
    }


    /// <summary>
    /// 
    /// </summary>
    public class MergeAnswer
    {
        public int SourceAnswerID;
        public string AnswerText;
        public string AlternateJustification;
        public string Comment;
        public bool MarkedForReview;
        public string ComponentGuid;


        public MergeAnswer()
        {
            this.SourceAnswerID = 0;
            this.AnswerText = string.Empty;
        }
    }
}