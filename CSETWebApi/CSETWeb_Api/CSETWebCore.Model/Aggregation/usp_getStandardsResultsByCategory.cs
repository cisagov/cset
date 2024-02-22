//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class usp_getStandardsResultsByCategory
    {
        public string Short_Name { get; set; }
        public string Set_Name { get; set; }
        public string Question_Group_Heading { get; set; }
        public int QGH_Id { get; set; }
        public int yaCount { get; set; }
        public int Actualcr { get; set; }
        public decimal prc { get; set; }
    }
}