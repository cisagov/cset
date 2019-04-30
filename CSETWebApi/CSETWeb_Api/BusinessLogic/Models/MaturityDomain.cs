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
        public List<MaturityAssessment> Assessments { get; set; }
    }
}
