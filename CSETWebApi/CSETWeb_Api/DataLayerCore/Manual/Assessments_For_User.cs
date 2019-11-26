//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
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
        //[Key]
        //public int RowNumber { get; set; }
        public int AssessmentId { get; set; }
        public string AssessmentName { get; set; }
        public DateTime AssessmentCreatedDate { get; set; }
        public string CreatorName { get; set; }        
        public DateTime LastModifiedDate { get; set; }
        /// <summary>
        /// Indicates if any questions in the assessment are marked for review
        /// </summary>
        public bool MarkedForReview { get; set; }        
        public int UserId { get; set; }
    }
}

