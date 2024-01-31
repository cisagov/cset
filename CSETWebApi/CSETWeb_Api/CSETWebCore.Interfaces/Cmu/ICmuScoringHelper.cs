//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Xml.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Cmu;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Reports.Models;

namespace CSETWebCore.Interfaces.Cmu
{
    public interface ICmuScoringHelper
    {
        public int AssessmentId { get; set; }
        public int ModelId { get; }
        public XDocument XDoc { get; set; }
        public XDocument XCsf { get; set; }
        public void InstantiateScoringHelper(int assessmentId);
        public void LoadStructure();
        public CmuResultsModel GetCmuResultsSummary();
        public void GetSubgroups(XElement xE, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers,
            List<MATURITY_DOMAIN_REMARKS> domainRemarks);

        public void ManipulateStructure();
        public void Rollup();
        CmuReportChart GetPercentageOfPractice();
        public string GetColor(XElement xE);
        public void SetColor(XElement xE, string color);
        public Dictionary<string, string> CsfFunctionColors { get; }
        public string B2S(bool b);

        public AnswerColorDistrib FullAnswerDistrib();
        public AnswerColorDistrib MIL1FullAnswerDistrib();
        public AnswerColorDistrib DomainAnswerDistrib(string domainAbbrev);
        public AnswerColorDistrib MIL1DomainAnswerDistrib(string domainAbbrev);
        public AnswerColorDistrib GoalAnswerDistrib(string domainAbbrev, string goalAbbrev);
        public AnswerColorDistrib CrrReferenceAnswerDistrib(XElement element);
    }
}