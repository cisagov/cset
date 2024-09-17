//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Nested;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.XPath;


namespace CSETWebCore.Api.Controllers
{
    public class MaturityController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;

        public MaturityController(ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>
        /// Get all maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityModel")]
        public IActionResult GetMaturityModel()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessmentId));
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityModel")]
        public IActionResult SetMaturityModel(string modelName)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(assessmentId, modelName);
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessmentId));
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityModel/DomainRemarks")]
        public IActionResult GetDomainRemarks()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetDomainRemarks(assessmentId));
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityModel/DomainRemarks")]
        public IActionResult SetDomainRemarks([FromBody] MaturityDomainRemarks remarks)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).SetDomainRemarks(assessmentId, remarks);
            return Ok();
        }


        /// <summary>
        /// Return the current maturity level for an assessment.
        /// Currently returns an int, but could be expanded
        /// if more data needed.
        /// </summary>
        [HttpGet]
        [Route("api/MaturityLevel")]
        public IActionResult GetMaturityLevel()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityLevel(assessmentId));
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityLevel")]
        public IActionResult SetMaturityLevel([FromBody] int level)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistMaturityLevel(assessmentId, level);
            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/maturity/questions")]
        public IActionResult GetQuestions(bool fill, int groupingId = 0)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string lang = _tokenManager.GetCurrentLanguage();
            string installationMode = _tokenManager.Payload("scope");

            if (installationMode == "ACET")
            {
                return Ok(new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityQuestions(assessmentId, fill, groupingId, lang));
            }

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityQuestions(assessmentId, fill, groupingId, lang));
        }


        /// <summary>
        /// Returns a "bonus" maturity model.  This is the generic term being used
        /// for the Sector-Specific Goal (SSG) models that are appended to a CPG assessment.
        /// </summary>
        [HttpGet]
        [Route("api/maturity/questions/bonus")]
        public IActionResult GetBonusModelQuestions([FromQuery] int m)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string lang = _tokenManager.GetCurrentLanguage();

            MaturityResponse resp = new();

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityQuestions(
                assessmentId, false, 0, resp, m, lang));
        }


        [HttpGet]
        [Route("api/maturity/targetlevel")]
        public IActionResult GetTargetLevel()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetTargetLevel(assessmentId));
        }


        [HttpGet]
        [Route("api/MaturityModel/GetLevelScoresByGroup")]
        public IActionResult GetLevelScoresByGroup(int mat_model_id)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness)
                .Get_LevelScoresByGroup(assessmentId, mat_model_id));
        }


        /// <summary>        
        /// </summary>
        [HttpGet]
        [Route("api/SPRSScore")]
        public IActionResult GetSPRSScore()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetSPRSScore(assessmentId));
        }


        [HttpGet]
        [Route("api/results/compliancebylevel")]
        public IActionResult GetComplianceByLevel()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAnswerDistributionByLevel(assessmentId));
        }


        [HttpGet]
        [Route("api/results/compliancebydomain")]
        public IActionResult GetComplianceByDomain()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAnswerDistributionByDomain(assessmentId));
        }


        /// <summary>
        /// Returns the maturity grouping/question structure for an assessment.
        /// Specifying a query parameter of domainAbbreviation will limit the response
        /// to a single domain.
        /// </summary>
        [HttpGet]
        [Route("api/MaturityStructure")]
        public IActionResult GetQuestions([FromQuery] string domainAbbrev)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructureAsXml(assessmentId, true);


            var j = "";
            if (string.IsNullOrEmpty(domainAbbrev))
            {
                j = Helpers.CustomJsonWriter.Serialize(x.Root);
            }
            else
            {
                var domain = x.Root.XPathSelectElement($"//Domain[@abbreviation='{domainAbbrev}']");
                j = Helpers.CustomJsonWriter.Serialize(domain);
            }

            return Ok(j);
        }


        [HttpGet]
        [Route("api/maturity/structure")]
        public IActionResult GetGroupingAndQuestions([FromQuery] int modelId)
        {
            int assessmentId = 0;

            try
            {
                assessmentId = _tokenManager.AssessmentForUser();
                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

                // if the assessment ID is provided we will derive the modelId
                var xy = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                if (xy != null)
                {
                    modelId = xy.model_id;
                }
            }
            catch (Exception)
            {
                // It's okay to call this controller method
                // without an assessment ID for the module content report
            }

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructureForModel(modelId, assessmentId);

            return Ok(x.Model);
        }


        [HttpGet]
        [Route("api/maturity/groupingtitles")]
        public IActionResult GetGroupingTitles([FromQuery] int modelId)
        {
            var lang = _tokenManager.GetCurrentLanguage();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetGroupingTitles(modelId, lang);

            return Ok(x);
        }


        /// <summary>
        /// Returns the questions in a CIS section.
        /// </summary>
        /// <param name="sectionId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/nested/questions")]
        public IActionResult GetNestedGroupingAndQuestions([FromQuery] int sectionId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new NestedStructure(assessmentId, sectionId, _context);

            return Ok(biz.MyModel);
        }


        /// <summary>
        /// Returns the questions in a HYDRO section.
        /// </summary>
        /// <param name="subCatIds"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/hydro/getBulkSubCatIds")]
        public IActionResult GetBulkSubCatIds([FromQuery] string[] subCatIds)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            List<NestedQuestions> bizList = new List<NestedQuestions>();

            subCatIds = subCatIds[0].Split(',');

            foreach (string id in subCatIds)
            {
                var biz = new NestedStructure(assessmentId, int.Parse(id), _context);
                bizList.Add(biz.MyModel);
            }

            return Ok(bizList);
        }


        [HttpGet]
        [Route("api/maturity/hydro/getResultsData")]
        public IActionResult GetResultsData()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new HydroMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetResultsData(assessmentId));
        }


        [HttpGet]
        [Route("api/maturity/hydro/getProgressText")]
        public IActionResult getProgressText()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new HydroMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetHydroProgress());
        }


        /// <summary>
        /// Returns a single grouping's worth of questions.  This is done by 
        /// instantiating a CisStructure for the grouping and then converting
        /// that object to a MaturityResponse, which is the packaging that
        /// the maturity-questions page needs.
        /// </summary>
        /// <param name="groupingId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/questions/grouping")]
        public IActionResult GetGrouping([FromQuery] int groupingId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var grouping = _context.MATURITY_GROUPINGS.FirstOrDefault(x => x.Grouping_Id == groupingId);
            if (grouping == null)
            {
                return BadRequest("Unknown maturity grouping");
            }


            // get grouping CisStructure
            var biz = new NestedStructure(assessmentId, groupingId, _context);
            var resp1 = biz.MyModel;

            // convert it to a MaturityResponse
            MaturityResponse resp = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).ConvertToMaturityResponse(resp1);
            var excel = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var model = _context.MATURITY_MODELS.FirstOrDefault(x => x.Maturity_Model_Id == grouping.Maturity_Model_Id);
            resp.ModelName = model.Model_Name;
            resp.ModelId = model.Maturity_Model_Id;
            resp.QuestionsAlias = model.Questions_Alias ?? "Questions";

            if (model.Answer_Options != null)
            {
                resp.AnswerOptions = model.Answer_Options.Split(',').ToList();
                resp.AnswerOptions.ForEach(x => x = x.Trim());
            }

            resp.Title = grouping.Title;
            resp.Description = grouping.Description;
            resp.Description_Extended = grouping.Description_Extended;

            return Ok(resp);
        }


        /// <summary>
        /// Returns list of CIE assessments accessible to the current user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/cie/myCieAssessments")]
        public IActionResult GetCieAssessments()
        {
            var assessmentId = _tokenManager.AssessmentForUser();
            var userId = _tokenManager.PayloadInt(Constants.Constants.Token_UserId);

            var biz = new CieQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            var x = biz.GetMyCieAssessments(assessmentId, userId);

            return Ok(x);
        }


        /// <summary>
        /// Returns list of CIS assessments accessible to the current user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/cis/mycisassessments")]
        public IActionResult GetCisAssessments()
        {
            var assessmentId = _tokenManager.AssessmentForUser();
            var userId = _tokenManager.PayloadInt(Constants.Constants.Token_UserId);

            var biz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            var x = biz.GetMyCisAssessments(assessmentId, userId);

            return Ok(x);
        }


        /// <summary>
        /// Persists the selected baseline assessment
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/maturity/cis/baseline")]
        public IActionResult SaveBaseline([FromBody] int? baselineId)
        {
            var assessmentId = _tokenManager.AssessmentForUser();

            var biz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            biz.SaveBaseline(assessmentId, baselineId);

            return Ok();
        }

        /// <summary>
        /// Get deficiency chart data for comparative between current assessment and baseline
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/cis/getDeficiency")]
        public IActionResult GetDeficiency()
        {
            var assessmentId = _tokenManager.AssessmentForUser();
            var cisBiz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            var chartData = cisBiz.GetDeficiencyChartData();

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/maturity/cis/sectionscoring")]
        public IActionResult GetSectionScoring()
        {
            var assessmentId = _tokenManager.AssessmentForUser();
            var cisBiz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            var chartData = cisBiz.GetSectionScoringCharts();

            return Ok(chartData);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/maturity/cis/importsurvey")]
        public IActionResult ImportSurvey([FromBody] Model.Nested.CisImportRequest request)
        {
            var assessmentId = _tokenManager.AssessmentForUser();
            var biz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            biz.ImportCisAnswers(request.Dest, request.Source);

            return Ok();
        }


        /// <summary>
        /// Get all of the possible cis options that can fail the integrity check.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/cis/integritycheck")]
        public IActionResult GetIntegrityCheckOptions()
        {
            var assessmentId = _tokenManager.AssessmentForUser();

            var cisBiz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);
            var integrityCheckOptions = cisBiz.GetIntegrityCheckOptions();

            return Ok(integrityCheckOptions);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/MaturityModels")]
        public IActionResult GetAllModels()
        {
            return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAllModels());
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityAnswerCompletionRate")]
        public IActionResult GetAnswerCompletionRate()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAnswerCompletionRate(assessmentId));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityAnswerIseCompletionRate")]
        public IActionResult GetIseAnswerCompletionRate()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetIseAnswerCompletionRate(assessmentId));
        }


        /// <summary>
        /// Get all EDM glossary entries in alphabetical order.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/GetGlossary")]
        public IActionResult GetGlossaryEntries(string model)
        {
            MaturityBusiness MaturityBusiness = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            return Ok(MaturityBusiness.GetGlossaryEntries(model));
        }


        // --------------------------------------
        // The controller methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.
        // --------------------------------------




        /// <summary>
        /// Get maturity definiciency list.  
        /// If the maturity query parm is null, gets the main model for the assessment.
        /// If the parm is specified, gets that model's deficient answers for the assessment.  This is used for SSG bonus models.
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/maturity/deficiency")]
        public IActionResult GetDeficiencyList([FromQuery] string model)
        {
            try
            {
                int assessmentId = _tokenManager.AssessmentForUser();
                var lang = _tokenManager.GetCurrentLanguage();

                _reports.SetReportsAssessmentId(assessmentId);


                int? modelId = null;
                if (model != null)
                {
                    if (int.TryParse(model, out int value))
                    {
                        modelId = value;
                    }
                }


                var data = new MaturityBasicReportData
                {
                    DeficienciesList = _reports.GetMaturityDeficiencies(modelId),
                    Information = _reports.GetInformation()
                };



                // If the assessment is a CPG and the asset's sector warrants SSG questions, include them
                var ssgModelId = new CpgBusiness(_context, lang).DetermineSsgModel(assessmentId);
                if (ssgModelId != null)
                {
                    var ssgDeficiencies = _reports.GetMaturityDeficiencies(ssgModelId);
                    data.DeficienciesList.AddRange(ssgDeficiencies);
                }


                // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
                data.DeficienciesList.ForEach(d =>
                {
                    d.ANSWER.Assessment = null;
                    d.Mat.Maturity_Model = null;
                    d.Mat.Maturity_Level = null;
                    d.Mat.InverseParent_Question = null;

                    if (d.Mat.Parent_Question != null)
                    {
                        d.Mat.Parent_Question.Maturity_Model = null;
                        d.Mat.Parent_Question.Maturity_Level = null;
                        d.Mat.Parent_Question.InverseParent_Question = null;
                    }
                });


                return Ok(data);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return Ok();
            }
        }


        [HttpGet]
        [Route("api/getMaturityDeficiencyListSd")]
        public IActionResult GetDeficiencyListSd()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new NestedStructure(assessmentId, 0, _context);
            List<Grouping> filteredGroupingsU = new List<Grouping>();
            List<Grouping> filteredGroupingsS = new List<Grouping>();

            foreach (var b in biz.MyModel.Groupings)
            {
                var questionsU = new List<Question>();
                var questionsS = new List<Question>();
                foreach (var q in b.Questions)
                {

                    var question = new Question();
                    if (q.AnswerText == "U")
                    {
                        if (q.Options.Any(x => x.OptionType.ToLower() == "radio"))
                        {
                            question = new Question()
                            {
                                QuestionType = q.QuestionType,
                                DisplayNumber = q.DisplayNumber,
                                QuestionText = q.QuestionText,
                                MarkForReview = q.MarkForReview,
                                AnswerText = "Unanswered"
                            };
                            questionsU.Add(question);
                        }
                    }

                    if (q.AnswerText == "S")
                    {
                        if (q.Options.Any(x =>
                                x.Selected && x.OptionText == "No" && x.OptionType.ToLower() == "radio"))
                        {
                            question = new Question()
                            {
                                QuestionType = q.QuestionType,
                                DisplayNumber = q.DisplayNumber,
                                QuestionText = q.QuestionText,
                                MarkForReview = q.MarkForReview,
                                AnswerText = "No"
                            };
                            questionsS.Add(question);
                        }
                    }
                }

                if (questionsU.Any())
                {
                    filteredGroupingsU.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsU
                    });
                }
                if (questionsS.Any())
                {
                    filteredGroupingsS.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsS
                    });
                }

                questionsU = new List<Question>();
                questionsS = new List<Question>();
            }

            return Ok(new { no = filteredGroupingsS, unanswered = filteredGroupingsU });
        }


        [HttpGet]
        [Route("api/getMaturityDeficiencyListSdOwner")]
        public IActionResult GetDeficiencyListSdOwner()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new NestedStructure(assessmentId, 0, _context);
            List<Grouping> filteredGroupingsYes = new List<Grouping>();
            List<Grouping> filteredGroupingsNo = new List<Grouping>();
            List<Grouping> filteredGroupingsNa = new List<Grouping>();
            List<Grouping> filteredGroupingsU = new List<Grouping>();

            foreach (var b in biz.MyModel.Groupings)
            {
                var questionsYes = new List<Question>();
                var questionsNo = new List<Question>();
                var questionsNa = new List<Question>();
                var questionsU = new List<Question>();

                foreach (var q in b.Questions)
                {
                    var question = new Question();

                    if (q.AnswerText == "Y")
                    {
                        question = new Question()
                        {
                            QuestionType = q.QuestionType,
                            DisplayNumber = q.DisplayNumber,
                            QuestionText = q.QuestionText,
                            MarkForReview = q.MarkForReview,
                            AnswerText = "Yes"
                        };
                        questionsYes.Add(question);
                    }

                    if (q.AnswerText == "N")
                    {
                        question = new Question()
                        {
                            QuestionType = q.QuestionType,
                            DisplayNumber = q.DisplayNumber,
                            QuestionText = q.QuestionText,
                            MarkForReview = q.MarkForReview,
                            AnswerText = "No"
                        };
                        questionsNo.Add(question);
                    }

                    if (q.AnswerText == "NA")
                    {
                        question = new Question()
                        {
                            QuestionType = q.QuestionType,
                            DisplayNumber = q.DisplayNumber,
                            QuestionText = q.QuestionText,
                            MarkForReview = q.MarkForReview,
                            AnswerText = "NA"
                        };
                        questionsNa.Add(question);
                    }

                    if (q.AnswerText == "U")
                    {
                        question = new Question()
                        {
                            QuestionType = q.QuestionType,
                            DisplayNumber = q.DisplayNumber,
                            QuestionText = q.QuestionText,
                            MarkForReview = q.MarkForReview,
                            AnswerText = "Unanswered"
                        };
                        questionsU.Add(question);
                    }
                }

                if (questionsYes.Any())
                {
                    filteredGroupingsYes.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsYes
                    });
                }

                if (questionsNo.Any())
                {
                    filteredGroupingsNo.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsNo
                    });
                }

                if (questionsNa.Any())
                {
                    filteredGroupingsNa.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsNa
                    });
                }

                if (questionsU.Any())
                {
                    filteredGroupingsU.Add(new Grouping
                    {
                        Title = b.Title,
                        Questions = questionsU
                    });
                }

                questionsYes = new List<Question>();
                questionsNo = new List<Question>();
                questionsNa = new List<Question>();
                questionsU = new List<Question>();
            }

            return Ok(new { yes = filteredGroupingsYes, no = filteredGroupingsNo, na = filteredGroupingsNa, unanswered = filteredGroupingsU });
        }


        /// <summary>
        /// get all comments and marked for review
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getCommentsMarked")]
        public IActionResult GetCommentsMarked()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string lang = _tokenManager.GetCurrentLanguage();


            _reports.SetReportsAssessmentId(assessmentId);


            // if this is a CIS assessment, don't include questions that
            // are "out of scope" (a descendant of a deselected Option)
            List<int> oos = new();
            var isCis = _context.AVAILABLE_MATURITY_MODELS.Any(x => x.Assessment_Id == assessmentId && x.model_id == 8);
            if (isCis)
            {
                var qt = new QuestionTreeXml(assessmentId, _context);
                oos = qt.OutOfScopeQuestionIds();
            }

            MaturityBasicReportData data = new MaturityBasicReportData
            {
                Comments = _reports.GetCommentsList(),
                MarkedForReviewList = _reports.GetMarkedForReviewList(),
                Information = _reports.GetInformation()
            };


            // If the assessment is a CPG and the asset's sector warrants SSG questions, include them
            var ssgModelId = new CpgBusiness(_context, lang).DetermineSsgModel(assessmentId);
            if (ssgModelId != null)
            {
                var ssgComments = _reports.GetCommentsList(ssgModelId);
                data.Comments.AddRange(ssgComments);

                var ssgMarked = _reports.GetMarkedForReviewList(ssgModelId);
                data.MarkedForReviewList.AddRange(ssgMarked);
            }


            data.Comments.RemoveAll(x => oos.Contains(x.Mat.Mat_Question_Id));
            data.MarkedForReviewList.RemoveAll(x => oos.Contains(x.Mat.Mat_Question_Id));


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            data.Comments.ForEach(d =>
            {
                d.ANSWER.Assessment = null;
                d.Mat.Grouping = null;
                d.Mat.Maturity_Model = null;
                d.Mat.Maturity_Level = null;
                d.Mat.InverseParent_Question = null;
                d.Mat.Parent_Question = null;
            });

            data.MarkedForReviewList.ForEach(d =>
            {
                d.ANSWER.Assessment = null;
                d.Mat.Grouping = null;
                d.Mat.Maturity_Model = null;
                d.Mat.Maturity_Level = null;
                d.Mat.InverseParent_Question = null;
                d.Mat.Parent_Question = null;
            });

            return Ok(data);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="section"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getEdmScores")]
        public IActionResult GetEdmScores(string section)
        {
            try
            {
                int assessmentId = _tokenManager.AssessmentForUser();
                MaturityBusiness MaturityBusiness = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                var scores = MaturityBusiness.GetEdmScores(assessmentId, section);

                return Ok(scores);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return BadRequest();
            }
        }


        /// <summary>
        /// 
        /// </summary>        
        /// <returns>Root node</returns>
        [HttpGet]
        [Route("api/getEdmPercentScores")]
        public IActionResult GetEdmPercentScores()
        {
            try
            {
                int assessmentId = _tokenManager.AssessmentForUser();
                MaturityBusiness MaturityBusiness = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                var scores = MaturityBusiness.GetEdmPercentScores(assessmentId);

                return Ok(scores);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return BadRequest();
            }
        }


        /// <summary>
        /// Get EDM answers cross-mapped to NIST CSF.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getEdmNistCsfResults")]
        public IActionResult GetEdmNistCsfResults()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var manager = new EdmNistCsfMapping(_context);
            var maturity = manager.GetEdmNistCsfResults(assessmentId);

            return Ok(maturity);
        }


        /// <summary>
        /// Returns all reference text for the specified maturity model.
        /// </summary>
        /// <param name="x"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/referencetext")]
        public IActionResult GetReferenceText(string model)
        {
            try
            {
                var MaturityBusiness = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                var refText = MaturityBusiness.GetReferenceText(model);

                return Ok(refText);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return BadRequest();
            }
        }

        [HttpGet]
        [Route("api/maturity/mvra/scoring")]
        public IActionResult GetMvraScoring()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var maturity = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var model = maturity.GetMaturityStructureForModel(9, assessmentId);
            var scoring = maturity.GetMvraScoring(model);
            return Ok(scoring);
        }

        [HttpGet]
        [Route("api/maturity/mvra/mvraTree")]
        public IActionResult GetMvraTree([FromQuery] int id)
        {
            //int assessemntId = _tokenManager.AssessmentForUser();
            //var maturity = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var maturity = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var model = maturity.GetMaturityStructureForModel(9, id);
            //var scoring = maturity.GetMvraScoring(model);
            return Ok(model);
        }
    }
}
