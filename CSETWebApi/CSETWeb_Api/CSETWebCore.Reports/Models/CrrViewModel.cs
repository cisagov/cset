using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Edm;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Reports.Models
{
    public class CrrViewModel : PageModel
    {
        public CrrViewModel(AssessmentDetail assessmentDetails, List<EdmScoreParent> parentScores)
        {
            AssessmentDetails = assessmentDetails;
            ParentScores = parentScores;
        }


        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        /// <summary>
        /// RKW - This is a temporary value that should ultimately come from the DEMOGRAPHICS
        /// table, but I am not sure we have this field defined.  There is a critical service 
        /// point of contact, but no field to capture the name of the critical service itself.
        /// </summary>
        public string CriticalService { get; set; } = "Dummy Critical Service";
    }
}