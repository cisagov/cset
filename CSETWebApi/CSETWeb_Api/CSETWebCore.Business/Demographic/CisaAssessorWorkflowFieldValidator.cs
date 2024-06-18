//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Reflection;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.CisaAssessorWorkflow;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Demographic
{
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
        /// I don't like manually validating these fields, but using data annotations was not sufficient
        /// for the complexity of the validation and allowing for null values
        /// </summary>
        /// <returns></returns>
        public CisaWorkflowFieldValidationResponse ValidateFields()
        {
            List<string> invalidFields = new List<string>();
            bool isValid = true;

            //--------------------------------
            // _demographics validation
            //--------------------------------
            List<PropertyInfo> demoProperties = typeof(Demographics).GetProperties().ToList();
            // We only need to make sure that the critical service is not null in base demographics object
            var criticalService = demoProperties.Where(p => p.Name.Equals("CriticalService")).FirstOrDefault();
            if (string.IsNullOrWhiteSpace((string)criticalService.GetValue(_demographics)))
            {
                invalidFields.Add("Critical Service");
            }

            //--------------------------------
            // _demographicsExt validation
            //--------------------------------
            List<PropertyInfo> demoExtProperties = typeof(DemographicExt).GetProperties().ToList();

            // remove Org Point of Contact - currently stored as DemographicExt but not required
            demoExtProperties.RemoveAll(x => x.Name == "OrgPointOfContact");


            foreach (PropertyInfo property in demoExtProperties)
            {
                var displayName = GetDisplayName(_demographicExt, property.Name);

                if (property.Name.StartsWith("List"))
                {
                    continue;
                }

                if (property.Name.StartsWith("Standard") && !_demographicExt.UsesStandard)
                {
                    continue;
                }

                if (property.Name.StartsWith("RegulationType") && !_demographicExt.RequiredToComply)
                {
                    continue;
                }


                if (property.Name.Equals("Reg1Other") || property.Name.Equals("Reg2Other"))
                {
                    continue;
                }

                if (property.Name.StartsWith("Share"))
                {
                    continue;
                }



                if (property.PropertyType == typeof(string) && string.IsNullOrWhiteSpace((string)property.GetValue(_demographicExt)))
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                    continue;
                }

                if (property.GetValue(_demographicExt) == null)
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                }
            }

            //--------------------------------
            // _cisServiceDemographics validation
            //--------------------------------
            List<PropertyInfo> cisServiceDemoProperties = typeof(CisServiceDemographics).GetProperties().ToList();
            foreach (PropertyInfo property in cisServiceDemoProperties)
            {
                var displayName = GetDisplayName(_cisServiceDemographics, property.Name);

                if (property.Name.StartsWith("MultiSiteDescription") && !_cisServiceDemographics.MultiSite)
                {
                    continue;
                }

                if (property.PropertyType == typeof(string) && string.IsNullOrWhiteSpace((string)property.GetValue(_cisServiceDemographics)))
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                    continue;
                }

                if (property.GetValue(_cisServiceDemographics) == null)
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                }
            }

            //--------------------------------
            // _cisServiceComposition validation
            //--------------------------------
            List<PropertyInfo> cisServiceCompProperties = typeof(CisServiceComposition).GetProperties().ToList();
            foreach (PropertyInfo property in cisServiceCompProperties)
            {
                var displayName = GetDisplayName(_cisServiceComposition, property.Name);

                if (property.Name.StartsWith("OtherDefiningSystemDescription") && (_cisServiceComposition.PrimaryDefiningSystem != 10
                    && !_cisServiceComposition.SecondaryDefiningSystems.Contains(10)))
                {
                    continue;
                }

                if (property.PropertyType == typeof(string) && string.IsNullOrWhiteSpace((string)property.GetValue(_cisServiceComposition)))
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                    continue;
                }

                if (property.GetValue(_cisServiceComposition) == null)
                {
                    invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                }
            }

            if (invalidFields.Count > 0)
            {
                isValid = false;
            }

            return new CisaWorkflowFieldValidationResponse(invalidFields, isValid);
        }


        /// <summary>
        /// Tries to find a DIsplayName custom attribute for the property. 
        /// </summary>
        public static string GetDisplayName(object obj, string propertyName)
        {
            var type = obj.GetType();
            var propertyInfo = type.GetProperty(propertyName);
            if (propertyInfo == null)
            {
                return null;
            }

            var attributes = propertyInfo.GetCustomAttributes(typeof(DisplayNameAttribute));
            if (attributes.Count() > 0)
            {
                var displayNameAttribute = (DisplayNameAttribute)attributes.ToList()[0];
                return displayNameAttribute.DisplayName;
            }

            return null;
        }
    }
}
