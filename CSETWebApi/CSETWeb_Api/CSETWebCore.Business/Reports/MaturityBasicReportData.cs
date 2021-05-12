//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer;
using CSETWebCore.Model;
using CSETWebCore.Model.Maturity;
using System.Collections.Generic;


namespace CSETWebCore.Business.Reports
{
    public class MaturityBasicReportData
    {
        public List<MatRelevantAnswers> DeficiencesList { get; set; }
        public BasicReportData.INFORMATION information { get; set; }
        public List<MatRelevantAnswers> AlternateList { get; set; }
        public List<MatRelevantAnswers> Comments { get; set; }
        public List<MatRelevantAnswers> MarkedForReviewList { get; set; }
        public List<MatAnsweredQuestionDomain> MatAnsweredQuestions { get; set; }
    }
}