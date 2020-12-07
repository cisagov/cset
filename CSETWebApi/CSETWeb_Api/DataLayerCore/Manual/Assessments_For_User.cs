//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DataLayerCore.Model
{
    /// <summary>
    /// A cyber-security assessment.
    /// </summary>
    public partial class Assessments_For_User
    {
        public int AssessmentId { get; set; }

        public string AssessmentName { get; set; }

        public DateTime AssessmentDate { get; set; }

        public DateTime AssessmentCreatedDate { get; set; }

        public string CreatorName { get; set; }    
        
        public DateTime LastModifiedDate { get; set; }

        /// <summary>
        /// Indicates if any questions in the assessment are marked for review
        /// </summary>
        public bool MarkedForReview { get; set; }  
        
        /// <summary>
        /// Indicates if any questions in the assessment are answered ALT 
        /// but have no corresponding alternate answer text. 
        /// </summary>
        public bool AltTextMissing { get; set; }

        public int UserId { get; set; }
    }
}

