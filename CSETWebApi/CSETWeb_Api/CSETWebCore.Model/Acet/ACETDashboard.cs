using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class ACETDashboard
    {
        public string CreditUnionName;
        public string Charter;
        public string Assets;
        public decimal Hours;

        //IRP Section
        public List<IRPSummary> IRPs;
        public int[] SumRisk;
        public int SumRiskLevel;
        public int SumRiskTotal; //i regret the names i started using.
        public int Override;
        public string OverrideReason;

        //Cybersecurity Maturity Section
        public List<DashboardDomain> Domains;

        public ACETDashboard()
        {
            IRPs = new List<IRPSummary>();
            SumRisk = new int[5];
        }
    }
}