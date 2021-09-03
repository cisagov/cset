using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Reports.Models.CRR
{
    public class MIL1ScoreParent
    {
        public MIL1ScoreParent parent { get; set; }
        public List<CRRDomainSummary> children { get; set; }
    }
}
