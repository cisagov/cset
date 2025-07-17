//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using Microsoft.Extensions.Configuration;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Analytics;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Question;
using CSETWebCore.Business.Question;
using CSETWebCore.Interfaces.Analytics;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class AnalyticsController : ControllerBase
    {
        private readonly IRequirementBusiness _requirement;
        private readonly IAssessmentBusiness _assessment;
        private readonly ITokenManager _token;
        private readonly IDemographicBusiness _demographic;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly IQuestionBusiness _question;
        private readonly IAnalyticsBusiness _analytics;
        private readonly IConfiguration _configuration;

        public AnalyticsController(IRequirementBusiness requirement, IAssessmentBusiness assessment,
            ITokenManager token, IDemographicBusiness demographic,
            IQuestionRequirementManager questionRequirement,
            IQuestionBusiness question, IAnalyticsBusiness analytics,
            IConfiguration configuration)
        {
            _requirement = requirement;
            _assessment = assessment;
            _token = token;
            _demographic = demographic;
            _questionRequirement = questionRequirement;
            _question = question;
            _analytics = analytics;
            _configuration = configuration;
        }

        /// <summary>
        /// Get analytic information
        /// </summary>
        /// <returns></returns>
        // [HttpGet]
        // [Route("api/analytics/getAnalytics")]
        // public IActionResult GetAnalytics()
        // {
        //     var demographics = GetDemographics();
        //     var assessment = GetAnalyticsAssessment();
        //     assessment.Assets = demographics.AssetValue;
        //     assessment.Size = demographics.Size;
        //     assessment.IndustryId = demographics.IndustryId;
        //     assessment.SectorId = demographics.SectorId;
        //
        //     return Ok(new Analytics
        //     {
        //         Assessment = assessment,
        //         Demographics = demographics,
        //         QuestionAnswers = GetQuestionsAnswers()
        //     });
        // }

        [HttpGet]
        [Route("api/analytics/getAggregation")]
        public IActionResult GetAggregation()
        {
            int assessmentId = _token.AssessmentForUser();
            var agg = _analytics.GetAggregationAssessment(assessmentId);

            return Ok(agg);
        }
        

        [HttpGet]
        [Route("api/analytics/maturity/bars")]
        public IActionResult GetAnalyticsNew(int modelId, int? sectorId, int? industryId)
        {
            int assessmentId = _token.AssessmentForUser();
            string connectionString = _configuration.GetConnectionString("CSET_DB") ?? "";

            var dtPool = new DataTable();
            var dtTargetAssessment = new DataTable();
            var SampleSize = new DataTable();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("analytics_setup_maturity_groupings", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.ExecuteNonQuery();
                }
                using (SqlCommand command = new SqlCommand("FillAll", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    // Add input parameter
                    command.Parameters.Add(new SqlParameter("@assessment_id", assessmentId));
                    command.ExecuteNonQuery();
                }

                using (SqlCommand command = new SqlCommand("analytics_Compute_MaturityAll", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Add input parameter
                    command.Parameters.Add(new SqlParameter("@maturity_model_id", modelId));
                    command.Parameters.Add(new SqlParameter("@sector_id", sectorId));
                    command.Parameters.Add(new SqlParameter("@industry_id", industryId));

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        dtPool.Load(reader);
                    }
                }


                using (SqlCommand command = new SqlCommand("analytics_compute_single_averages_maturity", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Add input parameter
                    command.Parameters.Add(new SqlParameter("@assessment_id", assessmentId));
                    command.Parameters.Add(new SqlParameter("@maturity_model_id", modelId));

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        dtTargetAssessment.Load(reader);
                    }
                }

                using (SqlCommand command = new SqlCommand("analytics_Compute_MaturitySampleSize", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    // Add input parameter
                    command.Parameters.Add(new SqlParameter("@maturity_model_id", modelId));
                    command.Parameters.Add(new SqlParameter("@sector_id", sectorId));

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        SampleSize.Load(reader);
                    }
                }

            }


            /*
        categories: any[] = [
    { label: 'Invent', min: 10, max: 77, median: 42, myScore: 33},
    { label: 'Prevent', min: 40, max: 95, median: 61, myScore: 83},
    { label: 'Circumvent', min: 25, max: 54, median: 33, myScore: 50},
    { label: 'Dryer Vent', min: 0, max: 94, median: 67, myScore: 23},
    { label: 'Lament', min: 47, max: 62, median: 52, myScore: 47},
    { label: 'Intent', min: 8, max: 80, median: 63, myScore: 33},
    { label: 'Get Bent', min: 14, max: 58, median: 36, myScore: 29}
  ];
        */

            var response = new NewResponse();

            foreach (DataRow row in dtPool.Rows)
            {
                var cat = new Category();

                response.Categories.Add(cat);

                cat.Label = row["Question_Group_Heading"].ToString() ?? "[unknown]";

                cat.Min = (double)row["minimum"];
                cat.Max = (double)row["maximum"];
                cat.Avg = (double)row["average"];
                cat.Median = (int)row["median"];
            }


            foreach (DataRow row in dtTargetAssessment.Rows)
            {
                var r = response.Categories.FirstOrDefault(x => x.Label == row["title"].ToString());
                if (r != null)
                {
                    r.MyScore = (int)row["Percentage"];
                }
            }


            int total_count = 0;
            foreach (DataRow row in SampleSize.Rows)
            {
                if (sectorId == null)
                {
                    if (row["SectorId"].ToString() == "")
                    {
                        total_count += Convert.ToInt32(row["AssessmentCount"]);
                        break;
                    }
                }

                else if (sectorId == Convert.ToInt32(row["SectorId"]))
                {
                    total_count += Convert.ToInt32(row["AssessmentCount"]);
                    break;
                }
                else
                {
                    total_count += Convert.ToInt32(row["AssessmentCount"]);
                    break;
                }
            }
            response.SampleSize = total_count;


            return Ok(response);
        }


        private AnalyticsAssessment GetAnalyticsAssessment()
        {
            int assessmentId = _token.AssessmentForUser();
            var assessment = _assessment.GetAnalyticsAssessmentDetail(assessmentId);
            return assessment;
        }

        /// <summary>
        /// Returns an instance of Demographics for Anonymous export 
        /// </summary>        
        /// <returns></returns>
        // private AnalyticsDemographic GetDemographics()
        // {
        //     int assessmentId = _token.AssessmentForUser();
        //     return _demographic.GetAnonymousDemographics(assessmentId);
        // }

        /// <summary>
        /// Returns questions/answers for current selected assessment
        /// </summary>
        /// <returns></returns>
        private List<AnalyticsQuestionAnswer> GetQuestionsAnswers()
        {
            int assessmentId = _token.AssessmentForUser();
            string applicationMode = _questionRequirement.GetApplicationMode(assessmentId);

            if (applicationMode.ToLower().StartsWith("questions"))
            {
                _question.SetQuestionAssessmentId(assessmentId);
                QuestionResponse resp = _question.GetQuestionListWithSet("*");
                return _question.GetAnalyticQuestionAnswers(resp).OrderBy(x => x.QuestionId).ToList();
            }
            else
            {
                _requirement.SetRequirementAssessmentId(assessmentId);
                QuestionResponse resp = _requirement.GetRequirementsList();
                return _question.GetAnalyticQuestionAnswers(resp).OrderBy(x => x.QuestionId).ToList();
            }
        }
    }

        public class NewResponse
    {
        public List<Category> Categories { get; set; } = [];
        public int SampleSize { get; set; } = 0;
    }


    public class Category
    {
        public string Label { get; set; }
        public double Min { get; set; }
        public double Max { get; set; }
        public double Median { get; set; }
        public double Avg { get; set; }
        public double MyScore { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class AnalyticsResponse
    {
        public List<double> Min { get; set; } = [];
        public List<double> Max { get; set; } = [];
        public List<int> Median { get; set; } = [];
        public List<double> Average { get; set; } = [];
        public BarItem BarData { get; set; } = new BarItem();
        public int SampleSize { get; set; } = 0;
    }

    public class BarItem
    {
        public List<double> Values { get; set; } = [];
        public List<string> Labels { get; set; } = [];
    }
}
