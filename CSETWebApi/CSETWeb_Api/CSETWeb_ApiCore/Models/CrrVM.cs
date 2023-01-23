//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Crr;
using CSETWebCore.Model.Edm;
using CSETWebCore.Reports.Models;
using System.Collections.Generic;
using System.Xml.Linq;

namespace CSETWebCore.Api.Models
{
    public class CrrVM
    {
        public CrrVM(AssessmentDetail assessmentDetails,
            string criticalService,
            ICrrScoringHelper crrScores,
            MaturityBasicReportData reportData)
        {
            AssessmentDetails = assessmentDetails;
            CriticalService = criticalService;
            CRRScores = crrScores;
            ReportData = reportData;
            PageNumbers = new Dictionary<string, int>();
        }
        public CrrResultsModel crrResultsData { get; set; }

        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        public ICrrScoringHelper CRRScores { get; set; }

        public object Structure { get; set; }

        public CrrReportChart ReportChart { get; set; }

        public string CriticalService { get; set; }

        public MaturityBasicReportData ReportData { get; set; }

        public Dictionary<string, int> PageNumbers { get; set; }

        public bool IncludeResultsStylesheet { get; set; }
    }
}
