//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Model.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Analytics
{
    public class AnalyticsBusiness: IAnalyticsBusiness
    {
        private CSETContext _context;

        public AnalyticsBusiness(CSETContext context)
        {
            _context = context;

        }
        
        
        public List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id, int? sectorId, int? industryId)
        {
           // var minMax = _context.analytics_Compute_MaturityAll(maturity_model_id,sectorId,industryId).ToList();
            // var median = _context.analytics_Compute_MaturityAll_Median(maturity_model_id).ToList();
            // var rvalue =  from a in minMax join b in median on a.Title equals b.Title
            //             select new DataRowsAnalytics() { title=a.Title, avg=(int)a.avg,max=(int)a.max,min=(int)a.min,median=b.median};
            // return rvalue.ToList();
            return  _context.analytics_Compute_MaturityAll(maturity_model_id,sectorId,industryId).ToList();
        }

        public List<AnalyticsgetMedianOverall> GetMaturityGroupsForAssessment(int assessmentId, int maturity_model_id)
        {
            return _context.analytics_compute_single_averages_maturity(assessmentId,maturity_model_id).ToList();
        }
        public List<standardAnalyticsgetMedianOverall> GetStandardSingleAvg(int assessmentId, string set_name)
        {
            return _context.analytics_compute_single_averages_standard(assessmentId,set_name).ToList();
        }
        
        public List<SetStandard>  GetStandardList(int assessmentId)
        {
            // var resultsList = from standards in _context.AVAILABLE_STANDARDS
            //     join sets in _context.SETS
            //         on standards.Set_Name equals sets.Set_Name
            //     where standards.Assessment_Id == assessmentId
            //     select sets.Full_Name;
            var results = _context.analytics_selectedStandardList(assessmentId);
            return results.ToList();
        }

        public List<AnalyticsStandardMinMaxAvg> GetStandardMinMaxAvg(int assessmentId, string setname, int? sectorId, int? industryId)
        {
            var minmaxavg = _context.analytics_Compute_standard_all(assessmentId,setname, sectorId, industryId);
            return minmaxavg.ToList();
        }
    }
}
