using CSETWebCore.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Edm;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;
using System.Xml.Linq;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Model.Crr;

namespace CSETWebCore.Reports.Models
{
    public class CrrViewModel : PageModel
    {
        public CrrViewModel(AssessmentDetail assessmentDetails, 
            string criticalService,
            List<EdmScoreParent> parentScores,
            ICrrScoringHelper crrScores
            //CrrResultsModel CrrResultsData = null
            )
        {
            AssessmentDetails = assessmentDetails;
            ParentScores = parentScores;
            //crrResultsData = CrrResultsData;
            CriticalService = CriticalService;
            CRRScores = crrScores;
        }
        public CrrResultsModel crrResultsData { get; set; }

        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        public ICrrScoringHelper CRRScores { get; set; }

        public CrrReportChart ReportChart { get; set; }

        public string CriticalService { get; set; }
    }

}