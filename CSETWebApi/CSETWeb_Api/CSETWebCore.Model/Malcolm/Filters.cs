using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Malcolm
{
    public class Filters
    {
        [JsonProperty(PropertyName = "network.direction")]
        public List<string> Network_Direction { get; set; } = new List<string>();
        public string Tags { get; set; }
    }
}
