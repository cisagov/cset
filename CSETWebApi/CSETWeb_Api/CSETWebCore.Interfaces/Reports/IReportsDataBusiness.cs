using System.Collections.Generic;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Diagram;
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
        List<List<DiagramZones>> GetDiagramZones();
        List<usp_getFinancialQuestions_Result> GetFinancialQuestions();
        List<StandardQuestions> GetQuestionsForEachStandard();
        List<ComponentQuestion> GetComponentQuestions();
        List<usp_GetOverallRankedCategoriesPage_Result> GetTop5Categories();
        List<RankedQuestions> GetTop5Questions();
        List<QuestionsWithAltJust> GetQuestionsWithAlternateJustification();
        List<QuestionsWithComments> GetQuestionsWithComments();
        List<QuestionsMarkedForReview> GetQuestionsMarkedForReview();
        List<RankedQuestions> GetRankedQuestions();
        List<DocumentLibraryTable> GetDocumentLibrary();
        BasicReportData.OverallSALTable GetNistSals();
        List<BasicReportData.CNSSSALJustificationsTable> GetNistInfoTypes();
        BasicReportData.OverallSALTable GetSals();
        BasicReportData.INFORMATION GetInformation();
        List<Individual> GetFindingIndividuals();
        GenSALTable GetGenSals();
        List<MaturityReportData.MaturityModel> GetMaturityModelData();
        string FormatName(string firstName, string lastName);


    }
}