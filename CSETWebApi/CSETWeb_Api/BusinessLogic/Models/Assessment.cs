//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
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
    public class Assessment
    {
        public int AssessmentId;
        public string AssessmentName;
        public DateTime AssessmentCreatedDate;
        public string CreatorName;
        public DateTime LastModifiedDate;

        /// <summary>
        /// Indicates if any questions in the assessment are marked for review
        /// </summary>
        public bool MarkedForReview;
    }
}

