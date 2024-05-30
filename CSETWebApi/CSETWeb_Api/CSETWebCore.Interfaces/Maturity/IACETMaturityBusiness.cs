using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Maturity
{
    public interface IACETMaturityBusiness
    {
        List<MaturityDomain> GetMaturityAnswers(int assessmentId, string lang = "en");
        bool GetTargetBandOnly(int assessmentId);
        void SetTargetBandOnly(int assessmentId, bool value);
        List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity,
    int assessmentId, string lang = "en");

        List<string> GetMaturityRange(int assessmentId);
        List<string> GetIseMaturityRange(int assessmentId);
        List<int> GetMaturityRangeIds(int assessmentId);
        List<int> GetIseMaturityRangeIds(int assessmentId);
        List<string> IrpSwitch(int irpRating);
        List<string> IrpSwitchIse(int irpRating);
        Dictionary<int, MaturityMap> GetRequirementMaturityLevels();
        Model.Acet.ACETDashboard LoadDashboard(int assessmentId, string lang = "en");
        string GetOverallIrp(int assessmentId);
        int GetOverallIrpNumber(int assessmentId);
        Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId);
        void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary);
        

    }
}
