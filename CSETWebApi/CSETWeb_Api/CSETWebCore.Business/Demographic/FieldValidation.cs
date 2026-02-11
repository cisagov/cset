////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Helpers;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Business.Demographic
{
    public class FieldValidation
    {
        public List<KeyValueOverlay> Fields;


        /// <summary>
        /// CTOR
        /// </summary>
        public FieldValidation()
        {
            var rh = new ResourceHelper();
            string path = @"App_Data\FieldValidation\FieldValidation.json";

            string json = rh.GetEmbeddedResource(path);
            Fields = JsonConvert.DeserializeObject<List<KeyValueOverlay>>(json);
        }


        /// <summary>
        /// Returns the field validation value for the specified key.
        /// If the key is not found, null is returned.
        /// </summary>
        public KeyValueOverlay GetValidatedFieldLabels(string key)
        {
            var label = Fields.FirstOrDefault(x => x.Key.ToLower() == key.ToLower());

            return label;
        }
    }

}
