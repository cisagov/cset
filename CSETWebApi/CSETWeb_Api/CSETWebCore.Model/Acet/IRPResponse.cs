//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class IRPResponse
    {
        public List<IRPHeader> headerList { get; set; }


        /// <summary>
        /// Constructor.
        /// </summary>
        public IRPResponse()
        {
            headerList = new List<IRPHeader>();
        }
    }
}