using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class GENERAL_SAL
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string Sal_Name { get; set; }
        public int Slider_Value { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("GENERAL_SAL")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Sal_Name")]
        [InverseProperty("GENERAL_SAL")]
        public virtual GEN_SAL_NAMES Sal_NameNavigation { get; set; }
    }
}
