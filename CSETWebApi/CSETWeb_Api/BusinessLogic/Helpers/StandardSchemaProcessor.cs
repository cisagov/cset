//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using NJsonSchema;
using NJsonSchema.Generation;
using NJsonSchema.Generation.TypeMappers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public class StandardSchemaProcessor : ISchemaProcessor
    {

        void ISchemaProcessor.Process(SchemaProcessorContext context)
        {

            if (context.Type == typeof(ExternalStandard))
            {
                var schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().Category)).FirstOrDefault().Value;
                using (var db = new CSET_Context())
                {
                    var categories = db.SETS_CATEGORY.Select(s => s.Set_Category_Name).Distinct().OrderBy(s => s).ToList();
                    categories.ForEach(s => schema.Enumeration.Add(s));
                    var setNames = db.SETS.Select(s => s.Set_Name).ToList().Union(db.SETS.Select(s => s.Short_Name).ToList()).Distinct().OrderBy(s => s).ToList();
                    var newSchema = new JsonSchema();
                    setNames.ForEach(s => newSchema.Enumeration.Add(s));
                    context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().ShortName)).FirstOrDefault().Value.Not = newSchema;
                    var reqs = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().Requirements)).FirstOrDefault().Value;
                    reqs.MinLength = 1;
                }
            }
            else
            {
                throw new InvalidOperationException("Wrong type");
            }
        }
    }
}


