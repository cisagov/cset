//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
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
