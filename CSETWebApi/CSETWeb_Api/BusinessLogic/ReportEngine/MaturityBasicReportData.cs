//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System.Collections.Generic;
using System.Linq;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
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