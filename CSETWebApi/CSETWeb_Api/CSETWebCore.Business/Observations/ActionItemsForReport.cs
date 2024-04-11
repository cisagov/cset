//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.Observations
{
    public class ActionItemsForReport
    {
        public ActionItemsForReport()
        {
        }

        public int Observation_Id { get; set; }
        public int Question_Id { get; set; }
        public string Description { get; set; }
        public string Action_Items { get; set; }
        public string Regulatory_Citation { get; set; }
    }
}