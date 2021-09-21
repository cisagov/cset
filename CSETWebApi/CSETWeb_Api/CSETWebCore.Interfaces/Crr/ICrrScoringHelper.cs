using System.Collections.Generic;
using System.Xml.Linq;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Crr
{
    public interface ICrrScoringHelper
    {
        public int AssessmentId { get; set; }
        public int CrrModelId { get;}
        public XDocument XDoc { get; set; }
        public void InstantiateScoringHelper(int assessmentId);
        public void LoadStructure();

        public void GetSubgroups(XElement xE, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        public void ManipulateStructure();
        public void Rollup();
        public string GetColor(XElement xE);
        public void SetColor(XElement xE, string color);
        public string B2S(bool b);

        public AnswerColorDistrib FullAnswerDistrib();
        public AnswerColorDistrib DomainAnswerDistrib(string domainAbbrev);
        public AnswerColorDistrib GoalAnswerDistrib(string domainAbbrev, string goalAbbrev);
    }
}