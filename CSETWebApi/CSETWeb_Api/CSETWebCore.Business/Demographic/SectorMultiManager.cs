//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;
using System;
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

            // Normalize legacy HSPD-7 values before reading either storage format.
            // This keeps every caller consistent, regardless of which endpoint is
            // the first one used to load the assessment.
            new SectorUpgradePpd21(_context).UpgradeSector(assessmentId);

            var currentSectorIds = _context.SECTOR
                .Where(x => !x.Is_NIPP)
                .Select(x => x.SectorId)
                .ToHashSet();

            var ss = _context.ASSESSMENT_SECTOR_SUBSECTOR
                .Where(x => x.Assessment_Id == assessmentId)
                .ToList()
                .Where(x => currentSectorIds.Contains(x.SectorId));

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
            return _context.SECTOR_INDUSTRY
            .Where(x => x.SectorId == sectorId && !x.Is_NIPP)
            .Select(x => new ListItem2
            {
                OptionValue = x.IndustryId,
                OptionText = x.IndustryName
            })
            .ToList();
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

            if (ddSector?.IntValue != null
                && _context.SECTOR.Any(x =>
                    x.SectorId == ddSector.IntValue.Value
                    && !x.Is_NIPP))
            {
                SectorSubsector resp;
                resp = new SectorSubsector() { SectorId = ddSector.IntValue, Sequence = 1 };
                resp.SubsectorList = GetSubsectorList((int)resp.SectorId);

                if (ddSubsector?.IntValue != null
                    && _context.SECTOR_INDUSTRY.Any(x =>
                        x.IndustryId == ddSubsector.IntValue.Value
                        && x.SectorId == ddSector.IntValue.Value
                        && !x.Is_NIPP))
                {
                    resp.SubsectorId = ddSubsector.IntValue;
                }


                // save the new ASSESSMENT_SECTOR_INDUSTRY record
                var newRec = new ASSESSMENT_SECTOR_SUBSECTOR()
                {
                    Assessment_Id = assessmentId,
                    SectorId = (int)ddSector.IntValue,
                    IndustryId = resp.SubsectorId,
                    Sequence = 1
                };

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
                .FirstOrDefault(x =>
                    x.Assessment_Id == assessmentId
                    && x.Sequence == requestSector.Sequence);

            if (!requestSector.SectorId.HasValue)
            {
                if (dbTarget != null)
                {
                    _context.ASSESSMENT_SECTOR_SUBSECTOR.Remove(dbTarget);
                    _context.SaveChanges();
                }

                return;
            }

            var sectorId = requestSector.SectorId.Value;

            if (!_context.SECTOR.Any(x =>
                x.SectorId == sectorId && !x.Is_NIPP))
            {
                throw new ArgumentException(
                    "The selected sector is not supported.",
                    nameof(requestSector));
            }

            var sectorChanged = dbTarget != null && dbTarget.SectorId != sectorId;

            if (!sectorChanged
                && requestSector.SubsectorId.HasValue
                && !_context.SECTOR_INDUSTRY.Any(x =>
                    x.IndustryId == requestSector.SubsectorId.Value
                    && x.SectorId == sectorId
                    && !x.Is_NIPP))
            {
                throw new ArgumentException(
                    "The selected subsector is not supported for this sector.",
                    nameof(requestSector));
            }

            if (dbTarget == null)
            {
                dbTarget = new ASSESSMENT_SECTOR_SUBSECTOR()
                {
                    Assessment_Id = assessmentId,
                    SectorId = sectorId,
                    IndustryId = requestSector.SubsectorId,
                    Sequence = requestSector.Sequence
                };
                _context.ASSESSMENT_SECTOR_SUBSECTOR.Add(dbTarget);
            }
            else
            {
                // if they changed the sector, null the subsector
                if (sectorChanged)
                {
                    dbTarget.SectorId = sectorId;
                    dbTarget.IndustryId = null;
                }
                else
                {
                    dbTarget.IndustryId = requestSector.SubsectorId;
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

