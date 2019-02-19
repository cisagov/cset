using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_CONTACTS
    {
        public ASSESSMENT_CONTACTS()
        {
            FINDING_CONTACT = new HashSet<FINDING_CONTACT>();
        }

        public int Assessment_Id { get; set; }
        public string PrimaryEmail { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool Invited { get; set; }
        public int AssessmentRoleId { get; set; }
        public int? UserId { get; set; }
        public int Assessment_Contact_Id { get; set; }

        public virtual ASSESSMENT_ROLES AssessmentRole { get; set; }
        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual USERS User { get; set; }
        public virtual ICollection<FINDING_CONTACT> FINDING_CONTACT { get; set; }
    }
}
