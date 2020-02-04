//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Models
{
    /// <summary>
    /// A cyber-security assessment.
    /// </summary>
    public class AssessmentDetail
    {
        public int Id;
        public string AssessmentName;
        public DateTime CreatedDate;
        public int CreatorId;
        public DateTime? AssessmentDate;
        public string FacilityName;
        public string CityOrSiteName;
        public string StateProvRegion;

        public string Charter;
        public string CreditUnion;
        public string Assets;
        public bool? IsAcetOnly;

        /// <summary>
        /// The last time the Assessment was altered.
        /// </summary>
        public DateTime LastModifiedDate;

        public string AdditionalNotesAndComments { get; set; }
        public string AssessmentDescription { get; set; }
        public string ExecutiveSummary { get; set; }
    }
}

