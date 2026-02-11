//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Analysis;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Reports
{
    public interface IReportsDataBusiness
    {
        void SetReportsAssessmentId(int assessmentId);

        void SetToken(ITokenManager token);

        List<MatRelevantAnswers> GetMaturityDeficiencies(int? modelId = null);
        List<MatRelevantAnswers> GetCommentsList(int? modelId = null);
        List<MatRelevantAnswers> GetMarkedForReviewList(int? modelId = null);
        List<MatRelevantAnswers> GetAlternatesList();
        List<MatRelevantAnswers> GetQuestionsList(int? modelId = null, bool includeUnanswerable = false);

        string GetCsetVersion();
        string GetAssessmentGuid(int assessmentId);
        List<string> GetDomains();

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        List<BasicReportData.RequirementControl> GetControls(string applicationMode);
        List<List<DiagramZones>> GetDiagramZones();
        List<StandardQuestions> GetQuestionsForEachStandard();
        Task<List<StandardQuestions>> GetQuestionsForEachStandardAsync(CancellationToken cancellationToken = default);
        List<ComponentQuestion> GetComponentQuestions();
        Task<List<ComponentQuestion>> GetComponentQuestionsAsync(CancellationToken cancellationToken = default);
        List<RankedCategories> GetTop5Categories();
        Task<List<RankedQuestions>> GetTop5QuestionsAsync();
        List<QuestionsWithAltJust> GetQuestionsWithAlternateJustification();
        List<QuestionsWithComments> GetQuestionsWithComments();
        List<QuestionsMarkedForReview> GetQuestionsMarkedForReview();
        List<QuestionsMarkedForReview> GetQuestionsReviewed();
        Task<List<RankedQuestions>> GetRankedQuestionsAsync();
        List<DocumentLibraryEntry> GetDocumentLibrary();
        BasicReportData.OverallSALTable GetNistSals();
        List<BasicReportData.CNSSSALJustificationsTable> GetNistInfoTypes();
        BasicReportData.OverallSALTable GetSals();
        BasicReportData.INFORMATION GetInformation();
        List<Individual> GetObservationIndividuals();
        Task<List<Individual>> GetObservationIndividualsAsync(CancellationToken cancellationToken = default);
        GenSALTable GetGenSals();
        MaturityReportData.MaturityModel GetBasicMaturityModel();
        List<MaturityReportData.MaturityModel> GetMaturityModelData();
        string FormatName(string firstName, string lastName);

        IEnumerable<CONFIDENTIAL_TYPE> GetConfidentialTypes();
        List<BasicReportData.RequirementControl> GetControlsDiagram(string applicationMode);
        Task<List<PhysicalQuestions>> GetQuestionsWithSupplementalsAsync();
        Task<List<StandardQuestions>> GetStandardQuestionAnswers(int assessId);
    }
}