using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Demographic
{
    public class SectorMultiManager
    {
        private readonly CSETContext _context;


        public SectorMultiManager(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns a List<SectorSubsector>.  If no sectors
        /// have been persisted, an empty one is added to the response.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<SectorSubsector> Get(int assessmentId)
        {
            var resp = new List<SectorSubsector>();

            var ss = _context.ASSESSMENT_SECTOR_SUBSECTOR.Where(x => x.Assessment_Id == assessmentId).ToList();
            foreach (var sectorSubsector in ss)
            {
                var x = new SectorSubsector() { SectorId = sectorSubsector.SectorId, SubsectorId = sectorSubsector.IndustryId, Sequence = sectorSubsector.Sequence };

                x.SubsectorList = GetSubsectorList((int)x.SectorId);

                resp.Add(x);
            }

            if (resp.Count == 0)
            {
                // first, see if the assessment has DETAILS_DEMOGRAPHICS records describing the sector
                var convertedFromDetDemog = ConvertSectorDetailsDemographics(assessmentId);
                if (convertedFromDetDemog != null)
                {
                    resp.Add(convertedFromDetDemog);
                }
                else
                {
                    // create an empty pair
                    resp.Add(new SectorSubsector() { SectorId = null, SubsectorId = null, Sequence = 1 });
                }
            }

            return resp;
        }


        /// <summary>
        /// Returns list of subsectors for a sector
        /// </summary>
        /// <param name="sectorId"></param>
        /// <returns></returns>
        private List<ListItem2> GetSubsectorList(int sectorId)
        {
            var resp = new List<ListItem2>();
            var gg = _context.SECTOR_INDUSTRY.Where(x => x.SectorId == sectorId).ToList();
            foreach (var g in gg)
            {
                var li = new ListItem2() { OptionValue = g.IndustryId, OptionText = g.IndustryName };
                resp.Add(li);
            }

            return resp;
        }


        /// <summary>
        /// Converts the DETAILS_DEMOGRAPHICS sector info into a SectorSubsector pair.
        /// Cleans up the DETAILS_DEMOGRAPHICS records.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        private SectorSubsector ConvertSectorDetailsDemographics(int assessmentId)
        {
            var ddSector = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "SECTOR").FirstOrDefault();
            var ddSubsector = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "SUBSECTOR").FirstOrDefault();

            if (ddSector != null && ddSector.IntValue != null)
            {
                SectorSubsector resp;
                resp = new SectorSubsector() { SectorId = ddSector.IntValue, Sequence = 1 };
                resp.SubsectorList = GetSubsectorList((int)resp.SectorId);

                if (ddSubsector != null)
                {
                    resp.SubsectorId = ddSubsector.IntValue;
                }


                // save the new ASSESSMENT_SECTOR_INDUSTRY record
                var newRec = new ASSESSMENT_SECTOR_SUBSECTOR() { 
                    Assessment_Id = assessmentId, 
                    SectorId = (int)ddSector.IntValue, 
                    IndustryId = resp.SubsectorId, 
                    Sequence = 1 };

                _context.Add(newRec);


                // clean up the old DETAILS_DEMOGRAPHICS records
                _context.Remove(ddSector);
                if (ddSubsector != null)
                {
                    _context.Remove(ddSubsector);
                }

                _context.SaveChanges();

                return resp;
            }

            return null;
        }


        /// <summary>
        /// Persists sectors/subsectors to the database for the assessment.
        /// Any previously saved sectors in the database are overwritten.
        /// The sequence is saved in the order that the sectors occur
        /// in the specified list.
        /// </summary>
        public void Save(int assessmentId, SectorSubsector requestSector)
        {
            var dbTarget = _context.ASSESSMENT_SECTOR_SUBSECTOR
                .Where(x => x.Assessment_Id == assessmentId && x.Sequence == requestSector.Sequence).FirstOrDefault();


            if (requestSector.SectorId == null)
            {
                _context.ASSESSMENT_SECTOR_SUBSECTOR.Remove(dbTarget);
            }

            if (requestSector.SectorId.HasValue)
            {
                if (dbTarget == null)
                {
                    dbTarget = new ASSESSMENT_SECTOR_SUBSECTOR()
                    {
                        Assessment_Id = assessmentId,
                        SectorId = (int)requestSector.SectorId,
                        IndustryId = requestSector.SubsectorId,
                        Sequence = requestSector.Sequence
                    };
                    _context.ASSESSMENT_SECTOR_SUBSECTOR.Add(dbTarget);
                }
                else
                {
                    // if they changed the sector, null the subsector
                    if (dbTarget.SectorId != requestSector.SectorId)
                    {
                        dbTarget.SectorId = (int)requestSector.SectorId;
                        dbTarget.IndustryId = null;
                    }
                    else
                    {
                        dbTarget.IndustryId = requestSector.SubsectorId;
                    }
                }
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// Removes a sector/subsector record from the assessment.
        /// </summary>
        public void Delete(int assessmentId, int sequence)
        {
            var target = _context.ASSESSMENT_SECTOR_SUBSECTOR.Where(a => a.Assessment_Id == assessmentId && a.Sequence == sequence).FirstOrDefault();
            if (target != null)
            {
                _context.ASSESSMENT_SECTOR_SUBSECTOR.Remove(target);
                _context.SaveChanges();
            }
        }
    }
}

