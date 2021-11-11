using CSETWebCore.Business.Reports;
using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CSETWebCore.Reports.Models
{
    public class CmmcViewModel : PageModel
    {
        public CmmcViewModel(AssessmentDetail assessmentDetails, 
            MaturityBasicReportData reportData
            )
        {
            AssessmentDetails = assessmentDetails;
            ReportData = reportData;
        }

        public AssessmentDetail AssessmentDetails { get; set; }

        public MaturityBasicReportData ReportData { get; set; }
    }

}