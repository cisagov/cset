//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.Controllers
{
    public class usp_getComponentsResultsByCategory
    {   
        public string Question_Group_Heading { get; set; }   

        public int passed { get; set; }

        public int total { get; set; }

        public decimal percent { get; set; }
    }
}

