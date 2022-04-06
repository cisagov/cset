using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Analytics;
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
        
        
        public List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id)
        {
           var minMax = _context.analytics_Compute_MaturityAll(maturity_model_id).ToList();
            var median = _context.analytics_Compute_MaturityAll_Median(maturity_model_id).ToList();
            var rvalue =  from a in minMax 
                          join b in median on a.Title equals b.Title
                        select new AnalyticsMinMaxAvgMedianByGroup() { Title=a.Title, avg=a.avg,max=a.max,min=a.min,median=b.median};
            return rvalue.ToList();        
        }
    }
}
