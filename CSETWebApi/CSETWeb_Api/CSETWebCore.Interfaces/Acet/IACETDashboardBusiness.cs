using CSETWebCore.Model.Acet;

namespace CSETWebCore.Interfaces.Acet
{
    public interface IACETDashboardBusiness
    {
        ACETDashboard LoadDashboard(int assessmentId);
        string GetOverallIrp(int assessmentId);
        int GetOverallIrpNumber(int assessmentId);
        ACETDashboard GetIrpCalculation(int assessmentId);
        void UpdateACETDashboardSummary(int assessmentId, ACETDashboard summary);
    }
}