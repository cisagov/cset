using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;

namespace CSETWebCore.Reports.Models
{
    public class CRRCoverSheetModel : PageModel
    {
        public CRRCoverSheetModel(AssessmentDetail assessmentDetails)
        {
            AssessmentDetails = assessmentDetails;
        }


        public AssessmentDetail AssessmentDetails { get; set; }
    }
}