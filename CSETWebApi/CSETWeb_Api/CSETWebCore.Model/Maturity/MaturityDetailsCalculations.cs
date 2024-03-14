using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityDetailsCalculations
    {
        public int DomainId { get; set; }
        public string Domain { get; set; }
        public int AssessmentFactorId { get; set; }
        public string AssessmentFactor {  get; set; }
        public int FinComponentId { get; set; }
        public string FinComponent { get; set; }
    }
}
