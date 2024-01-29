//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class IRPHeader
    {
        public string header { get; set; }
        public List<IRPModel> irpList { get; set; }


        /// <summary>
        /// Constructor.
        /// </summary>
        public IRPHeader()
        {
            irpList = new List<IRPModel>();
        }
    }
}