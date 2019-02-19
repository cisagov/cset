using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FINDING_CONTACT
    {
        public int Finding_Id { get; set; }
        public int Assessment_Contact_Id { get; set; }
        public int? IgnoreThis { get; set; }
        public Guid? Id { get; set; }

        public virtual ASSESSMENT_CONTACTS Assessment_Contact_ { get; set; }
        public virtual FINDING Finding_ { get; set; }
    }
}
