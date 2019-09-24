using System;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;


namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class MaturityManager
    {
        public MaturityManager()
        { }

        public List<MaturityDomain> GetMaturityAnswers(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var data = db.usp_MaturityDetailsCalculations(assessmentId).ToList();
                return CalculateComponentValues(data, assessmentId);
            }

        }

        public bool GetTargetBandOnly(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                bool? defaultTarget = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault().MatDetail_targetBandOnly;
                return defaultTarget??false;
            }
        }

        public void SetTargetBandOnly(int assessmentId, bool value)
        {
            using (var db = new CSET_Context())
            {
                var assessment = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                assessment.MatDetail_targetBandOnly = value;
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateComponentValues(List<usp_MaturityDetailsCalculations_Result> maturity, int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var maturityDomains = new List<MaturityDomain>();
                var domains = db.FINANCIAL_DOMAINS.ToList();
                var standardCategories = db.FINANCIAL_DETAILS.ToList();
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
                        var tGroupOrder =maturity.FirstOrDefault(x => x.Domain == d.Domain);
                        var maturityDomain = new MaturityDomain
                        {
                            DomainName = d.Domain,
                            Assessments = new List<MaturityAssessment>(),
                            Sequence = tGroupOrder == null? 0: tGroupOrder.grouporder
                        };
                        var partial_sub_categoy = sub_categories.Where(x => x.Domain == d.Domain).GroupBy(x => x.AssessmentFactor).Select(x => x.Key);
                        foreach (var s in partial_sub_categoy)
                        {


                            var maturityAssessment = new MaturityAssessment
                            {
                                AssessmentFactor = s,
                                Components = new List<MaturityComponent>(),
                                Sequence = (int)maturity.FirstOrDefault(x => x.AssessmentFactor == s).grouporder

                            };
                            var assessmentCategories = sub_categories.Where(x => x.AssessmentFactor == s);
                            foreach (var c in assessmentCategories)
                            {

                                var component = new MaturityComponent
                                {
                                    ComponentName = c.FinComponent,
                                    Sequence = (int)maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).grouporder

                                };
                                var baseline = new SalAnswers
                                {
                                    UnAnswered = !maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).Complete,
                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };
                                var evolving = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvinMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvinMaturity.ToUpper()).AnswerPercent * 100) : 0


                                };
                                var intermediate = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };
                                var advanced = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };
                                var innovative = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };
                                component.Baseline = baseline.Answered;
                                component.Evolving = evolving.Answered;
                                component.Intermediate = intermediate.Answered;
                                component.Advanced = advanced.Answered;
                                component.Innovative = innovative.Answered;
                                component.AssessedMaturityLevel = baseline.UnAnswered ? Constants.IncompleteMaturity :
                                                                    baseline.Answered < 100 ? Constants.SubBaselineMaturity :
                                                                        evolving.Answered < 100 ? Constants.BaselineMaturity :
                                                                            intermediate.Answered < 100 ? Constants.EvolvinMaturity :
                                                                                advanced.Answered < 100 ? Constants.IntermediateMaturity :
                                                                                    innovative.Answered < 100 ? Constants.AdvancedMaturity :
                                                                                    "Innovative";

                                maturityAssessment.Components.Add(component);

                            }

                            maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.IncompleteMaturity) ? Constants.IncompleteMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.SubBaselineMaturity) ? Constants.SubBaselineMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.BaselineMaturity) ? Constants.BaselineMaturity :
                                                                               maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.EvolvinMaturity) ? Constants.EvolvinMaturity :
                                                                                maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.IntermediateMaturity) ? Constants.IntermediateMaturity :
                                                                                   maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.AdvancedMaturity) ? Constants.AdvancedMaturity :
                                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.InnovativeMaturity) ? Constants.InnovativeMaturity :
                                                                                           Constants.IncompleteMaturity;
                            maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                            maturityDomain.Assessments.Add(maturityAssessment);



                        }

                        maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.IncompleteMaturity) ? Constants.IncompleteMaturity :
                                                                            maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.SubBaselineMaturity) ? Constants.SubBaselineMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.BaselineMaturity) ? Constants.BaselineMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.EvolvinMaturity) ? Constants.EvolvinMaturity :
                                                                                       maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.IntermediateMaturity) ? Constants.IntermediateMaturity :
                                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.AdvancedMaturity) ? Constants.AdvancedMaturity :
                                                                                            maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.InnovativeMaturity) ? Constants.InnovativeMaturity :
                                                                                                Constants.IncompleteMaturity;
                        maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();
                        maturityDomains.Add(maturityDomain);
                    }
                }
                maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
                return maturityDomains;
            }
        }

        /// <summary>
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetMaturityRange(int assessmentId)
        {
            ACETDashboardManager manager = new ACETDashboardManager();
            ACETDashboard irpCalculation = manager.GetIrpCalculation(assessmentId);
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : irpCalculation.SumRiskLevel;
            if (!targetBandOnly)
                irpRating = 6; //Do the default configuration
            return irpSwitch(irpRating);
        }

        public List<string> irpSwitch(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.BaselineMaturity, Constants.EvolvinMaturity };
                case 2:
                    return new List<string>
                        {Constants.BaselineMaturity, Constants.EvolvinMaturity, Constants.IntermediateMaturity};
                case 3:
                    return new List<string>
                        {Constants.EvolvinMaturity, Constants.IntermediateMaturity, Constants.AdvancedMaturity};
                case 4:
                    return new List<string>
                        {Constants.IntermediateMaturity, Constants.AdvancedMaturity, Constants.InnovativeMaturity};
                case 5:
                    return new List<string> { Constants.AdvancedMaturity, Constants.InnovativeMaturity };
                default:
                    return new List<string>
                    {
                        Constants.BaselineMaturity, Constants.EvolvinMaturity, Constants.IntermediateMaturity,
                        Constants.AdvancedMaturity, Constants.InnovativeMaturity
                    };
            }
        }

        /// <summary>
        /// Returns a Dictionary mapping requirement ID to its corresponding maturity level.
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, MaturityMap> GetRequirementMaturityLevels()
        {
            using (var db = new CSET_Context())
            {
                var q = from req in db.NEW_REQUIREMENT
                        join fr in db.FINANCIAL_REQUIREMENTS on req.Requirement_Id equals fr.Requirement_Id
                        join fd in db.FINANCIAL_DETAILS on fr.StmtNumber equals fd.StmtNumber
                        join fg in db.FINANCIAL_GROUPS on fd.FinancialGroupId equals fg.FinancialGroupId
                        join fm in db.FINANCIAL_MATURITY on fg.MaturityId equals fm.MaturityId
                        where req.Original_Set_Name == "ACET_V1"
                        select new { req.Requirement_Id, fr.StmtNumber, fm.MaturityId, fm.Acronym, fm.MaturityLevel };

                var dict = new Dictionary<int, MaturityMap>();
                foreach (var a in q)
                {
                    dict.Add(a.Requirement_Id, new MaturityMap(a.MaturityId, a.Acronym, a.MaturityLevel));
                }

                return dict;
            }
        }
    }
}
