using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class USERS
    {
        public USERS()
        {
            ASSESSMENTS = new HashSet<ASSESSMENTS>();
            ASSESSMENT_CONTACTS = new HashSet<ASSESSMENT_CONTACTS>();
        }

        public string PrimaryEmail { get; set; }
        public int UserId { get; set; }
        public string Password { get; set; }
        public string Salt { get; set; }
        public bool IsSuperUser { get; set; }
        public bool? PasswordResetRequired { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Guid? Id { get; set; }

        public virtual USER_DETAIL_INFORMATION IdNavigation { get; set; }
        public virtual USER_SECURITY_QUESTIONS USER_SECURITY_QUESTIONS { get; set; }
        public virtual ICollection<ASSESSMENTS> ASSESSMENTS { get; set; }
        public virtual ICollection<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
    }
}
