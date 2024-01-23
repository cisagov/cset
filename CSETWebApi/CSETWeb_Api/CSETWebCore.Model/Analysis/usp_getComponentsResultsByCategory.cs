//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Analysis
{
    public class usp_getComponentsResultsByCategory
    {
        public string Question_Group_Heading { get; set; }

        public int passed { get; set; }

        public int total { get; set; }

        public decimal percent { get; set; }
    }
}