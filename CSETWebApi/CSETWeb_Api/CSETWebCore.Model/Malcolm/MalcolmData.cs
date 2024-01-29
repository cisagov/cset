using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Malcolm;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;

namespace CSETWebCore.Model.Malcolm
{
    public class MalcolmData
    {
        public List<string> Fields { get; set; } = new List<string>();
        public Filters Filter { get; set; }
        public List<int> Range { get; set; } = new List<int>();
        public List<string> Urls { get; set; } = new List<string>();
        //public JArray Buckets { get; set; }
        public Values Values { get; set; }
        public Dictionary<string, TempNode> Graphs { get; set; }
        public List<TempNode> Trees { get; set; }
        
    }
}
