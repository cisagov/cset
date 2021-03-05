//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.BusinessLogic.Models
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

        public string DiagramMarkup;
        public string DiagramImage;

        // Selected features of the assessment
        public bool UseStandard;
        public bool UseDiagram;
        public bool UseMaturity;
        public bool? IsAcetOnly;

        // Selected maturity model and the target level
        public MaturityModel MaturityModel;

        public List<string> Standards;


        /// <summary>
        /// The last time the Assessment was altered.
        /// </summary>
        public DateTime LastModifiedDate;

        public string AdditionalNotesAndComments { get; set; }
        public string AssessmentDescription { get; set; }
        public string ExecutiveSummary { get; set; }
        
    }
}

