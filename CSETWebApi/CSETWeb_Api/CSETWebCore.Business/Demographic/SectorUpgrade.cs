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
            var dbSector = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x => x.Assessment_Id == assessmentId && x.DataItemName == "SECTOR");

            // do nothing if the sector is not a candidate for upgrading
            if (dbSector == null || dbSector.IntValue == null || !HSPD7ToPPD21SectorIds.ContainsKey((int)dbSector.IntValue))
            {
                return null;
            }

            var resp = new SectorUpdateResult();

            // update and persist sector/subsector records
            var oldSectorId = dbSector.IntValue;

            var newSectorId = GetPpd21SectorId((int)dbSector.IntValue);
            if (newSectorId != null)
            {
                dbSector.IntValue = newSectorId;
                resp.SectorId = (int)newSectorId;
            }


            // save an ACKNOWLEDGMENT flag; let the caller know that the sector was changed
            if (newSectorId != oldSectorId)
            {
                var ack = new DETAILS_DEMOGRAPHICS()
                {
                    Assessment_Id = assessmentId,
                    DataItemName = Constants.Constants.ACK_SECTOR_UPDATED_PPD21,
                    BoolValue = true
                };

                if (!_context.DETAILS_DEMOGRAPHICS.Any(d =>
                    d.Assessment_Id == assessmentId &&
                    d.DataItemName == Constants.Constants.ACK_SECTOR_UPDATED_PPD21))
                {
                    _context.DETAILS_DEMOGRAPHICS.Add(ack);
                }

                resp.Changed = true;
            }


            var dbSubsector = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x => x.Assessment_Id == assessmentId && x.DataItemName == "SUBSECTOR");
            if (dbSubsector != null)
            {
                _context.Remove(dbSubsector);
            }

            _context.SaveChanges();

            return resp;
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
