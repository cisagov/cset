//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Standards
{
    public class StandardCategory
    {
        public string CategoryName { get; set; }
        public List<Standard> Standards { get; set; }

        public StandardCategory()
        {
            Standards = new List<Standard>();
        }
    }
}