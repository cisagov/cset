////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using DocumentFormat.OpenXml.Office2010.Excel;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;

namespace CSETWebCore.Business.Assessment
{
    public class AssessmentNaming
    {
        /// <summary>
        /// determines the assessment Name;
        /// Has the side effect of changing the assessment name in CISA Assessor Mode
        /// 
        /// Note that the "shortName" will be blank for diagram-based assessments (no model or standard to list)
        /// </summary>
        /// <returns>Nothing</returns>
        static public void ProcessName(CsetwebContext context, int assessmentid)
        {
            var assessment = context.ASSESSMENTS.Where(am => am.Assessment_Id == assessmentid).FirstOrDefault();

            // don't change the assessment name for non-CISA assessments; leave as the user set it
            if (!assessment.AssessorMode)
            {
                return;
            }

            var info = context.INFORMATION.Where(info => info.Id == assessmentid).FirstOrDefault();
            var ddOrgName = context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentid && x.DataItemName == "ORG-NAME").FirstOrDefault();
            var maturityModels = context.AVAILABLE_MATURITY_MODELS
                                .Include(x => x.model)
                                .Where(mats => mats.Assessment_Id == assessmentid && mats.Selected == true)
                                .Select(x => x.model.Model_Name)
                                .ToList();
            var stnds = context.AVAILABLE_STANDARDS
                        .Include(x => x.Set_NameNavigation)
                        .Where(stds => stds.Assessment_Id == assessmentid)
                        .Select(x => x.Set_NameNavigation.Short_Name)
                        .ToList();


            /* Update File naming convention
               [client-assessment type-report type].pcii.[PCII Number].[extension]
               [client-assessment type - report type].non-pcii.[Date of Assessment].[extension]

                needs standards name
                
            */
            /* Update File naming convention
            [client-assessment type-report type].pcii.[PCII Number].[extension]
            [client-assessment type - report type].non-pcii.[Date of Assessment].[extension]
             */

            var date = assessment.Assessment_Date.ToString("yyyy-MM-dd");
            var OrgName = assessment.AssessorMode ? ddOrgName?.StringValue ?? "" : info.Facility_Name;

            var shortName = String.Join(',', maturityModels) + String.Join(',', stnds).Trim(',');
            var orgAndType = $"{OrgName} {shortName}".Trim();

            var pcii = assessment.Is_PCII ? "pcii" : "non-pcii";

            date = assessment.Is_PCII ? assessment.PCII_Number : date;
            var assessmentName = $"{orgAndType}.{pcii}.{date}".Trim();
            info.Assessment_Name = assessmentName;
            context.SaveChanges();
        }
    }
}
