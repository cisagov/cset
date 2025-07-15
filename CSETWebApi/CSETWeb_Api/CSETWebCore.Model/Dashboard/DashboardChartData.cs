//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Dashboard
{
	public class DashboardChartData
	{
		public string name { get; set; }
		public List<Series> series { get; set; }
	}


	public class Series
	{
		public string name { get; set; }
		public double value { get; set; }
	}


	/// <summary>
	/// Helper class for totalling answers and determining
	/// percentages.
	/// </summary>
    public class DomainAnswerCount
    {
        public string DomainName { get; set; }
        public string AnswerOptionName { get; set; }
        public int AnswerCount { get; set; }
    }
}

