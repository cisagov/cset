using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class IRP
    {
        public IRP()
        {
            ASSESSMENT_IRP = new HashSet<ASSESSMENT_IRP>();
        }

        [Key]
        public int IRP_ID { get; set; }
        public int? Item_Number { get; set; }
        [StringLength(1000)]
        public string Risk_1_Description { get; set; }
        [StringLength(1000)]
        public string Risk_2_Description { get; set; }
        [StringLength(1000)]
        public string Risk_3_Description { get; set; }
        [StringLength(1000)]
        public string Risk_4_Description { get; set; }
        [StringLength(1000)]
        public string Risk_5_Description { get; set; }
        [StringLength(1000)]
        public string Validation_Approach { get; set; }
        public int Header_Id { get; set; }
        [StringLength(1000)]
        public string Description { get; set; }
        [StringLength(1300)]
        public string DescriptionComment { get; set; }

        [ForeignKey("Header_Id")]
        [InverseProperty("IRP")]
        public virtual IRP_HEADER Header_ { get; set; }
        [InverseProperty("IRP_")]
        public virtual ICollection<ASSESSMENT_IRP> ASSESSMENT_IRP { get; set; }
    }
}