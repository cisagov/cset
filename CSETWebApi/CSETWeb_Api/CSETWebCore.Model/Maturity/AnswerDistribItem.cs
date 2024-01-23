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

namespace CSETWebCore.Model.Maturity
{
    /// <summary>
    /// Used for calculating answer distributios.
    /// </summary>
    public class DistribItem
    {
        public string Value { get; set; }
        public int Count { get; set; }
        public double Percent { get; set; }
    }


    public class LevelAnswers
    {
        public string Name { get; set; }
        public int LevelValue { get; set; }
        public List<DistribItem> AnswerDistribution { get; set; }
    }


    public class DomainAnswers
    {
        public string DomainName { get; set; }
        public List<DistribItem> AnswerDistribution { get; set; }
    }
}
