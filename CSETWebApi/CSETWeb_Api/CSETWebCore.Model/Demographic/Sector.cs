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