using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_CONTACTS
    {
        public ASSESSMENT_CONTACTS()
        {
            FINDING_CONTACT = new HashSet<FINDING_CONTACT>();
        }

        public int Assessment_Id { get; set; }
        [StringLength(150)]
        public string PrimaryEmail { get; set; }
        [StringLength(150)]
        public string FirstName { get; set; }
        [StringLength(150)]
        public string LastName { get; set; }
        public bool Invited { get; set; }
        public int AssessmentRoleId { get; set; }
        public int? UserId { get; set; }
        [Key]
        public int Assessment_Contact_Id { get; set; }

        [ForeignKey("AssessmentRoleId")]
        [InverseProperty("ASSESSMENT_CONTACTS")]
        public virtual ASSESSMENT_ROLES AssessmentRole { get; set; }
        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_CONTACTS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("UserId")]
        [InverseProperty("ASSESSMENT_CONTACTS")]
        public virtual USERS User { get; set; }
        [InverseProperty("Assessment_Contact_")]
        public virtual ICollection<FINDING_CONTACT> FINDING_CONTACT { get; set; }
    }
}