//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using System.Text.Json;
using CSETWebCore.DataLayer.Model;
using NJsonSchema;
using NJsonSchema.Generation;


namespace CSETWebCore.Model.AssessmentIO
{
    public class StandardSchemaProcessor
    {
        /// <summary>
        /// We can't overload the constructor, so this allows us to inject the DB context.
        /// </summary>
        public static CsetwebContext dbContext { get; set; }


        /// <summary>
        /// Builds the JSON schema for the standard.
        /// </summary>
        /// <param name="context"></param>
        public void Process(SchemaProcessorContext context)
        {
            if (context.ContextualType == typeof(ExternalStandard))
            {
                var schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().category)).FirstOrDefault().Value;

                var categories = dbContext.SETS_CATEGORY.Select(s => s.Set_Category_Name).Distinct().OrderBy(s => s).ToList();


                categories.ForEach(s => schema.Enumeration.Add(s));

                var setNames = dbContext.SETS.Select(s => s.Set_Name).ToList().Union(dbContext.SETS.Select(s => s.Short_Name).ToList()).Distinct().OrderBy(s => s).ToList();

                var newSchema = new JsonSchema();
                setNames.ForEach(s => newSchema.Enumeration.Add(s));
                context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().shortName)).FirstOrDefault().Value.Not = newSchema;

                var reqs = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().requirements)).FirstOrDefault().Value;
                reqs.MinLength = 1;
            }
            else
            {
                throw new InvalidOperationException("Wrong type");
            }
        }

        private string FixCase(string s)
        {
            return JsonNamingPolicy.CamelCase.ConvertName(s);
        }
    }
}