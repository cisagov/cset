using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Assessment
{
    public class AssessmentNaming
    {
        /// <summary>
        /// determines the assessment Name;
        /// HAS the side effect of changing the assessment name in CISA Assessor Mode
        /// </summary>
        /// <returns>Nothing</returns>
        static public void ProcessName(CsetwebContext context, int userid, int assessmentid)
        {
            var user = context.USERS.Where(user => user.UserId == userid).FirstOrDefault();
            var assessment = context.ASSESSMENTS.Where(am => am.Assessment_Id == assessmentid).FirstOrDefault();
            var info = context.INFORMATION.Where(info =>  info.Id == assessmentid).FirstOrDefault();
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
            if (user.CisaAssessorWorkflow)
            {
                var date =  assessment.Assessment_Date.ToString("yyyy-MM-dd-HHmm");
                var OrgName = info.Facility_Name;
                var shortName = String.Join(',', maturityModels) + String.Join(',', stnds).Trim(',');                
                var pcii = assessment.Is_PCII?"pcii":"non-pcii";

                date = assessment.Is_PCII ? assessment.PCII_Number : date;
                var assessmentName = $"{OrgName} {shortName}.{pcii}.{date}".Trim();
                info.Assessment_Name = assessmentName;
                context.SaveChanges();
            }

        }
    }
}
