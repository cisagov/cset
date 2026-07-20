////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Demographic
{
    /// <summary>
    /// Converts an HSPD-7 sector ID to its equivalent PPD-21 sector ID
    /// </summary>
    public class SectorUpgradePpd21
    {
        private readonly CSETContext _context;

        /// <summary>
        /// Map of HSPD-7 sector IDs to their equivalent PPD-21 
        /// </summary>
        public static readonly Dictionary<int, int> HSPD7ToPPD21SectorIds = new Dictionary<int, int>
        {
           { 17, 10 },
           { 18,  9 },
           { 19,  1 },
           { 20,  2 },
           { 21,  3 },
           { 22,  5 },
           { 23,  6 },
           { 24,  7 },
           { 25,  8 },
           { 26, 11 },
           { 27, 12 },
           { 28, 13 },
           { 29,  4 },
           { 30, 11 },
           { 31, 14 },
           { 32, 15 },
           { 33, 15 },
           { 34, 16 }
        };


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public SectorUpgradePpd21(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Changes an HSPD-7 sector ID to its equivalent PPD-21 sector ID.
        /// Removes any existing subsector/industry selection.
        /// Adds an acknowledgement record to alert the user if this change takes place.
        /// </summary>
        /// <param name="assessmentId"></param>
        public SectorUpdateResult UpgradeSector(int assessmentId)
        {
            var result = new SectorUpdateResult();
            var demographicSectorChanged = false;

            // Upgrade legacy sector data stored in DETAILS_DEMOGRAPHICS.
            var demographicSector = _context.DETAILS_DEMOGRAPHICS
                .FirstOrDefault(x =>
                    x.Assessment_Id == assessmentId
                    && x.DataItemName == "SECTOR");

            if (demographicSector?.IntValue != null
                && HSPD7ToPPD21SectorIds.TryGetValue(
                    demographicSector.IntValue.Value,
                    out var mappedDemographicSectorId))
            {
                demographicSector.IntValue = mappedDemographicSectorId;

                result.SectorId = mappedDemographicSectorId;
                result.Changed = true;
                demographicSectorChanged = true;
            }

            // Upgrade legacy sector data stored in the current sector table.
            // Legacy subsectors are cleared because there is no reliable
            // one-to-one mapping to the current taxonomy.
            var persistedSectors = _context.ASSESSMENT_SECTOR_SUBSECTOR
                .Where(x => x.Assessment_Id == assessmentId)
                .ToList();

            foreach (var persistedSector in persistedSectors)
            {
                if (HSPD7ToPPD21SectorIds.TryGetValue(
                    persistedSector.SectorId,
                    out var mappedSectorId))
                {
                    persistedSector.SectorId = mappedSectorId;
                    persistedSector.IndustryId = null;

                    result.SectorId = mappedSectorId;
                    result.Changed = true;
                }
            }

            if (!result.Changed)
            {
                return null;
            }

            // Only clear the DETAILS_DEMOGRAPHICS subsector when its associated
            // DETAILS_DEMOGRAPHICS sector was converted.  A conversion in the
            // multi-sector table must not delete an unrelated current selection.
            if (demographicSectorChanged)
            {
                var demographicSubsector = _context.DETAILS_DEMOGRAPHICS
                    .FirstOrDefault(x =>
                        x.Assessment_Id == assessmentId
                        && x.DataItemName == "SUBSECTOR");

                if (demographicSubsector != null)
                {
                    _context.DETAILS_DEMOGRAPHICS.Remove(demographicSubsector);
                }
            }

            // Notify the user that one or more sector selections were converted.
            var acknowledgementExists = _context.DETAILS_DEMOGRAPHICS.Any(x =>
                x.Assessment_Id == assessmentId
                && x.DataItemName == Constants.Constants.ACK_SECTOR_UPDATED_PPD21);

            if (!acknowledgementExists)
            {
                _context.DETAILS_DEMOGRAPHICS.Add(
                    new DETAILS_DEMOGRAPHICS
                    {
                        Assessment_Id = assessmentId,
                        DataItemName = Constants.Constants.ACK_SECTOR_UPDATED_PPD21,
                        BoolValue = true
                    });
            }

            _context.SaveChanges();

            return result;
        }


        /// <summary>
        /// Returns the PPD-21 equivalent of a specified
        /// HSPD-7 sector ID.  If the specified sector ID
        /// is not HSPD-7, the supplied sector ID is returned.
        /// </summary>
        /// <param name="sectorId"></param>
        /// <returns></returns>
        private int? GetPpd21SectorId(int? sectorId)
        {
            if (sectorId == null)
            {
                return null;
            }

            if (HSPD7ToPPD21SectorIds.ContainsKey((int)sectorId))
            {
                return HSPD7ToPPD21SectorIds[(int)sectorId];
            }

            return sectorId;
        }
    }


    public class SectorUpdateResult
    {
        public int SectorId { get; set; }
        public bool Changed { get; set; } = false;
    }
}
