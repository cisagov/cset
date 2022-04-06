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
           var minMax = _context.analytics_Compute_MaturityAll(maturity_model_id);
           var median = from a in minMax 
                        join b in _context.analytics_Compute_MaturityAll_Median(maturity_model_id)
                        on a.Question_Group_Heading equals b.Question_Group_Heading
                        select new AnalyticsMinMaxAvgMedianByGroup() { min=a.min, max=a.max, avg=a.avg,median=b.median, Question_Group_Heading=a.Question_Group_Heading };
            return median.ToList();           
            
            

        }
    }
}
