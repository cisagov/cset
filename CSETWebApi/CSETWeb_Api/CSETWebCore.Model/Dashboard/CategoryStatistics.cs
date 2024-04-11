//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Text;

namespace CSETWebCore.Model
{
    public class CategoryStatistics
    {
        public string AssessmentId { get; set; }
        public string CategoryName { get; set; }
        public int AnsweredYes { get; set; }
        public double NormalizedYes { get; set; }
        public int Total { get; set; }

        public object Take(int v)
        {
            throw new NotImplementedException();
        }
    }
}