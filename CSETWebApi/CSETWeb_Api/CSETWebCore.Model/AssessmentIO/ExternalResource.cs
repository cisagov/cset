//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;


namespace CSETWebCore.Model.AssessmentIO
{
    [DataContract(Namespace = "", Name = "Resource")]
    public class ExternalResource // : IExternalResource
    {
        [Required]
        [DataMember]
        public string fileName { get; set; }
        [DataMember]
        public int? pageNumber { get; set; }
        [DataMember]
        public string destination { get; set; }
        [DataMember]
        public string sectionReference { get; set; }
    }
}
