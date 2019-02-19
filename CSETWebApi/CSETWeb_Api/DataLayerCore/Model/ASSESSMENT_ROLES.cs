using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_ROLES
    {
        public ASSESSMENT_ROLES()
        {
            ASSESSMENT_CONTACTS = new HashSet<ASSESSMENT_CONTACTS>();
        }

        public int AssessmentRoleId { get; set; }
        public string AssessmentRole { get; set; }

        public virtual ICollection<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
    }
}
