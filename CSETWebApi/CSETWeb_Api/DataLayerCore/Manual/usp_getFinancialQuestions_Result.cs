using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataLayerCore.Manual
{
    public class usp_getFinancialQuestions_Result
    {
        public string Requirement_title { get; set; }
        public string Requirement_text { get; set; }
        public string Answer_text { get; set; }
        public string MaturityLevel { get; set; }
    }
}
