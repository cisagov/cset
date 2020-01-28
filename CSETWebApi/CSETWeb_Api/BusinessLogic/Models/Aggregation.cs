//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.Controllers;

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
        public string Mode { get; set; }
        public float QuestionsCompatibility;
        public float RequirementsCompatibility;
    }


    public class AssessmentListResponse
    {
        public Aggregation Aggregation;
        public List<AggregAssessment> Assessments;        

        public AssessmentListResponse()
        {
            this.Aggregation = new Aggregation();
            this.Assessments = new List<AggregAssessment>();
        }
    }


    /// <summary>
    /// Contains minimal data for assessments involved in a trend or compare.
    /// </summary>
    public class AggregAssessment
    {
        public int AssessmentId { get; set; }
        public string AssessmentName { get; set; }
        public DateTime AssessmentDate { get; set; }
        public string Alias { get; set; }
        public List<SelectedStandards> SelectedStandards;

        public AggregAssessment()
        {
            this.SelectedStandards = new List<SelectedStandards>();
        }
    }


    public class SelectedStandards
    {
        public string StandardName;
        public bool Selected;
    }


    /// <summary>
    /// 
    /// </summary>
    public class AssessmentStandardGrid
    {
        public Aggregation Aggregation;
        public List<AggregAssessment> Assessments;
    }


    public class AssessmentSelection
    {
        public int AssessmentId { get; set; }
        public bool Selected { get; set; }
        public string Alias { get; set; }
    }


    /// <summary>
    /// Shown in Compare Analytics
    /// </summary>
    public class MissedQuestion
    {
        public int QuestionId { get; set; }
        public string Category { get; set; }
        public string Subcategory { get; set; }
        public string QuestionText { get; set; }
    }


    public class HorizBarChart
    {
        public string reportType { get; set; }
        public List<string> labels { get; set; }

        public List<ChartDataSet> datasets { get; set; }

        public HorizBarChart()
        {
            this.labels = new List<string>();
            this.datasets = new List<ChartDataSet>();
        }
    }

    public class ChartDataSet
    {
        public string label { get; set; }
        public List<float> data { get; set; }

        public ChartDataSet()
        {
            this.data = new List<float>();
        }
    }

    public class LineChart
    {
        public string reportType { get; set; }

        /// <summary>
        /// The labels for the x-axis.  Typically dates.
        /// </summary>
        public List<string> labels { get; set; }

        public List<ChartDataSet> datasets { get; set; }


        public LineChart()
        {
            this.labels = new List<string>();
            this.datasets = new List<ChartDataSet>();
        }
    }


    /// <summary>
    /// Contains an answer breakdown for an assessment.  
    /// </summary>
    public class AnswerCounts
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public int Total { get; set; }
        public int Y { get; set; }
        public int N { get; set; }
        public int NA { get; set; }
        public int A { get; set; }
        public int U { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class BestToWorstCategory
    {
        public string Category { get; set; }
        public List<GetComparisonBestToWorst> Assessments { get; set; }
    }





    ////////////////////////////////   MERGE    //////////////////////////////////////////////////


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