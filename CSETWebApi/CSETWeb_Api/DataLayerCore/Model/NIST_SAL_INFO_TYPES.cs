using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class NIST_SAL_INFO_TYPES
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string Type_Value { get; set; }
        public bool Selected { get; set; }
        [StringLength(50)]
        public string Confidentiality_Value { get; set; }
        [StringLength(1500)]
        public string Confidentiality_Special_Factor { get; set; }
        [StringLength(50)]
        public string Integrity_Value { get; set; }
        [StringLength(1500)]
        public string Integrity_Special_Factor { get; set; }
        [StringLength(50)]
        public string Availability_Value { get; set; }
        [StringLength(1500)]
        public string Availability_Special_Factor { get; set; }
        [StringLength(50)]
        public string Area { get; set; }
        [StringLength(50)]
        public string NIST_Number { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("NIST_SAL_INFO_TYPES")]
        public virtual STANDARD_SELECTION Assessment_ { get; set; }
    }
}