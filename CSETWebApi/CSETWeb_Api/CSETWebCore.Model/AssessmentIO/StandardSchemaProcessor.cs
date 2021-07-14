using System;
using System.Linq;
using CSETWebCore.DataLayer;
using NJsonSchema;
using NJsonSchema.Generation;


namespace CSETWebCore.Model.AssessmentIO
{
    public class StandardSchemaProcessor
    {
        private readonly CSETContext _context;

        public StandardSchemaProcessor(CSETContext context)
        {
            _context = context;
        }

        public void Process(SchemaProcessorContext context)
        {

            if (context.Type == typeof(ExternalStandard))
            {
                var schema = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().Category)).FirstOrDefault().Value;

                    var categories = _context.SETS_CATEGORY.Select(s => s.Set_Category_Name).Distinct().OrderBy(s => s).ToList();
                    categories.ForEach(s => schema.Enumeration.Add(s));
                    var setNames = _context.SETS.Select(s => s.Set_Name).ToList().Union(_context.SETS.Select(s => s.Short_Name).ToList()).Distinct().OrderBy(s => s).ToList();
                    var newSchema = new JsonSchema();
                    setNames.ForEach(s => newSchema.Enumeration.Add(s));
                    context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().ShortName)).FirstOrDefault().Value.Not = newSchema;
                    var reqs = context.Schema.Properties.Where(s => s.Key == PropertyHelpers.GetPropertyName(() => new ExternalStandard().Requirements)).FirstOrDefault().Value;
                    reqs.MinLength = 1;
            }
            else
            {
                throw new InvalidOperationException("Wrong type");
            }
        }
    }
}