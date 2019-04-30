//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.Controllers
{
    public class usp_getRankedStandardCategories
    {
        public int Yes { get; set; }
        public int No { get; set; }
        public int NA { get; set; }
        public int Alt { get; set; }
        public int Unanswered { get; set; }
        public int Total { get; set; }
        public double Value { get; set; }
        public string Set_Name { get; set; }
        public string Question_Group_Heading { get; set; }
    }
}

