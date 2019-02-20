using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class STANDARD_SOURCE_FILE
    {
        [StringLength(50)]
        public string Set_Name { get; set; }
        [StringLength(40)]
        public string Doc_Num { get; set; }

        [ForeignKey("Doc_Num")]
        [InverseProperty("STANDARD_SOURCE_FILE")]
        public virtual FILE_REF_KEYS Doc_NumNavigation { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("STANDARD_SOURCE_FILE")]
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
