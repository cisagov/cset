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

	public class DashboardGraphData
	{

		public List<ScatterPlot> Min { get; set; }
		public List<MedianScatterPlot> Median { get; set; }
		public List<ScatterPlot> Max { get; set; }
		public BarChart BarData { get; set; }
		public int sampleSize { get; set; }
	}

}

