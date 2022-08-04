using System.Collections.Generic;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Acet;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Maturity
{
    public interface IMaturityBusiness
    {
        Task<MaturityModel> GetMaturityModel(int assessmentId);
        Task<int> GetMaturityTargetLevel(int assessmentId);
        Task<List<MaturityDomainRemarks>> GetDomainRemarks(int assessmentId);
        Task SetDomainRemarks(int assessmentId, MaturityDomainRemarks remarks);
        Task<List<MaturityLevel>> GetMaturityLevelsForModel(int maturityModelId, int targetLevel);
        Task<List<MaturityModel>> GetAllModels();
        Task PersistSelectedMaturityModel(int assessmentId, string modelName);
        Task ClearMaturityModel(int assessmentId);
        Task PersistMaturityLevel(int assessmentId, int level);
        Task<AVAILABLE_MATURITY_MODELS> ProcessModelDefaults(int assessmentId, string installationMode);
        object GetEdmPercentScores(int assessmentId);
        Task<MaturityResponse> GetMaturityQuestions(int assessmentId, string installationMode, bool fill);

        void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers);

        Task<int> StoreAnswer(int assessmentId, Answer answer);
        Task<double> GetAnswerCompletionRate(int assessmentId);
        Task<List<MaturityDomain>> GetMaturityAnswers(int assessmentId);
        Task<bool> GetTargetBandOnly(int assessmentId);
        Task SetTargetBandOnly(int assessmentId, bool value);

        Task<List<MaturityDomain>> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity,
            int assessmentId);

       Task<List<string>> GetMaturityRange(int assessmentId);
        Task<List<int>> GetMaturityRangeIds(int assessmentId);
        List<string> IrpSwitch(int irpRating);
        Task<Dictionary<int, MaturityMap>> GetRequirementMaturityLevels();
        object GetEdmScores(int assessmentId, string section);
        Task<object> GetReferenceText(string modelName);
        Task<List<GlossaryEntry>> GetGlossaryEntries(int modelId);
        Task<List<GlossaryEntry>> GetGlossaryEntries(string modelName);
        Task<Model.Acet.ACETDashboard> LoadDashboard(int assessmentId);
        Task<string> GetOverallIrp(int assessmentId);
        Task<int> GetOverallIrpNumber(int assessmentId);
        Task<Model.Acet.ACETDashboard> GetIrpCalculation(int assessmentId);
        Task UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary);
    }
}