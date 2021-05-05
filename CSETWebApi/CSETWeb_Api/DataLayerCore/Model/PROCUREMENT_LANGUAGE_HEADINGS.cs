using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PROCUREMENT_LANGUAGE_HEADINGS
    {
        public PROCUREMENT_LANGUAGE_HEADINGS()
        {
            PROCUREMENT_LANGUAGE_DATA = new HashSet<PROCUREMENT_LANGUAGE_DATA>();
        }

        public int Id { get; set; }
        public int? Heading_Num { get; set; }
        [Required]
        [StringLength(200)]
        public string Heading_Name { get; set; }

        [InverseProperty("Parent_Heading_")]
        public virtual ICollection<PROCUREMENT_LANGUAGE_DATA> PROCUREMENT_LANGUAGE_DATA { get; set; }
    }
}