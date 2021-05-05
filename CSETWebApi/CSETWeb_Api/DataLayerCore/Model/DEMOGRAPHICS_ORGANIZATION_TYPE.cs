using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class DEMOGRAPHICS_ORGANIZATION_TYPE
    {

        public DEMOGRAPHICS_ORGANIZATION_TYPE()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        [Key]
        public int OrganizationTypeId { get; set; }
        [Required]
        [StringLength(50)]
        public string OrganizationType { get; set; }

        [InverseProperty("OrganizationTypeNavigation")]
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}