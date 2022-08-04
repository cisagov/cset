using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Reports
{
    public interface IReportsDataBusiness
    {
        void SetReportsAssessmentId(int assessmentId);
        Task<List<MatRelevantAnswers>> GetMaturityDeficiencies();
        Task<List<MatRelevantAnswers>> GetCommentsList();
        Task<List<MatRelevantAnswers>> GetMarkedForReviewList();
        Task<List<MatRelevantAnswers>> GetAlternatesList();
        Task<List<MatRelevantAnswers>> GetQuestionsList();
        Task<List<MatAnsweredQuestionDomain>> GetAnsweredQuestionList();
        Task<List<string>> GetDomains();

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        Task<List<BasicReportData.RequirementControl>> GetControls(string applicationMode);
        Task<List<List<DiagramZones>>> GetDiagramZones();
        Task<List<usp_getFinancialQuestions_Result>> GetFinancialQuestions();
        Task<List<StandardQuestions>> GetQuestionsForEachStandard();
        Task<List<ComponentQuestion>> GetComponentQuestions();
        Task<List<usp_GetOverallRankedCategoriesPage_Result>> GetTop5Categories();
        Task<List<RankedQuestions>> GetTop5Questions();
        Task<List<QuestionsWithAltJust>> GetQuestionsWithAlternateJustification();
        Task<List<QuestionsWithComments>> GetQuestionsWithComments();
        Task<List<QuestionsMarkedForReview>> GetQuestionsMarkedForReview();

        Task<List<RankedQuestions>> GetRankedQuestions();
        Task<List<DocumentLibraryTable>> GetDocumentLibrary();
        Task<BasicReportData.OverallSALTable> GetNistSals();
        Task<List<BasicReportData.CNSSSALJustificationsTable>> GetNistInfoTypes();
        Task<BasicReportData.OverallSALTable> GetSals();
        Task<BasicReportData.INFORMATION> GetInformation();
        Task<List<Individual>> GetFindingIndividuals();
        Task<GenSALTable> GetGenSals();
        Task<MaturityReportData.MaturityModel> GetBasicMaturityModel();
        Task<List<MaturityReportData.MaturityModel>> GetMaturityModelData();
        string FormatName(string firstName, string lastName);

        Task<IEnumerable<CONFIDENTIAL_TYPE>> GetConfidentialTypes();
    }
}