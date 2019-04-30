using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityAnswers
    {
        public string DomainName { get; set; }
        public string AssessmentFactor { get; set; }
        public string Component { get; set; }
        public int Sequence { get; set; }
        public string Answer { get; set; }
        public string SalLevel { get; set; }
    }
}
