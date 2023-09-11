using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.CisaAssessorWorkflow
{
    public class CisaWorkflowFieldValidationResponse
    {
        public List<string> InvalidFields { get; set; }
        public bool IsValid { get; set; }
    }
}
