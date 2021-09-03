using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Reports.Models.CRR
{
    public class CRRGoal
    {
        public string goal { get; set; }
        public List<CRRScore> children { get; set; }
    }
}
