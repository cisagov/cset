//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Model.Reports
{
    public class ReportVM
    {
        public ReportVM(AssessmentDetail assessmentDetails, MaturityBasicReportData reportData)
        {
            AssessmentDetails = assessmentDetails;
            ReportData = reportData;
        }

        public AssessmentDetail AssessmentDetails { get; set; }
        public MaturityBasicReportData ReportData { get; set; }
    }
}
