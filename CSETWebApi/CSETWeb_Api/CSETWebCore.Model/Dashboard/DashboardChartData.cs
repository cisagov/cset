//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
}

