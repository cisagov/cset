using System.Collections.Generic;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Acet;

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
        void PersistSelectedMaturityModel(int assessmentId, string modelName);
        void ClearMaturityModel(int assessmentId);
        void PersistMaturityLevel(int assessmentId, int level);
        AVAILABLE_MATURITY_MODELS processModelDefaults(int assessmentId, bool isAcetInstallation);
        object GetEdmPercentScores(int assessmentId);
        MaturityResponse GetMaturityQuestions(int assessmentId, bool isAcetInstallation, bool fill);

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        int StoreAnswer(int assessmentId, Answer answer);
        double GetAnswerCompletionRate(int assessmentId);
        List<MaturityDomain> GetMaturityAnswers(int assessmentId);
        bool GetTargetBandOnly(int assessmentId);
        void SetTargetBandOnly(int assessmentId, bool value);

        List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity,
            int assessmentId);

        List<string> GetMaturityRange(int assessmentId);
        List<int> GetMaturityRangeIds(int assessmentId);
        List<string> IrpSwitch(int irpRating);
        Dictionary<int, MaturityMap> GetRequirementMaturityLevels();
        object GetEdmScores(int assessmentId, string section);
        object GetReferenceText(string modelName);
        List<GlossaryEntry> GetGlossaryEntries(int modelId);
        List<GlossaryEntry> GetGlossaryEntries(string modelName);
        Model.Acet.ACETDashboard LoadDashboard(int assessmentId);
        string GetOverallIrp(int assessmentId);
        int GetOverallIrpNumber(int assessmentId);
        Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId);
        void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary);
    }
}