using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class ASSESSMENT_ROLES
    {
        public ASSESSMENT_ROLES()
        {
            ASSESSMENT_CONTACTS = new HashSet<ASSESSMENT_CONTACTS>();
        }

        public int AssessmentRoleId { get; set; }
        [Required]
        [StringLength(50)]
        public string AssessmentRole { get; set; }

        [InverseProperty("AssessmentRole")]
        public virtual ICollection<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
    }
}