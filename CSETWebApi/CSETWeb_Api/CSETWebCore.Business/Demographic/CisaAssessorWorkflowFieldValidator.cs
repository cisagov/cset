//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.CisaAssessorWorkflow;
using CSETWebCore.Model.Demographic;
using System.Collections.Generic;
using System.ComponentModel;
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

        private readonly TranslationOverlay _overlay;


        public CisaAssessorWorkflowFieldValidator(Demographics demographics, DemographicExt demographicExt, CisServiceDemographics cisServiceDemographics, CisServiceComposition cisServiceComposition)
        {
            _demographics = demographics;
            _demographicExt = demographicExt;
            _cisServiceDemographics = cisServiceDemographics;
            _cisServiceComposition = cisServiceComposition;

            _overlay = new TranslationOverlay();
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

            // remove fields stored as Demographics but not required for CSA Report permission
            demoExtProperties.RemoveAll(x => x.Name == "OrgPointOfContact");
            demoExtProperties.RemoveAll(x => x.Name == "SectorDirective");
            demoExtProperties.RemoveAll(x => x.Name == "Acknowledgement");
            demoExtProperties.RemoveAll(x => x.Name.StartsWith("List"));
            demoExtProperties.RemoveAll(x => x.Name.Equals("Reg1Other") || x.Name.Equals("Reg2Other"));
            demoExtProperties.RemoveAll(x => x.Name.StartsWith("Share"));
            if (!_demographicExt.UsesStandard)
            {
                demoExtProperties.RemoveAll(x => x.Name.StartsWith("Standard"));
            }
            if (!_demographicExt.RequiredToComply)
            {
                demoExtProperties.RemoveAll(x => x.Name.StartsWith("RegulationType"));
            }

            var lang = "en";


            foreach (PropertyInfo property in demoExtProperties)
            {
                var displayName = GetDisplayName(_demographicExt, property.Name);


                if (property.PropertyType == typeof(string) && string.IsNullOrWhiteSpace((string)property.GetValue(_demographicExt)))
                {

                    ///
                    var itemOverlay = _overlay.GetJObject("FieldValidation", "key", displayName.ToLower(), lang);

                    if (itemOverlay != null)
                    {
                        invalidFields.Add(itemOverlay.Value<string>("value"));
                        continue;
                    }
                    else
                    {
                        invalidFields.Add(displayName);
                    }
                    ///







                    //invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());
                    //continue;
                }

                if (property.GetValue(_demographicExt) == null)
                {
                   // invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());


                    ///
                    var itemOverlay = _overlay.GetJObject("FieldValidation", "key", displayName.ToLower(), lang);

                    if (itemOverlay != null)
                    {
                        invalidFields.Add(itemOverlay.Value<string>("value"));
                    }
                    else
                    {
                        invalidFields.Add(displayName);
                    }
                    ///
                }
            }


            //--------------------------------
            // _cisServiceDemographics validation
            //--------------------------------
            List<PropertyInfo> cisServiceDemoProperties = typeof(CisServiceDemographics).GetProperties().ToList();

            if (!_cisServiceDemographics.MultiSite)
            {
            cisServiceDemoProperties.RemoveAll(x => x.Name.StartsWith("MultiSiteDescription"));
            }

            foreach (PropertyInfo property in cisServiceDemoProperties)
            {
                var displayName = GetDisplayName(_cisServiceDemographics, property.Name);

               

                if (property.PropertyType == typeof(string) && string.IsNullOrWhiteSpace((string)property.GetValue(_cisServiceDemographics)))
                {
                    //invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());

                    ///
                    var itemOverlay = _overlay.GetJObject("FieldValidation", "key", displayName.ToLower(), lang);

                    if (itemOverlay != null)
                    {
                        invalidFields.Add(itemOverlay.Value<string>("value"));
                    }
                    else
                    {
                        invalidFields.Add(displayName);
                    }
                    ///

                    continue;
                }


                if (property.GetValue(_cisServiceDemographics) == null)
                {
                    //invalidFields.Add(displayName ?? property.Name.InsertSpacesBetweenCapitals());

                    ///
                    var itemOverlay = _overlay.GetJObject("FieldValidation", "key", displayName.ToLower(), lang);

                    if (itemOverlay != null)
                    {
                        invalidFields.Add(itemOverlay.Value<string>("value"));
                    }
                    else
                    {
                        invalidFields.Add(displayName);
                    }
                    ///
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
