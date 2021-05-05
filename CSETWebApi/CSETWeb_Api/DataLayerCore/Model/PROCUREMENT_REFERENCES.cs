using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PROCUREMENT_REFERENCES
    {
        public int Procurement_Id { get; set; }
        public int Reference_Id { get; set; }

        [ForeignKey("Procurement_Id")]
        [InverseProperty("PROCUREMENT_REFERENCES")]
        public virtual PROCUREMENT_LANGUAGE_DATA Procurement_ { get; set; }
        [ForeignKey("Reference_Id")]
        [InverseProperty("PROCUREMENT_REFERENCES")]
        public virtual REFERENCES_DATA Reference_ { get; set; }
    }
}