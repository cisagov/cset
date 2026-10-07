using CSETWebCore.Helpers;
using System;
using System.Collections.Generic;
using System.Globalization;
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

            if (string.IsNullOrWhiteSpace(json))
            {
                throw new InvalidOperationException("The answer display values resource is missing.");
            }

            using var document = JsonDocument.Parse(json);
            var root = document.RootElement;
            if (root.ValueKind != JsonValueKind.Object ||
                !root.TryGetProperty("Models", out var models) ||
                models.ValueKind != JsonValueKind.Array ||
                models.GetArrayLength() == 0 ||
                models[0].ValueKind != JsonValueKind.Object)
            {
                throw new InvalidOperationException("The answer display values resource has an invalid format.");
            }

            _models = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);

            foreach (var model in models[0].EnumerateObject())
            {
                var entries = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (var prop in model.Value.EnumerateObject())
                {
                    if (prop.Name == "ModelName") continue;

                    if (prop.Value.ValueKind != JsonValueKind.String)
                    {
                        throw new InvalidOperationException("The answer display values resource contains a non-string display value.");
                    }

                    entries[prop.Name] = prop.Value.GetString();
                }
                _models[model.Name] = entries;
            }

            if (!_models.ContainsKey("Default"))
            {
                throw new InvalidOperationException("The answer display values resource does not define a Default model.");
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
            if (answerCode == null)
            {
                return null;
            }

            if (modelId != 0)
            {
                var key = modelId.ToString(CultureInfo.InvariantCulture);
                if (_models.TryGetValue(key, out var model) &&
                    model.TryGetValue(answerCode, out var display))
                {
                    return display;
                }
            }

            if (_models.TryGetValue("Default", out var defaultModel) &&
                defaultModel.TryGetValue(answerCode, out var defaultDisplay))
            {
                return defaultDisplay;
            }

            return answerCode;
        }
    }
}
