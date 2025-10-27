using CSETWebCore.Helpers;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Business.Demographic
{
    public class FieldValidation
    {
        private List<KeyValueOverlay> _pairs;


        /// <summary>
        /// CTOR
        /// </summary>
        public FieldValidation()
        {
            var rh = new ResourceHelper();
            string path = @"App_Data\FieldValidation\FieldValidation.json";

            string json = rh.GetEmbeddedResource(path);
            _pairs = JsonConvert.DeserializeObject<List<KeyValueOverlay>>(json);
        }


        /// <summary>
        /// Returns the field validation value for the specified key.
        /// If the key is not found, null is returned.
        /// </summary>
        public KeyValueOverlay GetValidatedFieldLabels(string key)
        {
            var label = _pairs.FirstOrDefault(x => x.Key.ToLower() == key.ToLower());

            return label;
        }
    }

}
