using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using DocumentFormat.OpenXml.Bibliography;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Assessment
{
    /// <summary>
    /// 
    /// </summary>
    public class UserAcknowledge
    {
        private readonly CSETContext _context;
        private readonly int _assessmentId;


        public UserAcknowledge(
            CSETContext context,
            ITokenManager tokenManager
            )
        {
            _context = context;
            _assessmentId = tokenManager.AssessmentForUser();
        }


        /// <summary>
        /// This is the general public method.  As new
        /// acknowledgements are added, create a
        /// request object that can hold details about
        /// what to do.  
        /// 
        /// For this first iteration I only clear the "sector changed" flag.
        /// </summary>
        /// <param name="request"></param>
        public void Ack(object request)
        {
            // do whatever here
            ClearSectorChangedFlag();
        }


        /// <summary>
        /// Deletes the "sector has changed" reminder record
        /// </summary>
        private void ClearSectorChangedFlag()
        {
            var dd = _context.DETAILS_DEMOGRAPHICS.Where(x => 
                x.Assessment_Id == _assessmentId 
                && x.DataItemName == Constants.Constants.ACK_SECTOR_UPDATED_PPD21).FirstOrDefault();

            if (dd == null)
            {
                return;
            }

            _context.DETAILS_DEMOGRAPHICS.Remove(dd);
            _context.SaveChanges();
        }
    }
}
