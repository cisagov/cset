//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.ACETDashboard
{
    public interface IACETDashboardBusiness
    {
        Model.Acet.ACETDashboard LoadDashboard(int assessmentId, string lang = "en");
        string GetOverallIrp(int assessmentId);
        int GetOverallIrpNumber(int assessmentId);
        Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId);
        void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary);
    }
}