using System;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using BusinessLogic.Helpers;


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
                return CalculateComponentValues(data);
            }

        }

        public List<MaturityDomain> CalculateComponentValues(List<usp_MaturityDetailsCalculations_Result> maturity)
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

                foreach (var d in domains)
                {

                    var maturityDomain = new MaturityDomain
                    {
                        DomainName = d.Domain,
                        Assessments = new List<MaturityAssessment>(),
                        Sequence = (int)maturity.FirstOrDefault(x => x.Domain == d.Domain).grouporder
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
                                UnAnswered = !maturity.FirstOrDefault(x=>x.FinComponent == c.FinComponent).Complete,
                                Answered = Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100)

                            };
                            var evolving = new SalAnswers
                            {

                                Answered = Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvinMaturity.ToUpper()).AnswerPercent * 100)

                            };
                            var intermediate = new SalAnswers
                            {

                                Answered = Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100)

                            };
                            var advanced = new SalAnswers
                            {

                                Answered = Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100)

                            };
                            var innovative = new SalAnswers
                            {

                                Answered = Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100)

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
                maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
                return maturityDomains;
            }
        }
    }
}
