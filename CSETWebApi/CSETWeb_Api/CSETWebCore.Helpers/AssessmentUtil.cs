//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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
        private readonly IUtilities _utilities;
        private CSETContext _context;

        public AssessmentUtil(IUtilities utilities, CSETContext context)
        {
            _utilities = utilities;
            _context = context;
        }

        /// <summary>
        /// Updates the "LastModifiedDate" of the Assessment.
        /// </summary>
        public void TouchAssessment(int assessmentId)
        {
            DateTime nowUTC = _utilities.LocalToUtc(DateTime.Now);

            try
            {
                var assess = _context.ASSESSMENTS.First(a => a.Assessment_Id == assessmentId);
                assess.LastModifiedDate = nowUTC;
                _context.SaveChanges();
            }
            catch (Exception exc)
            {
                // On a brand new claim, the token does not yet have an assessment in the payload.
                // TouchAssessment() is smart enough to not blow up if there is no current assessment.

                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
            }
        }
    }
}