//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class ACETDashboard
    {
        public string CreditUnionName { get; set; }
        public string Charter { get; set; }
        public string Assets { get; set; }
        public decimal Hours { get; set; }

        //IRP Section
        public List<IRPSummary> Irps { get; set; }
        public int[] SumRisk { get; set; }
        public int SumRiskLevel { get; set; }
        public int SumRiskTotal { get; set; } //i regret the names i started using.
        public int Override { get; set; }
        public string OverrideReason { get; set; }

        //Cybersecurity Maturity Section
        public List<DashboardDomain> Domains { get; set; }


        /// <summary>
        /// Constructor
        /// </summary>
        public ACETDashboard()
        {
            Irps = new List<IRPSummary>();
            SumRisk = new int[5];
        }
    }
}