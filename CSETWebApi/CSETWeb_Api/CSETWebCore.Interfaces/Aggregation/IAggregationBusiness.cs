//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Interfaces.Aggregation
{
    public interface IAggregationBusiness
    {
        List<Model.Aggregation.Aggregation> GetAggregations(string mode, int currentUserId);
        Model.Aggregation.Aggregation CreateAggregation(string mode);
        Model.Aggregation.Aggregation GetAggregation(int aggregationId);
        int SaveAggregationInformation(int aggregationId, Model.Aggregation.Aggregation aggreg);
        void DeleteAggregation(int aggregationId);
        AssessmentListResponse GetAssessmentsForAggregation(int aggregationId);
        string GetNextAvailableAlias(List<string> a, List<string> b);
        Model.Aggregation.Aggregation SaveAssessmentSelection(int aggregationId, int assessmentId, bool selected);

        string SaveAssessmentAlias(int aggregationId, int assessmentId, string alias,
            List<AssessmentSelection> assessList);

        void IncludeStandards(ref AssessmentListResponse response);
        float CalcCompatibility(string mode, List<int> assessmentIds);
        List<MissedQuestion> GetCommonlyMissedQuestions(int aggregationId);
        List<MissedQuestion> BuildQList(List<List<int>> answeredNo);
        List<MissedQuestion> BuildRList(List<List<int>> answeredNo);
    }
}