//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Demographic
{
    public class Sector
    {
        public int SectorId { get; set; }
        public string SectorName { get; set; }

        public string Name
        {
            get { return SectorName; }
        }
    }
}