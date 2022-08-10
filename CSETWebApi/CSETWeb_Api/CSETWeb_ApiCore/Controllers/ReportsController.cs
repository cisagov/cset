//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Aggregation;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

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
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        public ReportsController(CSETContext context, IReportsDataBusiness report, ITokenManager token,
            IAggregationBusiness aggregation, IQuestionBusiness question, IQuestionRequirementManager questionRequirement, 
            IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _report = report;
            _token = token;
            _aggregation = aggregation;
            _question = question;
            _questionRequirement = questionRequirement;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }

        [HttpGet]
        [Route("api/reports/securityplan")]
        public async Task<IActionResult> GetSecurityPlan()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();

            var ss = await _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefaultAsync();
            if (ss != null)
            {
                data.ApplicationMode = ss.Application_Mode;
            }

            data.ControlList = await _report.GetControls(data.ApplicationMode);
            data.genSalTable = await _report.GetGenSals();
            data.information = await _report.GetInformation();
            data.salTable = await _report.GetSals();
            data.nistTypes = await _report.GetNistInfoTypes();
            data.nistSalTable = await _report.GetNistSals();
            data.Zones = await _report.GetDiagramZones();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/executive")]
        public async Task<IActionResult> GetExecutive()
        {
            int assessmentId = await _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = await  _report.GetGenSals();
            data.information = await _report.GetInformation();
            data.salTable = await _report.GetSals();
            data.top5Categories = await _report.GetTop5Categories();
            data.top5Questions = await _report.GetTop5Questions();
            return Ok(data);
        }


        /// <summary>
        /// Returns basic report info plus basic maturity model info
        /// without all of the questions like "executivecmmc" does.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/executivematurity")]
        public async Task<IActionResult> GetExecutiveMaturity()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);
            data.MaturityModels = new List<MaturityReportData.MaturityModel>();
            data.MaturityModels.Add(await _report.GetBasicMaturityModel());
            data.information = await _report.GetInformation();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/executivecmmc")]
        public async Task<IActionResult> GetCMMCReport()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = await _report.GetMaturityModelData();
            data.information = await _report.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/sitesummarycmmc")]
        public async Task<IActionResult> GetSiteSummaryCMMCReport()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);

            data.MaturityModels = await _report.GetMaturityModelData();
            data.information = await _report.GetInformation();
            data.AnalyzeMaturityData();


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            data.MaturityModels.ForEach(d =>
            {
                d.MaturityQuestions.ForEach(q =>
                {
                    q.Answer.Assessment = null;
                });
            });


            return Ok(data);
        }



        //--------------------------------
        // RRA Controllers
        //--------------------------------

        [HttpGet]
        [Route("api/reports/rramain")]
        public async Task<IActionResult> GetRRAMainReport()
        {
            int assessmentId = await _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            ReportsDataBusiness reportsDataManager = new ReportsDataBusiness(_context, _assessmentUtil, _adminTabBusiness, null, mm, _questionRequirement, _token);
            reportsDataManager.SetReportsAssessmentId(assessmentId);

            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = await reportsDataManager.GetMaturityModelData();
            data.information = await reportsDataManager.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/rradetail")]
        public async Task<IActionResult> GetRRADetailReport()
        {
            int assessmentId = await _token.AssessmentForUser();

            await _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            RRASummary summary = new RRASummary(_context);
            MaturityReportDetailData data = new MaturityReportDetailData();
            data.RRASummaryOverall = summary.GetSummaryOverall(assessmentId);
            data.RRASummary = summary.GetRRASummary(assessmentId);
            data.RRASummaryByGoal = summary.GetRRASummaryByGoal(assessmentId);
            data.RRASummaryByGoalOverall = summary.GetRRASummaryByGoalOverall(assessmentId);
            return Ok(data);
        }


        /// <summary>
        /// Returns a list of RRA questions.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/rraquestions")]
        public async Task<IActionResult> GetRRAQuestions()
        {
            var questions = new List<MaturityQuestion>();

            int assessmentId = await _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var resp = await mm.GetMaturityQuestions(assessmentId, "", true);

            // get all supplemental info for questions, because it is not included in the previous method
            var dict = await mm.GetReferences(assessmentId);


            resp.Groupings.First().SubGroupings.ForEach(goal => goal.Questions.ForEach(q =>
            {
                var newQ = new MaturityQuestion
                {
                    Question_Title = q.DisplayNumber,
                    Question_Text = q.QuestionText,
                    Answer = new ANSWER() { Answer_Text = q.Answer },
                    ReferenceText = dict[q.QuestionId]
                };

                questions.Add(newQ);
            }));

            return Ok(questions);
        }



        //--------------------------------
        // VADR Controllers
        //--------------------------------

        [HttpGet]
        [Route("api/reports/vadrmain")]
        public async Task<IActionResult> GetVADRMainReport()
        {
            int assessmentId = await _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            ReportsDataBusiness reportsDataManager = new ReportsDataBusiness(_context, _assessmentUtil, _adminTabBusiness, null, mm, _questionRequirement, _token);
            reportsDataManager.SetReportsAssessmentId(assessmentId);

            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = await reportsDataManager.GetMaturityModelData();
            data.information = await reportsDataManager.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/vadrdetail")]
        public async Task<IActionResult> GetVADRDetailReport()
        {
            int assessmentId = await _token.AssessmentForUser();

            await _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            VADRReports summary = new VADRReports(_context);
            MaturityReportDetailData data = new MaturityReportDetailData();
            data.VADRSummaryOverall = summary.GetSummaryOverall(assessmentId);
            data.VADRSummary = summary.GetVADRSummary(assessmentId);
            data.VADRSummaryByGoal = summary.GetVADRSummaryByGoal(assessmentId);
            data.VADRSummaryByGoalOverall = summary.GetVADRSummaryByGoalOverall(assessmentId);
            return Ok(data);
        }


        /// <summary>
        /// Returns a list of VADR questions.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/vadrquestions")]
        public async Task<IActionResult> GetVADRQuestions()
        {
            var questions = new List<MaturityQuestion>();

            int assessmentId = await _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var resp = await mm.GetMaturityQuestions(assessmentId, "", true);

            // get all supplemental info for questions, because it is not included in the previous method
            //var dict = mm.GetReferences(assessmentId);
            var dict = await mm.GetSourceFiles();


            resp.Groupings.First().SubGroupings.ForEach(goal => goal.Questions.ForEach(q =>
            {
                string refText; 
                if(!dict.TryGetValue(q.QuestionId, out refText))
                {
                    refText = "None";
                }
                var newQ = new MaturityQuestion
                {
                    Question_Title = q.DisplayNumber,
                    Question_Text = q.QuestionText,
                    Answer = new ANSWER() { Answer_Text = q.Answer },
                    ReferenceText = refText
                };

                questions.Add(newQ);
            }));

            return Ok(questions);
        }

        /// <summary>
        /// Returns the information for a report containing 
        /// questions with alternate justification.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/getAltList")]
        public async Task<IActionResult> GetAltList()
        {
            int assessmentId = await _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            var data = new BasicReportData();
            data.QuestionsWithAltJust = await _report.GetQuestionsWithAlternateJustification();
            data.MaturityQuestionsWithAlt = await _report.GetAlternatesList();
            data.information = await _report.GetInformation();


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            data.MaturityQuestionsWithAlt.ForEach(d =>
            {
                d.ANSWER.Assessment = null;
                d.Mat.Maturity_Model = null;
            });


            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/discoveries")]
        public async Task<IActionResult> GetDiscoveries()
        {
            int assessmentId = await _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = await _report.GetInformation();
            data.Individuals = await _report.GetFindingIndividuals();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/sitesummary")]
        public async Task<IActionResult> GetSiteSummary()
        {
            int assessmentId = await _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = await _report.GetGenSals();
            data.information = await _report.GetInformation();
            data.salTable = await _report.GetSals();
            data.nistTypes = await _report.GetNistInfoTypes();
            data.nistSalTable = await _report.GetNistSals();
            data.DocumentLibraryTable = await _report.GetDocumentLibrary();
            data.RankedQuestionsTable = await _report.GetRankedQuestions();
            data.FinancialQuestionsTable = await _report.GetFinancialQuestions();
            data.QuestionsWithComments = await _report.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = await _report.GetQuestionsMarkedForReview();
            data.QuestionsWithAltJust = await _report.GetQuestionsWithAlternateJustification();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/detail")]
        public async Task<IActionResult> GetDetail()
        {
            int assessmentId = await _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.genSalTable = await _report.GetGenSals();
            data.information = await _report.GetInformation();
            data.salTable = await _report.GetSals();
            data.nistTypes = await _report.GetNistInfoTypes();
            data.nistSalTable = await _report.GetNistSals();
            data.DocumentLibraryTable = await _report.GetDocumentLibrary();
            data.RankedQuestionsTable = await _report.GetRankedQuestions();
            data.QuestionsWithComments = await _report.GetQuestionsWithComments();
            data.QuestionsMarkedForReview = await _report.GetQuestionsMarkedForReview();
            data.QuestionsWithAltJust = await _report.GetQuestionsWithAlternateJustification();
            data.StandardsQuestions = await _report.GetQuestionsForEachStandard();
            data.ComponentQuestions = await _report.GetComponentQuestions();
            return Ok(data);
        }


        /// <summary>
        /// Returns data needed for the Trend report.  
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/trendreport")]
        public async Task<IActionResult> GetTrendReport(int aggregationID)
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

            var assessmentList = await _aggregation.GetAssessmentsForAggregation((int)aggregationID);

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
                var salTable = await _report.GetSals();

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
                var documentLibraryTable = await _report.GetDocumentLibrary();
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
        public async Task<IActionResult> GetCompareReport(int aggregationID)
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

            //var aggregationID = _token.PayloadInt("aggreg");
            //if (aggregationID == null)
            //{
            //    return Ok(response);
            //}

            var assessmentList = await _aggregation.GetAssessmentsForAggregation((int)aggregationID);
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
                var salTable = await _report.GetSals();

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
                var documentLibraryTable = await _report.GetDocumentLibrary();
                foreach (var docEntry in documentLibraryTable)
                {
                    docEntry.Alias = a.Alias;
                    response.DocumentLibraryTable.Add(docEntry);
                }
            }

            return Ok(response);
        }

        [HttpGet]
        [Route("api/reports/getconfidentialtypes")]
        public async Task<IActionResult> GetConfidentialTypes()
        {
            return Ok(await _report.GetConfidentialTypes());
        }


        // <summary>
        /// Returns a Q or R indicating the assessment's application mode, Questions or Requirements.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        protected async Task<string> GetApplicationMode(int assessmentId)
        {
            var mode = await _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Application_Mode).FirstOrDefaultAsync();

            if (mode == null)
            {
                // default to Questions mode
                mode = "Q";
                await SetMode(mode);
            }

            return mode;

        }

        private async Task SetMode(string mode)
        {
            int assessmentId = await _token.AssessmentForUser();
            _question.SetQuestionAssessmentId(assessmentId);
            _questionRequirement.SetApplicationMode(mode);
        }


        /// <summary>
        /// Returns questions and supplemental content
        /// for a set or maturity model.
        /// This report is not intended to be something
        /// that a CSET user would view.  The intent is
        /// for confirming new modules under development.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/modulecontent")]
        public async Task<IActionResult> ModuleContentReport([FromQuery] string set)
        {
            var report = new ModuleContentReport(_context, _questionRequirement);
            var resp = report.GetResponse(set);
            return Ok(resp);
        }
    }
}
