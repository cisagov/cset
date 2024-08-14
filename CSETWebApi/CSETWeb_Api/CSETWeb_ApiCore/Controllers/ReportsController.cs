//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.GalleryParser;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.CisaAssessorWorkflow;
using CSETWebCore.Model.Demographic;
using CSETWebCore.Model.Reports;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Linq;


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
        private readonly IGalleryEditor _galleryEditor;
        private TranslationOverlay _overlay;
        private readonly IDocumentBusiness _documentBusiness;


        public ReportsController(CSETContext context, IReportsDataBusiness report, ITokenManager token,
            IAggregationBusiness aggregation, IQuestionBusiness question, IQuestionRequirementManager questionRequirement,
            IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IGalleryEditor galleryEditor,
            IDocumentBusiness documentBusiness)
        {
            _context = context;
            _report = report;
            _token = token;
            _aggregation = aggregation;
            _question = question;
            _questionRequirement = questionRequirement;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _galleryEditor = galleryEditor;
            _overlay = new TranslationOverlay();
            _documentBusiness = documentBusiness;
        }


        [HttpGet]
        [Route("api/reports/info")]
        public IActionResult GetAssessmentInfoForReport()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData.INFORMATION info = _report.GetInformation();

            return Ok(info);
        }


        [HttpGet]
        [Route("api/reports/securityplan")]
        public IActionResult GetSecurityPlan()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();

            var ss = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (ss != null)
            {
                data.ApplicationMode = ss.Application_Mode;
            }
            // Check if assessment is a diagram 
            data.information = _report.GetInformation();
            if (data.information.UseDiagram == true)
            {

                data.ControlList = _report.GetControlsDiagram(data.ApplicationMode);

            }
            else
            {
                data.ControlList = _report.GetControls(data.ApplicationMode);
            }

            data.genSalTable = _report.GetGenSals();
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

            data.genSalTable = _report.GetGenSals();
            data.salTable = _report.GetSals();
            data.nistTypes = _report.GetNistInfoTypes();
            data.nistSalTable = _report.GetNistSals();

            data.top5Categories = _report.GetTop5Categories();
            data.top5Questions = _report.GetTop5Questions();
            return Ok(data);
        }


        /// <summary>
        /// Returns basic report info plus basic maturity model info
        /// without all of the questions like "executivecmmc" does.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/executivematurity")]
        public IActionResult GetExecutiveMaturity()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData data = new MaturityReportData(_context);
            data.MaturityModels = new List<MaturityReportData.MaturityModel>();
            data.MaturityModels.Add(_report.GetBasicMaturityModel());
            data.information = _report.GetInformation();

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
        public IActionResult GetRRAMainReport()
        {
            int assessmentId = _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            ReportsDataBusiness reportsDataManager = new ReportsDataBusiness(_context, _assessmentUtil, _adminTabBusiness, null, mm, _questionRequirement, _token);
            reportsDataManager.SetReportsAssessmentId(assessmentId);

            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = reportsDataManager.GetMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/rradetail")]
        public IActionResult GetRRADetailReport()
        {
            int assessmentId = _token.AssessmentForUser();
            var lang = _token.GetCurrentLanguage();

            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            RRASummary summary = new RRASummary(_context);
            MaturityReportDetailData data = new MaturityReportDetailData();
            data.RRASummaryOverall = summary.GetSummaryOverall(assessmentId);


            data.RRASummary = summary.GetRRASummary(assessmentId);

            data.RRASummaryByGoal = summary.GetRRASummaryByGoal(assessmentId);

            foreach (DataLayer.Manual.usp_getRRASummaryByGoal q in data.RRASummaryByGoal)
            {
                var o = _overlay.GetMaturityGrouping(q.Grouping_Id, lang);
                if (o != null)
                {
                    q.Title = o.Title;
                }
            }

            data.RRASummaryByGoalOverall = summary.GetRRASummaryByGoalOverall(assessmentId);
            return Ok(data);
        }


        /// <summary>
        /// Returns a list of RRA questions.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/rraquestions")]
        public IActionResult GetRRAQuestions()
        {
            var questions = new List<MaturityQuestion>();

            int assessmentId = _token.AssessmentForUser();
            string lang = _token.GetCurrentLanguage();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var resp = biz.GetMaturityQuestions(assessmentId, true, 0, lang);

            // get all supplemental info for questions, because it is not included in the previous method
            var dict = biz.GetReferences(assessmentId);


            resp.Groupings.First().SubGroupings.ForEach(goal => goal.Questions.ForEach(q =>
            {
                var newQ = new MaturityQuestion
                {
                    Mat_Question_Id = q.QuestionId,
                    Question_Title = q.DisplayNumber,
                    Question_Text = q.QuestionText,
                    Answer = new ANSWER() { Answer_Text = q.Answer },
                    ReferenceText = dict[q.QuestionId]
                };

                questions.Add(newQ);
            }));

            foreach (MaturityQuestion q in questions)
            {
                var translatedGroup = _overlay.GetMaturityQuestion(q.Mat_Question_Id, lang);
                if (translatedGroup != null)
                {
                    q.Question_Text = translatedGroup.QuestionText;
                    q.ReferenceText = translatedGroup.ReferenceText;
                }
            }

            return Ok(questions);
        }



        //--------------------------------
        // VADR Controllers
        //--------------------------------

        [HttpGet]
        [Route("api/reports/vadrmain")]
        public IActionResult GetVADRMainReport()
        {
            int assessmentId = _token.AssessmentForUser();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            ReportsDataBusiness reportsDataManager = new ReportsDataBusiness(_context, _assessmentUtil, _adminTabBusiness, null, mm, _questionRequirement, _token);
            reportsDataManager.SetReportsAssessmentId(assessmentId);

            MaturityReportData data = new MaturityReportData(_context);
            data.AnalyzeMaturityData();
            data.MaturityModels = reportsDataManager.GetMaturityModelData();
            data.information = reportsDataManager.GetInformation();
            data.AnalyzeMaturityData();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/vadrdetail")]
        public IActionResult GetVADRDetailReport()
        {
            int assessmentId = _token.AssessmentForUser();

            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

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
        public IActionResult GetVADRQuestions()
        {
            var questions = new List<MaturityQuestion>();

            int assessmentId = _token.AssessmentForUser();
            string lang = _token.GetCurrentLanguage();

            var mm = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var resp = mm.GetMaturityQuestions(assessmentId, true, 0, lang);

            // get all supplemental info for questions, because it is not included in the previous method
            var dict = mm.GetSourceFiles();


            resp.Groupings.ForEach(g =>
            {
                g.SubGroupings.ForEach(goal => goal.Questions.ForEach(q =>
                {
                    string refText;
                    if (!dict.TryGetValue(q.QuestionId, out refText))
                    {
                        refText = "None";
                    }
                    var newQ = new MaturityQuestion
                    {
                        Question_Title = q.DisplayNumber,
                        Question_Text = q.QuestionText,
                        Answer = new ANSWER() { Answer_Text = q.Answer },
                        ReferenceText = refText,
                        Parent_Question_Id = q.ParentQuestionId
                    };

                    questions.Add(newQ);
                }));
            });

            return Ok(questions);
        }



        //--------------------------------
        // HYDRO Controllers
        //--------------------------------

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/getHydroDonutData")]
        public IActionResult GetHydroDonutData()
        {
            int assessmentId = _token.AssessmentForUser();
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            var hmm = new HydroMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            return Ok(hmm.GetHydroDonutData(assessmentId));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/getHydroActionItems")]
        public IActionResult GetHydroActionItems()
        {
            int assessmentId = _token.AssessmentForUser();
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            var hmm = new HydroMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            return Ok(hmm.GetHydroActions(assessmentId));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/getHydroActionItemsReport")]
        public IActionResult GetHydroActionItemsReport()
        {
            int assessmentId = _token.AssessmentForUser();
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            var hmm = new HydroMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            return Ok(hmm.GetHydroActionsReport(assessmentId));
        }


        //--------------------------------
        // MVRA Controllers
        //--------------------------------


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/mvradetail")]
        public IActionResult MvraDetail()
        {
            int assessmentId = _token.AssessmentForUser();

            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MvraSummary summary = new MvraSummary(_context);

            object o = new object();
            return Ok(o);
        }


        /// <summary>
        /// Returns the information for a report containing 
        /// questions with alternate justification.
        /// </summary>
        /// <returns></returns>
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


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            data.MaturityQuestionsWithAlt.ForEach(d =>
            {
                d.ANSWER.Assessment = null;
                d.Mat.Maturity_Model = null;
            });

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/observations")]
        public IActionResult GetObservations()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = _report.GetInformation();
            data.Individuals = _report.GetObservationIndividuals();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/sitesummary")]
        public IActionResult GetSiteSummary()
        {
            int assessmentId = _token.AssessmentForUser();

            _report.SetReportsAssessmentId(assessmentId);
            BasicReportData data = new BasicReportData();
            data.information = _report.GetInformation();

            data.genSalTable = _report.GetGenSals();
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
            data.information = _report.GetInformation();

            data.genSalTable = _report.GetGenSals();
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
        public IActionResult GetTrendReport(int aggregationID)
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

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
        public IActionResult GetCompareReport(int aggregationID)
        {
            AggregationReportData response = new AggregationReportData();
            response.SalList = new List<BasicReportData.OverallSALTable>();
            response.DocumentLibraryTable = new List<DocumentLibraryTable>();

            //var aggregationID = _token.PayloadInt("aggreg");
            //if (aggregationID == null)
            //{
            //    return Ok(response);
            //}

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

        [HttpGet]
        [Route("api/reports/getconfidentialtypes")]
        public IActionResult GetConfidentialTypes()
        {
            return Ok(_report.GetConfidentialTypes());
        }


        // <summary>
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
        public IActionResult ModuleContentReport([FromQuery] string set)
        {
            var lang = _token.GetCurrentLanguage();

            var report = new ModuleContentReport(_context, _questionRequirement, _galleryEditor);
            report.SetLanguage(lang);
            var resp = report.GetResponse(set);
            return Ok(resp);
        }

        /// <summary>
        /// Validates the required fields for the CISA Assessor Workflow in order to unlock reports and export.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reports/CisaAssessorWorkflowValidateFields")]
        public IActionResult CisaAssessorWorkflowValidateFields()
        {
            var assessmentId = _token.AssessmentForUser();

            var iodDemoBusiness = new DemographicExtBusiness(_context);
            var demoBusiness = new DemographicBusiness(_context, _assessmentUtil);
            var cisServiceDemographicBusiness = new CisDemographicBusiness(_context, _assessmentUtil);

            Demographics demographics = demoBusiness.GetDemographics(assessmentId);
            DemographicExt iodDemograhics = iodDemoBusiness.GetDemographics(assessmentId);
            CisServiceDemographics cisServiceDemographics = cisServiceDemographicBusiness.GetServiceDemographics(assessmentId);
            CisServiceComposition cisServiceComposition = cisServiceDemographicBusiness.GetServiceComposition(assessmentId);

            CisaAssessorWorkflowFieldValidator validator = new CisaAssessorWorkflowFieldValidator(demographics, iodDemograhics, cisServiceDemographics, cisServiceComposition);
            return Ok(validator.ValidateFields());
        }


        
        [HttpGet]
        [Route("api/reports/getCieAllQuestions")]
        public IActionResult GetCieAllQuestions()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            data.MatAnsweredQuestions = _report.GetCieQuestionList(0);
            data.Information = _report.GetInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/getCiePrincipleQuestions")]
        public IActionResult getCiePrincipleQuestions()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            data.MatAnsweredQuestions = _report.GetCieQuestionList(5);
            data.Information = _report.GetInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/getCiePhaseQuestions")]
        public IActionResult getCiePhaseQuestions()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            // the '4' signals to get levels 1 - 4
            data.MatAnsweredQuestions = _report.GetCieQuestionList(4);
            data.Information = _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/getCieNaQuestions")]
        public IActionResult getCieNaQuestions()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            // the '4' signals to get levels 1 - 4
            data.MatAnsweredQuestions = _report.GetCieQuestionList(0, true);
            data.Information = _report.GetInformation();
            return Ok(data);
        }


        /// <summary>
        /// Returns a collection of all documents attached to any question in the Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cieAssessmentDocuments")]
        public IActionResult CieAssessmentDocuments()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _documentBusiness.SetUserAssessmentId(assessmentId);

            var data = new DocumentsReport();
            data.information = _report.GetInformation();
            //data.documents = _report.GetCieDocumentsForAssessment();

            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/getCieAllQuestionsWithDocuments")]
        public IActionResult GetCieAllQuestionsWithDocuments()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            data.MatAnsweredQuestions = _report.GetCieDocumentsForAssessment();
            data.Information = _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/getCieAllMfrQuestionsWithDocuments")]
        public IActionResult GetCieAllMfrQuestionsWithDocuments()
        {
            var assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            MaturityBasicReportData data = new MaturityBasicReportData();

            data.MatAnsweredQuestions = _report.GetCieMfrQuestionList();
            data.Information = _report.GetInformation();
            return Ok(data);
        }
        //[HttpGet]
        //[Route("api/reports/getCieNaQuestions")]
        //public IActionResult getCieNaQuestions()
        //{
        //    var assessmentId = _token.AssessmentForUser();
        //    _report.SetReportsAssessmentId(assessmentId);
        //    _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

        //    MaturityBasicReportData data = new MaturityBasicReportData();

        //    // the '4' signals to get levels 1 - 4
        //    data.MatAnsweredQuestions = _report.GetCieQuestionList(0, true);
        //    data.Information = _report.GetInformation();
        //    return Ok(data);
        //}
    }
}
