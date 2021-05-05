using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FILE_REF_KEYS
    {
        public FILE_REF_KEYS()
        {
            GEN_FILE = new HashSet<GEN_FILE>();
            STANDARD_SOURCE_FILE = new HashSet<STANDARD_SOURCE_FILE>();
        }

        [Key]
        [StringLength(40)]
        public string Doc_Num { get; set; }

        [InverseProperty("Doc_NumNavigation")]
        public virtual ICollection<GEN_FILE> GEN_FILE { get; set; }
        [InverseProperty("Doc_NumNavigation")]
        public virtual ICollection<STANDARD_SOURCE_FILE> STANDARD_SOURCE_FILE { get; set; }
    }
}