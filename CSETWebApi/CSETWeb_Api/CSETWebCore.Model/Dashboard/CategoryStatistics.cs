//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

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