using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class ACETDashboard
    {
        ///Exam Preparation Section
        public string CreditUnionName;
        public string Charter;
        public string Assets;
        public int Hours;

        //IRP Section
        public List<IRPSummary> IRPs;
        public int[] SumRisk;
        public int SumRiskTotal; //i regret the names i started using.

        //Cybersecurity Maturity Section
        public List<DashboardDomain> Domains;

        public ACETDashboard()
        {
            IRPs = new List<IRPSummary>();
            SumRisk = new int[5];
        }
    }

    public class DashboardDomain
    {
        public string Name;
        public string Maturity;
    }
}
