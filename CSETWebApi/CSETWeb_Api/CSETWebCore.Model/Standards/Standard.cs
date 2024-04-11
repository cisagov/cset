//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Standards
{
    public class Standard
    {
        public string Code { get; set; }
        public string FullName { get; set; }
        public string Description { get; set; }
        public bool Selected { get; set; }
        public bool Recommended { get; set; }
    }
}