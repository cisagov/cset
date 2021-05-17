using System.Collections.Generic;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Reports
{
    public interface IReportsDataBusiness
    {
        void SetReportsAssessmentId(int assessmentId);
        List<MatRelevantAnswers> GetMaturityDeficiences(string maturityModel);
        List<MatRelevantAnswers> GetCommentsList(string maturity);
        List<MatRelevantAnswers> GetMarkedForReviewList(string maturity);
        List<MatRelevantAnswers> GetAlternatesList();
        List<MatAnsweredQuestionDomain> GetAnsweredQuestionList();

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        List<BasicReportData.RequirementControl> GetControls();
    }
}