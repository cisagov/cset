//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Cmu;
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
            ICmuScoringHelper crrScores,
            MaturityBasicReportData reportData)
        {
            AssessmentDetails = assessmentDetails;
            CriticalService = criticalService;
            CRRScores = crrScores;
            ReportData = reportData;
            PageNumbers = new Dictionary<string, int>();
        }
        public CmuResultsModel crrResultsData { get; set; }

        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        public ICmuScoringHelper CRRScores { get; set; }

        public object Structure { get; set; }

        public CmuReportChart ReportChart { get; set; }

        public string CriticalService { get; set; }

        public MaturityBasicReportData ReportData { get; set; }

        public Dictionary<string, int> PageNumbers { get; set; }

        public bool IncludeResultsStylesheet { get; set; }
    }
}
