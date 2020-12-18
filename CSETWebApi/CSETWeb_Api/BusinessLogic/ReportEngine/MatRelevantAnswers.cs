//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class MatRelevantAnswers
    {
        public MatRelevantAnswers()
        {
        }

        public ANSWER ANSWER { get; set; }
        public MATURITY_QUESTIONS Mat { get; set; }
    }
}