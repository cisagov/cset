using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.CisaAssessorWorkflow;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Demographic
{
    public class CisaAssessorWorkflowFieldValidator
    {
        private Demographics _demographics;
        private DemographicExt _demographicExt;

        public CisaAssessorWorkflowFieldValidator(Demographics demographics, DemographicExt demographicExt) 
        {
            _demographics = demographics;
            _demographicExt = demographicExt;
        }

        public CisaWorkflowFieldValidationResponse ValidateFields() 
        {
            List<string> invalidFields = new List<string>();
            bool isValid = true;

            PropertyInfo[] demoProperties = typeof(Demographics).GetProperties();
            foreach (PropertyInfo property in demoProperties)
            {
                if (property.GetValue(_demographics) == null)
                { 
                    invalidFields.Add(property.Name);
                }
            }

            PropertyInfo[] demoExtProperties = typeof(DemographicExt).GetProperties();
            foreach (PropertyInfo property in demoExtProperties)
            {
                if (property.GetValue(_demographicExt) == null)
                {
                    invalidFields.Add(property.Name);
                }
            }

            if (invalidFields.Count > 0) 
            {
                isValid = false;
            }

            return new CisaWorkflowFieldValidationResponse(invalidFields, isValid);
        }
    }
}
