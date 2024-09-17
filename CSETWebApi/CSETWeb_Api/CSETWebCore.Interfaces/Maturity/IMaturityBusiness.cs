//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer.Model;


namespace CSETWebCore.Interfaces.Maturity
{
    public interface IMaturityBusiness
    {
        MaturityModel GetMaturityModel(int assessmentId);
        int GetMaturityTargetLevel(int assessmentId);
        List<MaturityDomainRemarks> GetDomainRemarks(int assessmentId);
        void SetDomainRemarks(int assessmentId, MaturityDomainRemarks remarks);
        List<MaturityLevel> GetMaturityLevelsForModel(int maturityModelId, int targetLevel);
        List<MaturityModel> GetAllModels();

        void ClearMaturityModel(int assessmentId);

        object GetEdmPercentScores(int assessmentId);
        MaturityResponse GetMaturityQuestions(int assessmentId, bool fill, int groupingId, string lang);

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers,
            string lang);

        int StoreAnswer(int assessmentId, Answer answer);
        object GetEdmScores(int assessmentId, string section);
        object GetReferenceText(string modelName);
        List<GlossaryEntry> GetGlossaryEntries(int modelId);
        List<GlossaryEntry> GetGlossaryEntries(string modelName);

        void PersistSelectedMaturityModel(int assessmentId, string modelName);
        void PersistMaturityLevel(int assessmentId, int level);
    }
}