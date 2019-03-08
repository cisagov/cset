using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINDING_CONTACT
    {
        public int Finding_Id { get; set; }
        public int Assessment_Contact_Id { get; set; }
        public int? IgnoreThis { get; set; }
        public Guid? Id { get; set; }

        [ForeignKey("Assessment_Contact_Id")]
        [InverseProperty("FINDING_CONTACT")]
        public virtual ASSESSMENT_CONTACTS Assessment_Contact_ { get; set; }
        [ForeignKey("Finding_Id")]
        [InverseProperty("FINDING_CONTACT")]
        public virtual FINDING Finding_ { get; set; }
    }
}