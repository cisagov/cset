//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public class AssessmentUtil : IAssessmentUtil
    {
        private CSETContext _context;

        public AssessmentUtil(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Updates the "LastModifiedDate" and "ModifiedSinceLastExport" flag of the Assessment.
        /// </summary>
        public void TouchAssessment(int assessmentId)
        {
            DateTime nowUTC = DateTime.UtcNow;

            try
            {
                var assess = _context.ASSESSMENTS.First(a => a.Assessment_Id == assessmentId);
                assess.LastModifiedDate = nowUTC;
                assess.ModifiedSinceLastExport = true;
                _context.SaveChanges();
            }
            catch (Exception exc)
            {
                // On a brand new claim, the token does not yet have an assessment in the payload.
                // TouchAssessment() is smart enough to not blow up if there is no current assessment.

                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }
        }
    }
}