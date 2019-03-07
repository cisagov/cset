using System;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class MaturityManager
    {
        public MaturityManager()
        { }

        public IEnumerable<MaturityAnswers> GetMaturityAnswers(int assessmentId) {

            

            using (var db = new DataLayerCore.Model.CSET_Context())
            {
                var data = db.usp_MaturityDetailsCalculations(assessmentId).ToList();
                //I lost a couple of hours worth of work on this 
                //and it is no where to be found in TFS
                //I'm going to leave it until I have a good idea what is going on.
                //return CalculateComponentValues(data); 
                return null;
            }

        }

        public List<MaturityDomain> CalculateComponentValues(IEnumerable<MaturityAnswers> maturity)
        {
            using (var db = new DataLayerCore.Model.CSET_Context())
            {
                var maturityDomains = new List<MaturityDomain>();
                var domains = db.FINANCIAL_DOMAINS;
                var standardCategories = db.FINANCIAL_DETAILS;
                var sub_categories = from m in maturity
                                     group new { m.DomainName, m.AssessmentFactor, m.Component }
                                      by new { m.DomainName, m.AssessmentFactor, m.Component } into mk
                                     select new
                                     {
                                         mk.Key.DomainName,
                                         mk.Key.AssessmentFactor,
                                         mk.Key.Component
                                     };

                foreach (var d in domains)
                {
                    var maturityDomain = new MaturityDomain
                    {
                        DomainName = d.Domain,
                        Assessments = new List<MaturityAssessment>(),
                        Sequence = maturity.FirstOrDefault(x => x.DomainName == d.Domain).Sequence
                    };
                    foreach (var s in standardCategories)
                    {

                        if (d.Domain == s.Domain.Domain)
                        {
                            var maturityAssessment = new MaturityAssessment
                            {
                                AssessmentFactor = s.AssessmentFactor.AssessmentFactor,
                                Components = new List<MaturityComponent>(),
                                Sequence = maturity.FirstOrDefault(x => x.AssessmentFactor == s.AssessmentFactor.AssessmentFactor).Sequence

                            };
                            foreach (var c in sub_categories)
                            {
                                if (c.AssessmentFactor == s.AssessmentFactor.AssessmentFactor)
                                {
                                    var component = new MaturityComponent
                                    {
                                        ComponentName = c.Component,
                                        Sequence = maturity.FirstOrDefault(x => x.Component == c.Component).Sequence

                                    };
                                    var low = new SalAnswers
                                    {

                                        Answered = maturity.Where(x => x.Component == c.Component && x.SalLevel == "L").Count(x => x.Answer != "Y" || x.Answer != "A") == 0 ? 0 :
                                            Convert.ToInt32((double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "L").Count(x => x.Answer == "Y" || x.Answer == "A") / (double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "L").Count() * 100)

                                    };
                                    var moderate = new SalAnswers
                                    {

                                        Answered = maturity.Where(x => x.Component == c.Component && x.SalLevel == "M").Count(x => x.Answer != "Y" || x.Answer != "A") == 0 ? 0 :
                                       Convert.ToInt32(((double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "M").Count(x => x.Answer == "Y" || x.Answer == "A") / (double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "M").Count()) * 100)

                                    };
                                    var high = new SalAnswers
                                    {

                                        Answered = maturity.Where(x => x.Component == c.Component && x.SalLevel == "H").Count(x => x.Answer != "Y" || x.Answer != "A") == 0 ? 0 :
                                            Convert.ToInt32(((double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "H").Count(x => x.Answer == "Y" || x.Answer == "A") / (double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "H").Count()) * 100)

                                    };
                                    var veryHigh = new SalAnswers
                                    {

                                        Answered = maturity.Where(x => x.Component == c.Component && x.SalLevel == "VH").Count(x => x.Answer != "Y" || x.Answer != "A") == 0 ? 0 :
                                            Convert.ToInt32(((double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "VH").Count(x => x.Answer == "Y" || x.Answer == "A") / (double)maturity.Where(x => x.Component == c.Component && x.SalLevel == "VH").Count()) * 100)

                                    };
                                    component.Baseline = low.Answered;
                                    component.Intermediate = moderate.Answered;
                                    component.Advanced = high.Answered;
                                    component.Innovative = veryHigh.Answered;
                                    component.AssessedMaturityLevel = low.Answered < 100 ? "Incomplete" :
                                                                            moderate.Answered < 100 ? "Baseline" :
                                                                                high.Answered < 100 ? "Intermediate" :
                                                                                    veryHigh.Answered < 100 ? "Advanced" :
                                                                                        "Innovative";

                                    maturityAssessment.Components.Add(component);
                                }
                            }

                            maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == "Incomplete") ? "Incomplete" :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == "BaseLine") ? "BaseLine" :
                                                                               maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == "Intermediate") ? "Intermediate" :
                                                                                   maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == "Advanced") ? "Advanced" :
                                                                                       "Innovative";
                            maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                            maturityDomain.Assessments.Add(maturityAssessment);
                        }


                    }

                    maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == "Incomplete") ? "Incomplete" :
                                                                           maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == "BaseLine") ? "BaseLine" :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == "Intermediate") ? "Intermediate" :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == "Advanced") ? "Advanced" :
                                                                                       "Innovative";
                    maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();
                    maturityDomains.Add(maturityDomain);
                }
                maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
                return maturityDomains;
            }
        }
    }
}
