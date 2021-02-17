//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityDomain
    {
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
