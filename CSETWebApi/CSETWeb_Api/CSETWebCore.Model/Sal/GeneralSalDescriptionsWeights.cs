//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Sal
{
    public class GeneralSalDescriptionsWeights
    {
        public string Sal_Name { get; set; }
        public string Sal_Description { get; set; }
        public int Sal_Order { get; set; }
        public Nullable<int> min { get; set; }
        public Nullable<int> max { get; set; }
        public Nullable<int> step { get; set; }
        public List<GenSalWeights> GEN_SAL_WEIGHTS { get; set; }
        public string prefix { get; set; }
        public string postfix { get; set; }
        public List<string> values { get; set; }
        public int Slider_Value { get; set; }
    }
}