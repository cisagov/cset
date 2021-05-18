using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly CSETContext _context;
        private readonly IReportsDataBusiness _report;
        private readonly ITokenManager _token;
        private readonly IAggregationBusiness _aggregation;
        private readonly IQuestionBusiness _question;
        private readonly IQuestionRequirementManager _questionRequirement;

        public ReportsController(CSETContext context, IReportsDataBusiness report, ITokenManager token,
            IAggregationBusiness aggregation, IQuestionBusiness question, IQuestionRequirementManager questionRequirement)
        {
            _context = context;
            _report = report;
            _token = token;
            _aggregation = aggregation;
            _question = question;
            _questionRequirement = questionRequirement;
        }
        
        [HttpGet]
        [Route("api/reports/securityplan")]
        public IActionResult GetSecurityPlan()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.ControlList = _report.GetControls();
            data.genSalTable = _report.GetGenSals();
            data.information = _report.GetInformation();
            data.salTable = _report.GetSals();
            data.nistTypes = _report.GetNistInfoTypes();
            data.nistSalTable = _report.GetNistSals();
            data.Zones = _report.GetDiagramZones();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/executive")]
        public IActionResult GetExecutive()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = _report.GetInformation();
            data.top5Categories = _report.GetTop5Categories();
            data.top5Questions = _report.GetTop5Questions();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/executivecmmc")]
        public IActionResult GetCMMCReport()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = _report.GetMaturityModelData();
            data.information = _report.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/sitesummarycmmc")]
        public IActionResult GetSiteSummaryCMMCReport()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);

            data.MaturityModels = _report.GetMaturityModelData();
            data.information = _report.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/getAltList")]
        public IActionResult GetAltList()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            var data = new BasicReportData();
            data.QuestionsWithAltJust = _report.GetQuestionsWithAlternateJustification();
            data.MaturityQuestionsWithAlt = _report.GetAlternatesList();
            data.information = _report.GetInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/discoveries")]
        public IActionResult GetDiscoveries()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = _report.GetInformation();
            data.Individuals = _report.GetFindingIndividuals();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/sitesummary")]
        public IActionResult GetSiteSummary()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = _report.GetGenSals();
            data.information = _report.GetInformation();
            data.salTable = _report.GetSals();
            data.nistTypes = _report.GetNistInfoTypes();
            data.nistSalTable = _report.GetNistSals();
            data.DocumentLibraryTable = _report.GetDocumentLibrary();
            data.RankedQuestionsTable = _report.GetRankedQuestions();
            data.FinancialQuestionsTable = _report.GetFinancialQuestions();
            data.QuestionsWithComments = _report.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = _report.GetQuestionsMarkedForReview();
            data.QuestionsWithAltJust = _report.GetQuestionsWithAlternateJustification();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/detail")]
        public IActionResult GetDetail()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = _report.GetGenSals();
            data.information = _report.GetInformation();
            data.salTable = _report.GetSals();
            data.nistTypes = _report.GetNistInfoTypes();
            data.nistSalTable = _report.GetNistSals();
            data.DocumentLibraryTable = _report.GetDocumentLibrary();
            data.RankedQuestionsTable = _report.GetRankedQuestions();
            data.QuestionsWithComments = _report.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = _report.GetQuestionsMarkedForReview();
            data.QuestionsWithAltJust = _report.GetQuestionsWithAlternateJustification();
            data.StandardsQuestions = _report.GetQuestionsForEachStandard();
            data.ComponentQuestions = _report.GetComponentQuestions();
            return Ok(data);
        }


        /// <summary>
        /// Returns data needed for the Trend report.  
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/trendreport")]
        public IActionResult GetTrendReport()
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

            var aggregationID = _token.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok(response);
            }

            var assessmentList = _aggregation.GetAssessmentsForAggregation((int)aggregationID);

            var aggregation = _aggregation.GetAggregation((int)aggregationID);


            response.AggregationName = assessmentList.Aggregation.AggregationName;
            response.Information = new AggInformation()
            {
                Assessment_Date = aggregation.AggregationDate,
                Assessment_Name = aggregation.AggregationName,
                Assessor_Name = aggregation.AssessorName
            };

            foreach (var a in assessmentList.Assessments)
            {
                _report.SetReportsAssessmentId(a.AssessmentId);
                // Incorporate SAL values into response
                var salTable = _report.GetSals();

                var entry = new BasicReportData.OverallSALTable();
                response.SalList.Add(entry);
                entry.Alias = a.Alias;
                entry.OSV = salTable.OSV;
                entry.Q_CV = "";
                entry.Q_IV = "";
                entry.Q_AV = "";
                entry.LastSalDeterminationType = salTable.LastSalDeterminationType;

                if (salTable.LastSalDeterminationType != "GENERAL")
                {
                    entry.Q_CV = salTable.Q_CV;
                    entry.Q_IV = salTable.Q_IV;
                    entry.Q_AV = salTable.Q_AV;
                }


                // Document Library 
                var documentLibraryTable = _report.GetDocumentLibrary();
                foreach (var docEntry in documentLibraryTable)
                {
                    docEntry.Alias = a.Alias;
                    response.DocumentLibraryTable.Add(docEntry);
                }
            }

            return Ok(response);
        }

        /// <summary>
        /// Returns data needed for the Compare report.  
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/comparereport")]
        public IActionResult GetCompareReport()
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

            var aggregationID = _token.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok(response);
            }

            var assessmentList = _aggregation.GetAssessmentsForAggregation((int)aggregationID);
            Aggregation ag = _aggregation.GetAggregation((int)aggregationID);
            response.AggregationName = assessmentList.Aggregation.AggregationName;

            response.Information = new AggInformation()
            {
                Assessment_Name = ag.AggregationName,
                Assessment_Date = ag.AggregationDate,
                Assessor_Name = ag.AssessorName
            };

            foreach (var a in assessmentList.Assessments)
            {
                _report.SetReportsAssessmentId(a.AssessmentId);
                // Incorporate SAL values into response
                var salTable = _report.GetSals();

                var entry = new BasicReportData.OverallSALTable();
                response.SalList.Add(entry);
                entry.Alias = a.Alias;
                entry.OSV = salTable.OSV;
                entry.Q_CV = "";
                entry.Q_IV = "";
                entry.Q_AV = "";
                entry.LastSalDeterminationType = salTable.LastSalDeterminationType;

                if (salTable.LastSalDeterminationType != "GENERAL")
                {
                    entry.Q_CV = salTable.Q_CV;
                    entry.Q_IV = salTable.Q_IV;
                    entry.Q_AV = salTable.Q_AV;
                }


                // Document Library 
                var documentLibraryTable = _report.GetDocumentLibrary();
                foreach (var docEntry in documentLibraryTable)
                {
                    docEntry.Alias = a.Alias;
                    response.DocumentLibraryTable.Add(docEntry);
                }
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns a Q or R indicating the assessment's application mode, Questions or Requirements.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        protected string GetApplicationMode(int assessmentId)
        {
            var mode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Application_Mode).FirstOrDefault();

            if (mode == null)
            {
                // default to Questions mode
                mode = "Q";
                SetMode(mode);
            }

            return mode;
        
        }


        private void SetMode(string mode)
        {
            int assessmentId = _token.AssessmentForUser();
            _question.SetQuestionAssessmentId(assessmentId);
            _questionRequirement.SetApplicationMode(mode);
        }
    }
}
