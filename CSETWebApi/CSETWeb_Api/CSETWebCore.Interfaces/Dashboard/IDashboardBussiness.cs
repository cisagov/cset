//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Dashboard;

namespace CSETWebCore.Interfaces.Dashboard
{
    public interface IDashboardBusiness
    {
        //Task<List<AssessmentData>> GetUserAssessments(string userId);
        Task<List<SectorIndustryVM>> GetSectors();
        Task<DashboardGraphData> GetDashboardData(string industry);
    }
}
