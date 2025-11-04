//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.Model.Dashboard;

namespace CSETWebCore.Interfaces.Dashboard
{
    public interface IDashboardBusiness
    {
        //Task<List<AssessmentData>> GetUserAssessments(string userId);
        Task<List<SectorIndustryVM>> GetSectors();
        DashboardGraphData GetDashboardData(string industry);
    }
}
