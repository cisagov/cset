using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DEMOGRAPHICS_SIZE
    {
        public DEMOGRAPHICS_SIZE()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int DemographicId { get; set; }
        [StringLength(50)]
        public string Size { get; set; }
        [StringLength(50)]
        public string Description { get; set; }
        public int? ValueOrder { get; set; }

        [InverseProperty("SizeNavigation")]
        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}
