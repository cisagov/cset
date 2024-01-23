//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Model.Analytics
{
    public class Analytics
    {
        public AnalyticsAssessment Assessment { get; set; }
        public AnalyticsDemographic Demographics { get; set; }
        public List<AnalyticsQuestionAnswer> QuestionAnswers { get; set; }
    }
}