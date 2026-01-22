using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;


namespace CSETWebCore.Model.Demographic
{
    public class SectorSubsector
    {
        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }
        public int Sequence { get; set; }

        /// <summary>
        /// Carries the subsector list applicable to the SectorId
        /// </summary>
        public List<ListItem> IndustryList { get; set; } = [];
    }
}
