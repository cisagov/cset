using System;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.DataLayer;

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
        /// Updates the "LastAccessedDate" of the Assessment.
        /// TODO:  The database column should be renamed to LastModifiedDate.
        /// </summary>
        public void TouchAssessment(int assessmentId)
        {
            DateTime nowUTC = _utilities.LocalToUtc(DateTime.Now);

            try
            {
                var assess = _context.ASSESSMENTS.First(a => a.Assessment_Id == assessmentId);
                assess.LastAccessedDate = nowUTC;
                _context.SaveChanges();
            }
            catch (Exception)
            {
                // On a brand new claim, the token does not yet have an assessment in the payload.
                // TouchAssessment() is smart enough to not blow up if there is no current assessment.
            }
        }
    }
}