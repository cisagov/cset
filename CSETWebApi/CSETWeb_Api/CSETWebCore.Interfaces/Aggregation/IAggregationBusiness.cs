using System.Collections.Generic;
using CSETWebCore.Model.Aggregation;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Aggregation
{
    public interface IAggregationBusiness
    {
        List<Model.Aggregation.Aggregation> GetAggregations(string mode, int currentUserId);
        Task<Model.Aggregation.Aggregation> CreateAggregation(string mode);
        Model.Aggregation.Aggregation GetAggregation(int aggregationId);
        Task<int> SaveAggregationInformation(int aggregationId, Model.Aggregation.Aggregation aggreg);
        Task DeleteAggregation(int aggregationId);
        Task<AssessmentListResponse> GetAssessmentsForAggregation(int aggregationId);
        string GetNextAvailableAlias(List<string> a, List<string> b);
        Task<Model.Aggregation.Aggregation> SaveAssessmentSelection(int aggregationId, int assessmentId, bool selected);

        Task<string> SaveAssessmentAlias(int aggregationId, int assessmentId, string alias,
            List<AssessmentSelection> assessList);

        Task<AssessmentListResponse> IncludeStandards( AssessmentListResponse response);
        Task<float> CalcCompatibility(string mode, List<int> assessmentIds);
        Task<List<MissedQuestion>> GetCommonlyMissedQuestions(int aggregationId);
        Task<List<MissedQuestion>> BuildQList(List<List<int>> answeredNo);
        Task<List<MissedQuestion>> BuildRList(List<List<int>> answeredNo);
    }
}