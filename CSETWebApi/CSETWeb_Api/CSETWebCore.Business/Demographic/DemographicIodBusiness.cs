using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Business.Demographic
{
    public class DemographicIodBusiness
    {
        /// <summary>
        /// Returns an object 
        /// </summary>
        /// <returns></returns>
        public DemographicIod GetDemographics(int assessmentId, CSETContext context)
        {
            var x = context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).ToList();

            var d = new DemographicIod();
            d.AssessmentId = assessmentId;
            d.AnnualRevenue = x.Find(z => z.DataItemName == "")?.StringValue;
            d.CriticalServiceRevenuePercent = x.Find(z => z.DataItemName == "")?.StringValue;
            // ...

            return d;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="demographic"></param>
        public void SaveDemographics(DemographicIod demographic)
        {

        }
    }
}
