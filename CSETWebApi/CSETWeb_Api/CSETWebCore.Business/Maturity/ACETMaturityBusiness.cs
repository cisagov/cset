using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Model.Sal;
using System;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Acet;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Business.AdminTab;


namespace CSETWebCore.Business.Maturity
{
    public class ACETMaturityBusiness : MaturityBusiness, IACETMaturityBusiness
    {
        private CSETContext _context;

        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        private TranslationOverlay _overlay;



        /// <summary>
        /// CTOR
        /// </summary>
        public ACETMaturityBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness) : base(context, assessmentUtil, adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;

            _overlay = new TranslationOverlay();
        }


        public AVAILABLE_MATURITY_MODELS ProcessModelDefaults(int assessmentId, string installationMode)
        {
            //if the available maturity model is not selected and the application is CSET
            //the default is EDM
            //if the application is ACET the default is ACET

            return base.ProcessModelDefaults(assessmentId, 1);
        }


        // The methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.
        public List<MaturityDomain> GetMaturityAnswers(int assessmentId, string lang)
        {
            var data = _context.GetMaturityDetailsCalculations(assessmentId).ToList();
            // If there are no data, we have no maturity answers so skip the rest
            if (data.Count == 0)
            {
                return new List<MaturityDomain>();
            }

            return CalculateComponentValues(data, assessmentId, lang);
        }


        public override MaturityResponse GetMaturityQuestions(int assessmentId, bool fill, int groupingId, string lang)
        {
            var response = new MaturityResponse();
            var myModel = ProcessModelDefaults(assessmentId, 1);

            var myModelDefinition = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == myModel.model_id).FirstOrDefault();

            if (myModelDefinition == null)
            {
                return response;
            }

            response.ModelId = myModelDefinition.Maturity_Model_Id;
            response.ModelName = myModelDefinition.Model_Name;

            if (response.ModelName == "ACET")
            {
                response.OverallIRP = GetOverallIrpNumber(assessmentId);
                response.MaturityTargetLevel = response.OverallIRP;
            }

            response = base.GetMaturityQuestions(assessmentId, fill, groupingId, lang);

            return response;
        }


        /// <summary>
        /// Returns the percentage of maturity questions that have been answered for the 
        /// current maturity level (IRP).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public double GetAnswerCompletionRate(int assessmentId)
        {
            var irp = GetOverallIrpNumber(assessmentId);

            // get the highest maturity level for the risk level (use the stairstep model)
            var topMatLevel = GetTopMatLevelForRisk(irp);

            var answerDistribution = _context.AcetAnswerDistribution(assessmentId, topMatLevel).ToList();

            var answeredCount = 0;
            var totalCount = 0;
            foreach (var d in answerDistribution)
            {
                if (d.Answer_Text != "U")
                {
                    answeredCount += d.Count;
                }
                totalCount += d.Count;
            }

            return ((double)answeredCount / (double)totalCount) * 100d;
        }


        /// <summary>
        /// Returns the percentage of maturity questions that have been answered for the 
        /// current maturity level (IRP).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public double GetIseAnswerCompletionRate(int assessmentId)
        {
            var irp = GetOverallIseIrpNumber(assessmentId);

            // get the highest maturity level for the risk level (use the stairstep model)
            var topMatLevel = GetIseTopMatLevelForRisk(irp);

            var answerDistribution = _context.IseAnswerDistribution(assessmentId, topMatLevel).ToList();

            var answeredCount = 0;
            var totalCount = 0;
            foreach (var d in answerDistribution)
            {
                if (d.Answer_Text != "U")
                {
                    answeredCount += d.Count;
                }
                totalCount += d.Count;
            }

            return ((double)answeredCount / (double)totalCount) * 100d;
        }


        public List<MaturityDomain> GetIseMaturityAnswers(int assessmentId)
        {
            var data = _context.GetMaturityDetailsCalculations(assessmentId).ToList();

            return CalculateComponentValues(data, assessmentId);
        }


        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId, string lang = "en")
        {
            var maturityDomains = new List<MaturityDomain>();

            var financialDomains = _context.FINANCIAL_DOMAINS.ToList();
            var financialDetails = _context.FINANCIAL_DETAILS.ToList();

            var subCategories = from m in maturity
                                group new { m.Domain, m.AssessmentFactor, m.FinComponent }
                                 by new { m.DomainId, m.Domain, m.AssessmentFactorId, m.AssessmentFactor, m.FinComponentId, m.FinComponent } into mk
                                select new MaturityDetailsCalculations()
                                {
                                    DomainId = mk.Key.DomainId,
                                    Domain = mk.Key.Domain,
                                    AssessmentFactorId = mk.Key.AssessmentFactorId,
                                    AssessmentFactor = mk.Key.AssessmentFactor,
                                    FinComponentId = mk.Key.FinComponentId,
                                    FinComponent = mk.Key.FinComponent
                                };

            var maturityRange = GetMaturityRange(assessmentId);


            if (maturity.Count > 0)
            {
                foreach (var fd in financialDomains)
                {
                    var tGroupOrder = maturity.FirstOrDefault(x => x.Domain == fd.Domain);


                    // this is the object that is returned in a list
                    var maturityDomain = new MaturityDomain
                    {
                        DomainId = fd.DomainId,
                        DomainName = fd.Domain,
                        Assessments = [],
                        Sequence = tGroupOrder == null ? 0 : tGroupOrder.grouporder,
                        TargetPercentageAchieved = 0,
                        PercentAnswered = 0
                    };


                    var DomainQT = 0;
                    var DomainAT = 0;

                    var domainSubCategories = subCategories.Where(x => x.DomainId == fd.DomainId).GroupBy(x => x.AssessmentFactorId).ToList();

                    foreach (var s in domainSubCategories)
                    {
                        var af = subCategories.FirstOrDefault(x => x.AssessmentFactorId == s.Key);

                        int AssQT = 0;
                        int AssAT = 0;

                        var maturityAssessment = new MaturityAssessment
                        {
                            AssessmentFactorId = af.AssessmentFactorId,
                            AssessmentFactor = af.AssessmentFactor,
                            Components = new List<MaturityComponent>(),
                            Sequence = (int)maturity.FirstOrDefault(x => x.AssessmentFactorId == af.AssessmentFactorId).grouporder

                        };

                        var assessmentCategories = subCategories.Where(x => x.AssessmentFactorId == af.AssessmentFactorId);

                        foreach (var c in assessmentCategories)
                        {
                            int CompQT = 0;
                            int CompAT = 0;
                            int CompQuestions = 0;
                            int totalAnswered = 0;
                            double AnsweredPer = 0;

                            var component = new MaturityComponent
                            {
                                ComponentId = c.FinComponentId,
                                ComponentName = c.FinComponent,
                                Sequence = (int)maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).grouporder
                            };


                            var baseline = new SalAnswers
                            {
                                UnAnswered = !maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).Complete,
                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0
                            };
                            if (maturityRange.Contains("Baseline"))
                            {
                                // Calc total questons and anserwed
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }
                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var evolving = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0


                            };
                            if (maturityRange.Contains("Evolving"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }
                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var intermediate = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };
                            if (maturityRange.Contains("Intermediate"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var advanced = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };
                            if (maturityRange.Contains("Advanced"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var innovative = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            if (maturityRange.Contains("Innovative"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }

                            component.Baseline = baseline.Answered;
                            component.Evolving = evolving.Answered;
                            component.Intermediate = intermediate.Answered;
                            component.Advanced = advanced.Answered;
                            component.Innovative = innovative.Answered;
                            component.AssessedMaturityLevel = baseline.UnAnswered ? Constants.Constants.IncompleteMaturity :
                                                                baseline.Answered < 100 ? Constants.Constants.SubBaselineMaturity :
                                                                    evolving.Answered < 100 ? Constants.Constants.BaselineMaturity :
                                                                        intermediate.Answered < 100 ? Constants.Constants.EvolvingMaturity :
                                                                            advanced.Answered < 100 ? Constants.Constants.IntermediateMaturity :
                                                                                innovative.Answered < 100 ? Constants.Constants.AdvancedMaturity :
                                                                                "Innovative";

                            maturityAssessment.Components.Add(component);

                            AssQT += CompQT;
                            AssAT += CompAT;
                        }

                        maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.BaselineMaturity) ? Constants.Constants.BaselineMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.EvolvingMaturity) ? Constants.Constants.EvolvingMaturity :
                                                                            maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IntermediateMaturity) ? Constants.Constants.IntermediateMaturity :
                                                                               maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.AdvancedMaturity) ? Constants.Constants.AdvancedMaturity :
                                                                                   maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.InnovativeMaturity) ? Constants.Constants.InnovativeMaturity :
                                                                                   Constants.Constants.IncompleteMaturity;
                        maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                        maturityDomain.Assessments.Add(maturityAssessment);

                        DomainQT += AssQT;
                        DomainAT += AssAT;

                    }

                    maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                           maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.BaselineMaturity) ? Constants.Constants.BaselineMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.EvolvingMaturity) ? Constants.Constants.EvolvingMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IntermediateMaturity) ? Constants.Constants.IntermediateMaturity :
                                                                                    maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.AdvancedMaturity) ? Constants.Constants.AdvancedMaturity :
                                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.InnovativeMaturity) ? Constants.Constants.InnovativeMaturity :
                                                                                        Constants.Constants.IncompleteMaturity;
                    maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();

                    double AchPerTol = Math.Round(((double)DomainAT / DomainQT) * 100, 0);
                    maturityDomain.TargetPercentageAchieved = AchPerTol;


                    // overlay
                    if (lang != "en")
                    {
                        maturityDomain.DomainName = _overlay.GetValue("FINANCIAL_DOMAINS", fd.DomainId.ToString(), lang)?.Value ?? maturityDomain.DomainName;

                        maturityDomain.Assessments.ForEach(
                            assessment =>
                            {
                                assessment.AssessmentFactor =
                                _overlay.GetValue("FINANCIAL_ASSESSMENT_FACTORS",
                                assessment.AssessmentFactorId.ToString(), lang)?.Value ?? assessment.AssessmentFactor;

                                assessment.Components.ForEach(
                                    component =>
                                    {
                                        component.ComponentName =
                                        _overlay.GetValue("FINANCIAL_COMPONENTS",
                                        component.ComponentId.ToString(), lang)?.Value ?? component.ComponentName;
                                    });
                            });
                    }


                    maturityDomains.Add(maturityDomain);
                }
            }

            maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
            return maturityDomains;
        }


        public bool GetTargetBandOnly(int assessmentId)
        {
            bool? defaultTarget = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault().MatDetail_targetBandOnly;
            return defaultTarget ?? false;
        }

        public void SetTargetBandOnly(int assessmentId, bool value)
        {
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            assessment.MatDetail_targetBandOnly = value;
            _context.SaveChanges();
        }


        /// <summary>
        /// Returns the active maturity level list, but the IDs for the levels.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<int> GetMaturityRangeIds(int assessmentId)
        {
            var output = new List<int>();

            var result = GetMaturityRange(assessmentId);

            var levels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == 1).ToList();
            foreach (string r in result)
            {
                output.Add(levels.Where(x => x.Level_Name.ToLower() == r.ToLower()).First().Maturity_Level_Id);
            }

            return output;
        }


        /// <summary>
        /// Returns a Dictionary mapping requirement ID to its corresponding maturity level.
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, MaturityMap> GetRequirementMaturityLevels()
        {
            var q = from req in _context.NEW_REQUIREMENT
                    join fr in _context.FINANCIAL_REQUIREMENTS on req.Requirement_Id equals fr.Requirement_Id
                    join fd in _context.FINANCIAL_DETAILS on fr.StmtNumber equals fd.StmtNumber
                    join fg in _context.FINANCIAL_GROUPS on fd.FinancialGroupId equals fg.FinancialGroupId
                    join fm in _context.FINANCIAL_MATURITY on fg.Financial_Level_Id equals fm.Financial_Level_Id
                    where req.Original_Set_Name == "ACET_V1"
                    select new { req.Requirement_Id, fr.StmtNumber, fm.Financial_Level_Id, fm.Acronym, fm.MaturityLevel };

            var dict = new Dictionary<int, MaturityMap>();
            foreach (var a in q)
            {
                dict.Add(a.Requirement_Id, new MaturityMap(a.Financial_Level_Id, a.Acronym, a.MaturityLevel));
            }

            return dict;
        }


        /// <summary>
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetMaturityRange(int assessmentId)
        {
            Model.Acet.ACETDashboard irpCalculation = GetIrpCalculation(assessmentId);
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : irpCalculation.SumRiskLevel;
            if (!targetBandOnly)
                irpRating = 6; //Do the default configuration
            return IrpSwitch(irpRating);
        }


        /// <summary>
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetIseMaturityRange(int assessmentId)
        {
            Model.Acet.ACETDashboard irpCalculation = GetIseIrpCalculation(assessmentId);
            int assetLevel = long.Parse(irpCalculation.Assets) > 50000000 ? 2 : 1;
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : assetLevel;
            if (!targetBandOnly)
                irpRating = 2; //Do the default configuration
            return IrpSwitchIse(irpRating);
        }


        /// <summary>
        /// Returns the active maturity level list, but the IDs for the levels.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<int> GetIseMaturityRangeIds(int assessmentId)
        {
            var output = new List<int>();

            var result = GetIseMaturityRange(assessmentId);

            var levels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == 10).ToList();
            foreach (string r in result)
            {
                output.Add(levels.Where(x => x.Level_Name.ToLower() == r.ToLower()).First().Maturity_Level_Id);
            }

            return output;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> IrpSwitch(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity };
                case 2:
                    return new List<string>
                        {Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity};
                case 3:
                    return new List<string>
                        {Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity, Constants.Constants.AdvancedMaturity};
                case 4:
                    return new List<string>
                        {Constants.Constants.IntermediateMaturity, Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity};
                case 5:
                    return new List<string> { Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity };
                default:
                    return new List<string>
                    {
                        Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity,
                        Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity
                    };
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> IrpSwitchIse(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.Constants.ScuepMaturity };
                case 2:
                    return new List<string>
                        { Constants.Constants.CoreMaturity, Constants.Constants.CorePlusMaturity };
                default:
                    return new List<string>
                    {
                        Constants.Constants.ScuepMaturity, Constants.Constants.CoreMaturity, Constants.Constants.CorePlusMaturity
                    };
            }
        }


        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateIseComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId)
        {

            var maturityDomains = new List<MaturityDomain>();
            var domains = _context.MATURITY_GROUPINGS.Where(row => row.Maturity_Model_Id == 10 && row.Group_Level == 2).ToList();
            var sub_categories = from m in maturity
                                 group new { m.Domain, m.AssessmentFactor, m.FinComponent }
                                  by new { m.Domain, m.AssessmentFactor, m.FinComponent } into mk
                                 select new
                                 {
                                     mk.Key.Domain,
                                     mk.Key.AssessmentFactor,
                                     mk.Key.FinComponent
                                 };

            //var maturityRange = GetMaturityRange(assessmentId);

            if (maturity.Count > 0)
            {
                foreach (var d in domains)
                {
                    var tGroupOrder = maturity.FirstOrDefault(x => x.Domain == d.Title);
                    var maturityDomain = new MaturityDomain
                    {
                        DomainName = d.Title,
                        Assessments = new List<MaturityAssessment>(),
                        Sequence = Int32.Parse(d.Title_Id),
                        TargetPercentageAchieved = 0,
                        PercentAnswered = 0
                    };

                    var DomainQT = 0;
                    var DomainAT = 0;

                    var partial_sub_categoy = sub_categories.Where(x => x.Domain == d.Title).GroupBy(x => x.AssessmentFactor).Select(x => x.Key);
                    foreach (var s in partial_sub_categoy)
                    {

                        int AssQT = 0;
                        int AssAT = 0;

                        var maturityAssessment = new MaturityAssessment
                        {
                            AssessmentFactor = s,
                            Components = new List<MaturityComponent>(),
                            Sequence = (int)maturity.FirstOrDefault(x => x.AssessmentFactor == s).grouporder

                        };
                        var assessmentCategories = sub_categories.Where(x => x.AssessmentFactor == s);
                        foreach (var c in assessmentCategories)
                        {
                            int CompQT = 0;
                            int CompAT = 0;
                            int CompQuestions = 0;
                            int totalAnswered = 0;
                            double AnsweredPer = 0;

                            var component = new MaturityComponent
                            {
                                ComponentName = c.FinComponent,
                                Sequence = (int)maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).grouporder

                            };
                            var scuep = new SalAnswers
                            {
                                UnAnswered = !maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).Complete,
                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).AnswerPercent * 100) : 0
                            };

                            // Calc total questons and anserwed
                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            var core = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).AnswerPercent * 100) : 0


                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;


                            var corePlus = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }

                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            component.Scuep = scuep.Answered;
                            component.Core = core.Answered;
                            component.CorePlus = corePlus.Answered;
                            component.AssessedMaturityLevel = scuep.UnAnswered ? Constants.Constants.IncompleteMaturity :
                                                                scuep.Answered < 100 ? Constants.Constants.SubBaselineMaturity :
                                                                    core.Answered < 100 ? Constants.Constants.ScuepMaturity :
                                                                        corePlus.Answered < 100 ? Constants.Constants.CoreMaturity :
                                                                            "CORE+";

                            maturityAssessment.Components.Add(component);

                            AssQT += CompQT;
                            AssAT += CompAT;
                        }

                        maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                            maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.ScuepMaturity) ? Constants.Constants.ScuepMaturity :
                                                                                maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.CoreMaturity) ? Constants.Constants.CoreMaturity :
                                                                                    maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.CorePlusMaturity) ? Constants.Constants.CorePlusMaturity :
                                                                                        Constants.Constants.IncompleteMaturity;

                        maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                        maturityDomain.Assessments.Add(maturityAssessment);

                        DomainQT += AssQT;
                        DomainAT += AssAT;

                    }

                    maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                           maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.ScuepMaturity) ? Constants.Constants.ScuepMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.CoreMaturity) ? Constants.Constants.CoreMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.CorePlusMaturity) ? Constants.Constants.CorePlusMaturity :
                                                                                        Constants.Constants.IncompleteMaturity;

                    maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();

                    double AchPerTol = Math.Round(((double)DomainAT / DomainQT) * 100, 0);
                    maturityDomain.TargetPercentageAchieved = AchPerTol;

                    maturityDomains.Add(maturityDomain);
                }
            }

            maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
            return maturityDomains;
        }


        /// <summary>
        /// Using the 'stairstep' model, determines the highest maturity level
        /// that corresponds to the specified IRP/risk.  
        /// 
        /// This stairstep model must match the stairstep defined in the UI -- getStairstepRequired(),
        /// though this method only returns the top level.
        /// </summary>
        /// <param name="irp"></param>
        /// <returns></returns>
        private int GetTopMatLevelForRisk(int irp)
        {
            switch (irp)
            {
                case 1:
                case 2:
                    return 1; // Baseline
                case 3:
                    return 2; // Evolving
                case 4:
                    return 3; // Intermediate
                case 5:
                    return 4; // Advanced
            }

            return 0;
        }


        /// <summary>
        /// Using the 'stairstep' model, determines the highest maturity level
        /// that corresponds to the specified IRP/risk.  
        /// 
        /// This stairstep model must match the stairstep defined in the UI -- getStairstepRequired(),
        /// though this method only returns the top level.
        /// </summary>
        /// <param name="irp"></param>
        /// <returns></returns>
        private int GetIseTopMatLevelForRisk(int irp)
        {
            switch (irp)
            {
                case 1:
                    return 1; // SCUEP
                case 2:
                    return 2; // CORE
                case 3:
                    return 3; // CORE+
            }

            return 0;
        }

 


        public Model.Acet.ACETDashboard LoadDashboard(int assessmentId, string lang)
        {
            Model.Acet.ACETDashboard result = GetIrpCalculation(assessmentId);

            result.Domains = new List<DashboardDomain>();

            List<MaturityDomain> domains = GetMaturityAnswers(assessmentId, lang);
            foreach (var d in domains)
            {
                result.Domains.Add(new DashboardDomain
                {
                    Maturity = d.DomainMaturity,
                    Name = d.DomainName
                });

            }

            return result;
        }


        /// <summary>
        /// Get the string value for the overall IRP mapping
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public string GetOverallIrp(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall == 1 ? Constants.Constants.LeastIrp :
                overall == 2 ? Constants.Constants.MinimalIrp :
                overall == 3 ? Constants.Constants.ModerateIrp :
                overall == 4 ? Constants.Constants.SignificantIrp :
                overall == 5 ? Constants.Constants.MostIrp : string.Empty;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetOverallIrpNumber(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetOverallIseIrpNumber(int assessmentId)
        {
            var calc = GetIseIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall;
        }


        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId)
        {
            Model.Acet.ACETDashboard result = new Model.Acet.ACETDashboard();


            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment == null) { return null; }
            result.CreditUnionName = assessment.CreditUnionName;
            result.Charter = assessment.Charter;
            result.Assets = assessment.Assets;

            result.Hours = _adminTabBusiness.GetTabData(assessmentId).GrandTotal;

            //IRP Section
            result.Override = assessment.IRPTotalOverride ?? 0;
            result.OverrideReason = assessment.IRPTotalOverrideReason;
            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.Model.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.Model.IRP irp in irps)
                {
                    ASSESSMENT_IRP answer = null;
                    dictionaryIRPS.TryGetValue(irp.IRP_ID, out answer);
                    //ASSESSMENT_IRP answer = irp.ASSESSMENT_IRP.FirstOrDefault(i => i.Assessment_.Assessment_Id == assessmentId);
                    if (answer != null && answer.Response != 0)
                    {
                        summary.RiskCount[answer.Response.Value - 1]++;
                        summary.RiskSum++;
                        result.SumRisk[answer.Response.Value - 1]++;
                        result.SumRiskTotal++;
                    }
                }

                result.Irps.Add(summary);
            }

            //go back through the IRPs and calculate the Risk Level for each section
            foreach (IRPSummary irp in result.Irps)
            {
                int MaxRisk = 0;
                irp.RiskLevel = 0;
                for (int i = 0; i < irp.RiskCount.Length; i++)
                {
                    if (irp.RiskCount[i] >= MaxRisk && irp.RiskCount[i] > 0)
                    {
                        MaxRisk = irp.RiskCount[i];
                        irp.RiskLevel = i + 1;
                    }
                }
            }

            _context.SaveChanges();

            result.SumRiskLevel = 1;
            int maxRisk = 0;
            for (int i = 0; i < result.SumRisk.Length; i++)
            {
                if (result.SumRisk[i] >= maxRisk && result.SumRisk[i] > 0)
                {
                    result.SumRiskLevel = i + 1;
                    maxRisk = result.SumRisk[i];
                }
            }

            return result;
        }

        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard GetIseIrpCalculation(int assessmentId)
        {
            Model.Acet.ACETDashboard result = new Model.Acet.ACETDashboard();


            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment == null) { return null; }
            result.CreditUnionName = assessment.CreditUnionName;
            result.Charter = assessment.Charter;
            result.Assets = assessment.Assets;

            result.Hours = _adminTabBusiness.GetTabData(assessmentId).GrandTotal;

            //IRP Section
            result.Override = assessment.IRPTotalOverride ?? 0;
            result.OverrideReason = assessment.IRPTotalOverrideReason;

            var scuepIRPLevel = 1;
            var coreIRPLevel = 2;

            if (result.Override == 0)
            {
                result.Override = long.Parse(result.Assets) > 50000000 ? coreIRPLevel : scuepIRPLevel;
            }

            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.Model.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.Model.IRP irp in irps)
                {
                    ASSESSMENT_IRP answer = null;
                    dictionaryIRPS.TryGetValue(irp.IRP_ID, out answer);
                    //ASSESSMENT_IRP answer = irp.ASSESSMENT_IRP.FirstOrDefault(i => i.Assessment_.Assessment_Id == assessmentId);
                    if (answer != null && answer.Response != 0)
                    {
                        summary.RiskCount[answer.Response.Value - 1]++;
                        summary.RiskSum++;
                        result.SumRisk[answer.Response.Value - 1]++;
                        result.SumRiskTotal++;
                    }
                }

                result.Irps.Add(summary);
            }

            //go back through the IRPs and calculate the Risk Level for each section
            foreach (IRPSummary irp in result.Irps)
            {
                int MaxRisk = 0;
                irp.RiskLevel = 0;
                for (int i = 0; i < irp.RiskCount.Length; i++)
                {
                    if (irp.RiskCount[i] >= MaxRisk && irp.RiskCount[i] > 0)
                    {
                        MaxRisk = irp.RiskCount[i];
                        irp.RiskLevel = i + 1;
                    }
                }
            }

            _context.SaveChanges();

            result.SumRiskLevel = 1;
            int maxRisk = 0;
            for (int i = 0; i < result.SumRisk.Length; i++)
            {
                if (result.SumRisk[i] >= maxRisk && result.SumRisk[i] > 0)
                {
                    result.SumRiskLevel = i + 1;
                    maxRisk = result.SumRisk[i];
                }
            }

            return result;
        }

        public void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary)
        {
            if (assessmentId == 0 || summary == null) { return; }

            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment != null)
            {
                assessment.CreditUnionName = summary.CreditUnionName;
                assessment.Charter = summary.Charter;
                assessment.Assets = summary.Assets;

                assessment.IRPTotalOverride = summary.Override;
                assessment.IRPTotalOverrideReason = summary.OverrideReason;
            }

            foreach (IRPSummary irp in summary.Irps)
            {
                ASSESSMENT_IRP_HEADER dbSummary = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.ASSESSMENT_ID == assessment.Assessment_Id && s.HEADER_RISK_LEVEL_ID == irp.RiskLevelId);
                if (dbSummary != null)
                {
                    dbSummary.RISK_LEVEL = irp.RiskLevel;
                    dbSummary.COMMENT = irp.Comment;
                } // the else should never happen
                else
                {
                    return;
                }
            }

            _context.SaveChanges();
        }
    }
}
