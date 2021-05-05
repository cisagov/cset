using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REQUIREMENT_SETS
    {
        public int Requirement_Id { get; set; }
        [StringLength(50)]
        public string Set_Name { get; set; }
        public int Requirement_Sequence { get; set; }

        [ForeignKey("Requirement_Id")]
        [InverseProperty("REQUIREMENT_SETS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("REQUIREMENT_SETS")]
        public virtual SETS Set_NameNavigation { get; set; }
    }
}