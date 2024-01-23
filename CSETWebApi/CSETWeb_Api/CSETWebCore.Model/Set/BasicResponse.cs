//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class BasicResponse
    {
        public List<string> InformationalMessages = new List<string>();
        public List<string> ErrorMessages = new List<string>();
    }
}