using CSETWebCore.Helpers;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity.Configuration
{
    /// <summary>
    /// Provides configuration properties for (maturity) models defined in CSET.
    /// The properties of the models are defined in the ModelProperties.json resource
    /// </summary>
    public class ModelProfile
    {
        public ModelProperties GetModelProperties(int modelId)
        {
            var rh = new ResourceHelper();
            string json = rh.GetEmbeddedResource(@"App_Data\ModelProperties\ModelProperties.json");
            var jObj = JsonConvert.DeserializeObject<Top>(json);

            var profile = jObj.Models.FirstOrDefault(x => x.ModelId == modelId);

            return profile;
        }
    }


    /// <summary>
    /// 
    /// </summary>
    public class Top
    {
        public string Purpose { get; set; }
        public List<ModelProperties> Models { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class ModelProperties
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public List<string> DeficientAnswers { get; set; } = new List<string>();
        public bool IgnoreParentQuestions { get; set; } = false;
    }
}
