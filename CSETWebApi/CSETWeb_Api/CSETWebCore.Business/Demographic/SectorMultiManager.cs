using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Demographic
{
    public class SectorMultiManager
    {
        private CSETContext _context;

        public SectorMultiManager(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns a List<SectorSubsector>.  If no sectors
        /// have been persisted, an empty one is added to the
        /// response.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<SectorSubsector> Get(int assessmentId)
        {
            var resp = new List<SectorSubsector>();

            var ss = _context.ASSESSMENT_SECTOR_SUBSECTOR.Where(x => x.Assessment_Id == assessmentId).ToList();
            foreach (var sectorSubsector in ss)
            {
                var x = new SectorSubsector() { SectorId = sectorSubsector.SectorId, IndustryId = sectorSubsector.IndustryId, Sequence = sectorSubsector.Sequence };

                x.IndustryList = GetSubsectorList((int)x.SectorId);

                resp.Add(x);
            }

            if (resp.Count == 0)
            {
                resp.Add(new SectorSubsector() { SectorId = null, IndustryId = null, Sequence = 1 });
            }

            return resp;
        }


        private List<ListItem> GetSubsectorList(int sectorId)
        {
            var resp = new List<ListItem>();
            var gg = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == sectorId).ToList();
            foreach (var g in gg)
            {
                var li = new ListItem() {  Id  = g.IndustryId , Value = g.IndustryName };
                resp.Add(li);
            }

            return resp;
        }


        /// <summary>
        /// Persists sectors/subsectors to the database for the assessment.
        /// Any previously saved sectors in the database are overwritten.
        /// The sequence is saved in the order that the sectors occur
        /// in the specified list.
        /// </summary>
        public void Save(List<SectorSubsector> sectors)
        {

            // clean out SECTOR and SUBSECTOR D_D records

            // ignore any invalid pairings, ignore any NULL sector insances

        }
    }
}
