//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;


namespace CSETWebCore.Business.RLaaS
{
    /// <summary>
    /// A combo of GEN_FILE and FileType
    /// </summary>
    public class ReferenceDocument
    {
        public GEN_FILE GenFile { get; set; }
        public FILE_TYPE FileType { get; set; }
    }
}
