using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Reports.Models.CRR
{
    public class CRRScore
    {
        public string title_Id { get; set; }
        public string color { get; set; }
        public List<dynamic> children { get; set; }
    }
}
