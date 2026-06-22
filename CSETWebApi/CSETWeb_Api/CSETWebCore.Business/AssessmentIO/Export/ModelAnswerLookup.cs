using CSETWebCore.Helpers;
using System;
using System.Collections.Generic;
using System.Text.Json;


namespace CSETWebCore.Business.AssessmentIO.Export
{
    /// <summary>
    /// Provides simple dictionary lookup of answer text 
    /// based on the answer code and an optional model ID.
    /// </summary>
    public class ModelAnswerLookup
    {
        private Dictionary<string, Dictionary<string, string>> _models;

        public ModelAnswerLookup()
        {
            var rh = new ResourceHelper();
            var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "AnswerDisplayValues.json"));

            var root = JsonSerializer.Deserialize<JsonElement>(json);
            var modelsArray = root.GetProperty("Models")[0];

            _models = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);

            foreach (var model in modelsArray.EnumerateObject())
            {
                var entries = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (var prop in model.Value.EnumerateObject())
                {
                    if (prop.Name == "ModelName") continue;
                    entries[prop.Name] = prop.Value.GetString();
                }
                _models[model.Name] = entries;
            }
        }


        /// <summary>
        /// When looking up a standard or component answer, use 0 for the modelId.
        /// </summary>
        /// <param name="modelId"></param>
        /// <param name="answerCode"></param>
        /// <returns></returns>
        public string GetDisplayValue(int modelId, string answerCode)
        {
            if (modelId != 0)
            {
                var key = modelId.ToString();
                if (_models.TryGetValue(key, out var model) &&
                    model.TryGetValue(answerCode, out var display))
                {
                    return display;
                }
            }

            _models["Default"].TryGetValue(answerCode, out var defaultDisplay);
            return defaultDisplay ?? answerCode;
        }
    }
}
