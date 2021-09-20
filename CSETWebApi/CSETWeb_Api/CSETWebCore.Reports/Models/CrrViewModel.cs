using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Edm;
using CSETWebCore.Reports.Models.CRR;
using CSETWebCore.Business.Reports;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Reports.Models
{
    public class CrrViewModel : PageModel
    {
        public CrrViewModel(AssessmentDetail assessmentDetails, List<EdmScoreParent> parentScores, MIL1ScoreParent mil1Scores, CrrResultsModel CrrResultsData = null)
        {
            AssessmentDetails = assessmentDetails;
            ParentScores = parentScores;
            MIL1Score = mil1Scores;
            crrResultsData = CrrResultsData;

        }
        public CrrResultsModel crrResultsData { get; set; }

        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        public MIL1ScoreParent MIL1Score { get; set; }
        /// <summary>
        /// RKW - This is a temporary value that should ultimately come from the DEMOGRAPHICS
        /// table, but I am not sure we have this field defined.  There is a critical service 
        /// point of contact, but no field to capture the name of the critical service itself.
        /// </summary>
        public string CriticalService { get; set; } = "Dummy Critical Service";
    }

}