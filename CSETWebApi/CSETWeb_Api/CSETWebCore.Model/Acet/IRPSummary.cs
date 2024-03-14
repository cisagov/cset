//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Acet
{
    public class IRPSummary
    {
        public int HeaderId { get; set; }
        public string HeaderText { get; set; }
        public int[] RiskCount { get; set; }
        public int RiskSum { get; set; }
        public int RiskLevel { get; set; }
        public int RiskLevelId { get; set; }
        public string Comment { get; set; }


        /// <summary>
        /// Constructor.
        /// </summary>
        public IRPSummary()
        {
            RiskCount = new int[5];
        }
    }
}
