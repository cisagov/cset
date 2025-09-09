//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using System;
using System.Text.Json;

namespace CSETWebCore.Business.AssessmentIO.Export
{
    public class JSONAssessmentExportManager
    {
        /// <summary>
        /// Returns a simple example JSON payload representing an assessment export.
        /// </summary>
        public string GetJson()
        {
            var payload = new
            {
                assessment = new
                {
                    id = 123,
                    name = "Example Assessment",
                    date = DateTime.UtcNow.ToString("yyyy-MM-dd"),
                    version = "1.0"
                }
            };

            return JsonSerializer.Serialize(payload, new JsonSerializerOptions
            {
                WriteIndented = true
            });
        }
    }
}
