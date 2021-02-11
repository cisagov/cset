//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWeb_Api.Controllers
{
    public class GetPercentageOverall
    {
        public int Assessment_Id { get; set; }
        public string Name { get; set; }
        public string StatType { get; set; }
        public int Total { get; set; }
        public int Y { get; set; }
        public int N { get; set; }
        public int NA { get; set; }
        public int A { get; set; }
        public int U { get; set; }
        public double Value { get; set; }
        public int TotalNoNA { get; set; }
    }
}

