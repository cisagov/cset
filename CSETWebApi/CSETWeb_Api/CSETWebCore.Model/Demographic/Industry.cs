//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Demographic
{
    public class Industry
    {
        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string IndustryName { get; set; }
        public string Name { get { return IndustryName; } }
    }
}