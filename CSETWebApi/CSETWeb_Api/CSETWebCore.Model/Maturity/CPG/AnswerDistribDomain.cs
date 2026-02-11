//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity.CPG
{
    public class AnswerDistribDomain
    {
        public string Name { get; set; }
        public List<Series> Series { get; set; } = new List<Series>();
    }


    public class Series
    {
        public string Name { get; set; }
        public double Value { get; set; }
    }

}
