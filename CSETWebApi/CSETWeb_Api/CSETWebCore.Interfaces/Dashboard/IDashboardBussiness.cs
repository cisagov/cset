using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.Model.Dashboard;
using CSETWebCore.Model.Demographic;

namespace CSETWebCore.Interfaces.Dashboard
{
	public interface IDashboardBussiness
	{
		Task<List<AssessmentData>> GetUserAssessments(string userId);
		Task<List<Sector>> GetSectors();
		Task<DashboardGraphData> GetDashboardData(string industry, string assessmentId);
	}
}

