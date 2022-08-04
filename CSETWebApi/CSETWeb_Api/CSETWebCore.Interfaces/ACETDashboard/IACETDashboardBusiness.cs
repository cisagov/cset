using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.ACETDashboard
{
    public interface IACETDashboardBusiness
    {
        Task<Model.Acet.ACETDashboard> LoadDashboard(int assessmentId);
        Task<string> GetOverallIrp(int assessmentId);
        Task<int> GetOverallIrpNumber(int assessmentId);
        Task<Model.Acet.ACETDashboard> GetIrpCalculation(int assessmentId);
        Task UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary);
    }
}