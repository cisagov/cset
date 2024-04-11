//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityDomain
    {
        public int DomainId { get; set; }
        public string DomainName { get; set; }
        public string DomainMaturity { get; set; }
        public int Sequence { get; set; }

        public double TargetPercentageAchieved { get; set; }
        public List<MaturityAssessment> Assessments { get; set; }

        /// <summary>
        /// The percentage of answers in this domain.  NULL and "U" answers don't count.
        /// </summary>
        public double PercentAnswered { get; set; }
    }
}