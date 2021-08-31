using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;

namespace CSETWebCore.Reports.Models
{
    public class CrrViewModel : PageModel
    {
        public CrrViewModel(AssessmentDetail assessmentDetails)
        {
            AssessmentDetails = assessmentDetails;
        }


        public AssessmentDetail AssessmentDetails { get; set; }

        /// <summary>
        /// RKW - This is a temporary value that should ultimately come from the DEMOGRAPHICS
        /// table, but I am not sure we have this field defined.  There is a critical service 
        /// point of contact, but no field to capture the name of the critical service itself.
        /// </summary>
        public string CriticalService { get; set; } = "Dummy Critical Service";
    }
}