//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Assessment
{
    public class AnalyticsDemographic
    {
        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string IndustryName { get; set; }
        public string SectorName { get; set; }
        public string Size { get; set; }
        public string AssetValue { get; set; }
    }
}