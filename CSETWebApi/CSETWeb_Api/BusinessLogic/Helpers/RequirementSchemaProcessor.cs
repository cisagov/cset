//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.Helpers;
using DataLayer;
using NJsonSchema;
using NJsonSchema.Generation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public class RequirementSchemaProcessor : ISchemaProcessor
    {

        public async Task ProcessAsync(SchemaProcessorContext context)
        {
            if (context.Type == typeof(ExternalRequirement))
            {
                var schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalRequirement().Heading)).FirstOrDefault().Value;
                using (var db = new CSETWebEntities())
                {
                    var categories = db.QUESTION_GROUP_HEADING.Select(s => s.Question_Group_Heading1).Distinct().OrderBy(s => s).ToList();
                    categories.ForEach(s => schema.Enumeration.Add(s));
                }
                schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalRequirement().Subheading)).FirstOrDefault().Value;
                using (var db = new CSETWebEntities())
                {
                    var tempSchema = new JsonSchema4();
                    var subCategories = db.UNIVERSAL_SUB_CATEGORIES.Select(s => s.Universal_Sub_Category).Distinct().OrderBy(s => s).ToList();
                    subCategories.ForEach(s => tempSchema.Enumeration.Add(s));
                    schema.AnyOf.Add(tempSchema);
                    schema.AnyOf.Add(new JsonSchema4() { Type = JsonObjectType.String });
                }
                schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalRequirement().SecurityAssuranceLevel)).FirstOrDefault().Value;
                using (var db = new CSETWebEntities())
                {
                    var subCategories = db.UNIVERSAL_SAL_LEVEL.Select(s => s.Sal_Level_Order).Distinct().OrderBy(s => s).ToList();
                    subCategories.ForEach(s => schema.Enumeration.Add(s));
                }
            }
            else
            {
                throw new InvalidOperationException("Wrong type");
            }
        }
    }
}


