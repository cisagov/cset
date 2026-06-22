//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Maturity.CPG;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Calculates scores for CPG assessments.
    /// </summary>
    public class CpgScoring
    {
        /// <summary>
        /// Calculates percentages for each impact level.
        /// </summary>
        public CpgComplianceScore CalculateNewImpactScore(List<AnswerImpact> answerList)
        {
            var resp = new CpgComplianceScore();

            var high = answerList.Where(x => x.Impact == "HIGH").ToList();
            resp.ImpactHigh = CalculateYPercent(high);

            var moderate = answerList.Where(x => new[] { "MODERATE", "MEDIUM" }.Contains(x.Impact)).ToList();
            resp.ImpactModerate = CalculateYPercent(moderate);

            var low = answerList.Where(x => x.Impact == "LOW").ToList();
            resp.ImpactLow = CalculateYPercent(low);

            resp.Overall = (resp.ImpactHigh + resp.ImpactModerate + resp.ImpactLow) / 3;

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        private double CalculateYPercent(List<AnswerImpact> items)
        {
            return items.Count == 0 ? 0 : (double)items.Count(x => x.AnswerText == "Y") / items.Count * 100;
        }
    }
}
