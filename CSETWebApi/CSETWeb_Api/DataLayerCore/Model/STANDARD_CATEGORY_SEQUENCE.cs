using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class STANDARD_CATEGORY_SEQUENCE
    {
        [StringLength(250)]
        public string Standard_Category { get; set; }
        [StringLength(50)]
        public string Set_Name { get; set; }
        [Column("Standard_Category_Sequence")]
        public int Standard_Category_Sequence1 { get; set; }

        [ForeignKey("Set_Name")]
        [InverseProperty("STANDARD_CATEGORY_SEQUENCE")]
        public virtual SETS Set_NameNavigation { get; set; }
        [ForeignKey("Standard_Category")]
        [InverseProperty("STANDARD_CATEGORY_SEQUENCE")]
        public virtual STANDARD_CATEGORY Standard_CategoryNavigation { get; set; }
    }
}