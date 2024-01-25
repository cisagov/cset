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
	public class SectorIndustryVM
	{

		public int Id { get; set; }
		public int SectorId { get; set; }
		public string SectorName { get; set; }
		public List<string> Industries { get; set; }


	}

}

