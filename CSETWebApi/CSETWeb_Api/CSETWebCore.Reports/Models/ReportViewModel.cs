using CSETWebCore.Business.Reports;
using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CSETWebCore.Reports.Models
{
    /// <summary>
    /// This model is used to power the simple reports,
    /// deficiency, comments/mfr and alt justifications.
    /// </summary>
    public class ReportViewModel : PageModel
    {
        public ReportViewModel(AssessmentDetail assessmentDetails, 
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