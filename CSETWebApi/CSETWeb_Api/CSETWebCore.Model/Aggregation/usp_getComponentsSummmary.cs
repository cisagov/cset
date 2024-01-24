//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class usp_getComponentsSummmary
    {
        public double YesNumber { get; set; }
        public double YesPercent { get; set; }

        public double NoNumber { get; set; }
        public double NoPercent { get; set; }

        public double NANumber { get; set; }
        public double NAPercent { get; set; }

        public double AltNumber { get; set; }
        public double AltPercent { get; set; }

        public double UnansweredNumber { get; set; }
        public double UnansweredPercent { get; set; }

        public double TotalNumber { get; set; }
        public double TotalPercent { get; set; }

        public string Answer_Text { get; set; }
        public string Answer_Full_Name { get; set; }
        public int vcount { get; set; }
        public decimal value { get; set; }
    }
}