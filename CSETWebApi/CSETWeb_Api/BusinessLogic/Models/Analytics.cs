//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class Analytics
    {
        public AnalyticsAssessment Assessment { get; set; }
        public AnalyticsDemographic Demographics { get; set; }
        public List<AnalyticsQuestionAnswer> QuestionAnswers { get; set; }
    }
}
