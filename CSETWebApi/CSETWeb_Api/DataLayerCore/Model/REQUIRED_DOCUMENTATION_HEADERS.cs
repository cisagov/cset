using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REQUIRED_DOCUMENTATION_HEADERS
    {
        public REQUIRED_DOCUMENTATION_HEADERS()
        {
            REQUIRED_DOCUMENTATION = new HashSet<REQUIRED_DOCUMENTATION>();
        }

        [Key]
        public int RDH_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Requirement_Documentation_Header { get; set; }
        public int? Header_Order { get; set; }

        [InverseProperty("RDH_")]
        public virtual ICollection<REQUIRED_DOCUMENTATION> REQUIRED_DOCUMENTATION { get; set; }
    }
}