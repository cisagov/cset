//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class IRPSpanishRow
    {
        public int IRP_Header_Id { get; set; }
        public string SpanishHeader { get; set; }
        public string EnglishHeader { get; set; }


        /// <summary>
        /// Constructor.
        /// </summary>
        public IRPSpanishRow() { }
    }
}