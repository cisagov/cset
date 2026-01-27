using System.Collections.Generic;


namespace CSETWebCore.Model.Demographic
{
    public class SectorSubsector
    {
        public int? SectorId { get; set; }
        public int? SubsectorId { get; set; }
        public int Sequence { get; set; }

        /// <summary>
        /// Carries the subsector list applicable to the SectorId
        /// </summary>
        public List<ListItem2> SubsectorList { get; set; } = [];
    }
}
