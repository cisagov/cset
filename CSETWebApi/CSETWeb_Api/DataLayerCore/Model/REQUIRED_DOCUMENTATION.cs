using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REQUIRED_DOCUMENTATION
    {
        public REQUIRED_DOCUMENTATION()
        {
            ASSESSMENTS_REQUIRED_DOCUMENTATION = new HashSet<ASSESSMENTS_REQUIRED_DOCUMENTATION>();
        }

        [Key]
        public int Documentation_Id { get; set; }
        [StringLength(50)]
        public string Number { get; set; }
        [StringLength(4000)]
        public string Document_Description { get; set; }
        public int RDH_Id { get; set; }
        public int? Document_Order { get; set; }

        [ForeignKey("RDH_Id")]
        [InverseProperty("REQUIRED_DOCUMENTATION")]
        public virtual REQUIRED_DOCUMENTATION_HEADERS RDH_ { get; set; }
        [InverseProperty("Documentation_")]
        public virtual ICollection<ASSESSMENTS_REQUIRED_DOCUMENTATION> ASSESSMENTS_REQUIRED_DOCUMENTATION { get; set; }
    }
}