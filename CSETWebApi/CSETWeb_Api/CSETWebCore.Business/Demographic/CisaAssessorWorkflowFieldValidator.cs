//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.CisaAssessorWorkflow;
using CSETWebCore.Model.Demographic;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;


namespace CSETWebCore.Business.Demographic
{
    /// <summary>
    /// 
    /// </summary>
    public class CisaAssessorWorkflowFieldValidator
    {
        private Demographics _demographics;
        private DemographicExt _demographicExt;
        private CisServiceDemographics _cisServiceDemographics;
        private CisServiceComposition _cisServiceComposition;



        public CisaAssessorWorkflowFieldValidator(Demographics demographics, DemographicExt demographicExt, CisServiceDemographics cisServiceDemographics, CisServiceComposition cisServiceComposition)
        {
            _demographics = demographics;
            _demographicExt = demographicExt;
            _cisServiceDemographics = cisServiceDemographics;
            _cisServiceComposition = cisServiceComposition;
        }


        /// <summary>
        /// Use the FieldValidation.json file as a list of fields to validate.
        /// </summary>
        /// <returns></returns>
        public CisaWorkflowFieldValidationResponse ValidateFields()
        {
            List<string> invalidFields = new List<string>();
            bool isValid = true;


            // create composite list of properties for all three pages
            List<PropertyInfo> demoExtProperties = typeof(DemographicExt).GetProperties().ToList();
            List<PropertyInfo> cisServiceDemoProperties = typeof(CisServiceDemographics).GetProperties().ToList();
            List<PropertyInfo> cisServiceCompProperties = typeof(CisServiceComposition).GetProperties().ToList();
            var allProperties = demoExtProperties.Concat(cisServiceDemoProperties).Concat(cisServiceCompProperties).ToList();


            // exclude some things from validation if not applicable
            if (!_demographicExt.UsesStandard)
            {
                allProperties.RemoveAll(x => x.Name.StartsWith("Standard"));
            }
            if (!_demographicExt.RequiredToComply)
            {
                allProperties.RemoveAll(x => x.Name.StartsWith("RegulationType"));
            }


            var fv = new FieldValidation();
            foreach (var field in fv.Fields)
            {
                var property = allProperties.FirstOrDefault(x => x.Name.Equals(field.Key, System.StringComparison.OrdinalIgnoreCase));

                if (property == null)
                {
                    continue;
                }


                // look for the property value in the 3 target objects
                var v1 = _demographicExt?.GetType().GetProperty(property.Name)?.GetValue(_demographicExt);
                var v2 = _cisServiceDemographics?.GetType().GetProperty(property.Name)?.GetValue(_cisServiceDemographics);
                var v3 = _cisServiceComposition?.GetType().GetProperty(property.Name)?.GetValue(_cisServiceComposition);

                var propertyValue = v1 ?? v2 ?? v3;


                var isString = property.PropertyType == typeof(string);

                if (isString && string.IsNullOrWhiteSpace((string)propertyValue))
                {
                    invalidFields.Add(field?.Value ?? property.Name);
                    continue;
                }


                if (propertyValue == null)
                {
                    invalidFields.Add(field?.Value ?? property.Name);
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
