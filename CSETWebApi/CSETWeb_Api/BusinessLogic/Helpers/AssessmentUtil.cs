using CSETWeb_Api.Helpers;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;


namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public class AssessmentUtil
    {
        /// <summary>
        /// Updates the "LastAccessedDate" of the Assessment.
        /// TODO:  The database column should be renamed to LastModifiedDate.
        /// </summary>
        public static void TouchAssessment(int assessmentId)
        {
            DateTime nowUTC = Utilities.LocalToUtc(DateTime.Now);

            Task.Run(() =>
            {
                try
                {
                    var db = new DataLayer.CSETWebEntities();
                    var assess = db.ASSESSMENTS.First(a => a.Assessment_Id == assessmentId);
                    assess.LastAccessedDate = nowUTC;
                    db.SaveChanges();
                }
                catch (Exception exc)
                {
                    // On a brand new claim, the token does not yet have an assessment in the payload.
                    // TouchAssessment() is smart enough to not blow up if there is no current assessment.
                }
            });
        }
    }
}
