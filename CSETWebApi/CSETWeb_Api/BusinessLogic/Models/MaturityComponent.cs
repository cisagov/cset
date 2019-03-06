using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityComponent
    {
        public string ComponentName { get; set; }
        public bool Incomplete { get; set; }
        public double Baseline { get; set; }
        public double Intermediate { get; set; }
        public double Advanced { get; set; }
        public double Innovative { get; set; }
        public string AssessedMaturityLevel { get; set; }
        public int Sequence { get; set; }
    }
}
