using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class USERS
    {
        public USERS()
        {
            ASSESSMENTS = new HashSet<ASSESSMENTS>();
            ASSESSMENT_CONTACTS = new HashSet<ASSESSMENT_CONTACTS>();
        }

        [Required]
        [StringLength(150)]
        public string PrimaryEmail { get; set; }
        public int UserId { get; set; }
        [Required]
        [StringLength(250)]
        public string Password { get; set; }
        [Required]
        [StringLength(250)]
        public string Salt { get; set; }
        public bool IsSuperUser { get; set; }
        [Required]
        public bool? PasswordResetRequired { get; set; }
        [StringLength(150)]
        public string FirstName { get; set; }
        [StringLength(150)]
        public string LastName { get; set; }
        public Guid? Id { get; set; }

        [InverseProperty("User")]
        public virtual USER_SECURITY_QUESTIONS USER_SECURITY_QUESTIONS { get; set; }
        [InverseProperty("AssessmentCreator")]
        public virtual ICollection<ASSESSMENTS> ASSESSMENTS { get; set; }
        [InverseProperty("User")]
        public virtual ICollection<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
    }
}