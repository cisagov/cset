using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityAssessment
    {
        public string AssessmentFactor { get; set; }
        public string AssessmentFactorMaturity { get; set; }
        public int Sequence { get; set; }
        public List<MaturityComponent> Components { get; set; }
    }
}
