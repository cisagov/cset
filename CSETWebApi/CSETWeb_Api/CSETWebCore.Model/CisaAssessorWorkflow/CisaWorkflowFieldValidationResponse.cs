using System.Collections.Generic;

namespace CSETWebCore.Model.CisaAssessorWorkflow
{
    public class CisaWorkflowFieldValidationResponse
    {
        public CisaWorkflowFieldValidationResponse(List<string> invalidFields, bool isValid)
        {
            InvalidFields = invalidFields;
            IsValid = isValid;
        }

        public List<string> InvalidFields { get; set; }
        public bool IsValid { get; set; }
    }
}
