//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.Findings
{
    public class ActionItemsForReport
    {
        public ActionItemsForReport()
        {
        }

        public int Finding_Id { get; set; }
        public int Question_Id { get; set; }
        public string Description { get; set; }
        public string Action_Items { get; set; }
        public string Regulatory_Citation { get; set; }
    }
}