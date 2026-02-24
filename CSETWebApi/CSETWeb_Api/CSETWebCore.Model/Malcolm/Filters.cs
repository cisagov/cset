////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using Newtonsoft.Json;
using System.Collections.Generic;

namespace CSETWebCore.Model.Malcolm
{
    public class Filters
    {
        [JsonProperty(PropertyName = "network.direction")]
        public List<string> Network_Direction { get; set; } = new List<string>();
        public string Tags { get; set; }
    }
}
