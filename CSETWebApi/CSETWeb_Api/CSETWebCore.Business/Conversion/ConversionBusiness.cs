//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Business.Demographic;
using System.Linq;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http.HttpResults;

namespace CSETWebCore.Business.Contact
{
    public class ConversionBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// The set name for the Cyber Florida trimmed down CSF set
        /// </summary>
        private readonly string CF_CSF_SetName = "Florida_NCSF_V2";
        private readonly string[] CF_CSF_SetNames = { "Florida_NCSF_V2", "Florida_NCSF_V1" };

        /// <summary>
        /// The set name for Cybersecurity Framework v1.1
        /// </summary>
        private readonly string CF_SetName = "NCSF_V2";


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public ConversionBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// Returns true if the assessment has a MATURITY-SUBMODEL record of 'RRA CF'
        /// or the standard 'Florida_CSF_v1' is selected.
        /// Normally, both conditions will be true for a Cyber Florida entry assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public bool IsEntryCF(int assessmentId)
        {
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");

            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && CF_CSF_SetNames.Contains(x.Set_Name) && x.Selected).FirstOrDefault();

            if (cfRraRecord != null || availStandard != null)
            {
                return true;
            }

            return false;
        }

        public List<CFEntry> IsEntryCF(List<int> assessmentIds)
        {
            List<CFEntry> results = new List<CFEntry>();
            foreach (var assessmentId in assessmentIds)
            {
                results.Add(new CFEntry() { AssessmentId = assessmentId, IsEntry = IsEntryCF(assessmentId) });
            }
            return results;
        }


        /// <summary>
        /// Converts a Cyber Florida "entry" assessment to a full
        /// assessment with CSF 1.1 and RRA.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void ConvertCF(int assessmentId)
        {
            // Delete the "CF RRA" submodel record.  This will have the effect of looking
            // at the entire RRA model.
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");
            if (cfRraRecord != null)
            {
                _context.DETAILS_DEMOGRAPHICS.Remove(cfRraRecord);
            }


            // swap out the AVAILABLE_STANDARDS record for the full CSF record
            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && x.Set_Name == CF_CSF_SetName && x.Selected).FirstOrDefault();

            if (availStandard != null)
            {
                _context.AVAILABLE_STANDARDS.Remove(availStandard);


                var newAvailStandard = new AVAILABLE_STANDARDS()
                {
                    Assessment_Id = assessmentId,
                    Selected = true,
                    Set_Name = CF_SetName
                };

                _context.AVAILABLE_STANDARDS.Add(newAvailStandard);
            }


            // add details_demographics flagging the assessment as a "used to be a CyberFlorida entry assessment"
            var biz = new DemographicBusiness(_context, _assessmentUtil);
            biz.SaveDD(assessmentId, "FORMER-CF-ENTRY", "true", null);

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }
    }
}
