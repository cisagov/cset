using Microsoft.AspNetCore.Mvc.RazorPages;
using System;

namespace CSETWebCore.Reports.Models
{
    public class CRRCoverSheetModel : PageModel
    {
        public CRRCoverSheetModel(string assessmentDetails)
        {
            AssessmentDetails = assessmentDetails;
        }


        public string AssessmentDetails { get; set; }
    }
}