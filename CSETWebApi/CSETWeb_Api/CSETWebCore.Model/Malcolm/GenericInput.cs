using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Malcolm;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Model.Malcolm
{
    public class GenericInput: List<GenericInput>
    {
        public List<string> Fields { get; set; }
        public List<Filters> Filters { get; set; }
        public List<int> Range { get; set; }
        public List<string> Urls { get; set; }
        //public JArray Buckets { get; set; }
        public Values Values { get; set; }
    }
}
