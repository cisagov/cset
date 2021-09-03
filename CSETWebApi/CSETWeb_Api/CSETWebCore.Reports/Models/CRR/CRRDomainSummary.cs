using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Reports.Models.CRR
{
    public class CRRDomainSummary
    {
        public string domain_summary { get; set; }
        public List<CRRGoal> children { get; set; }
    }
}
