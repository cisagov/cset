using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_LEVEL_TYPE
    {
        public REQUIREMENT_LEVEL_TYPE()
        {
            REQUIREMENT_LEVELS = new HashSet<REQUIREMENT_LEVELS>();
        }

        [Key]
        [StringLength(5)]
        public string Level_Type { get; set; }
        [StringLength(50)]
        public string Level_Type_Full_Name { get; set; }

        [InverseProperty("Level_TypeNavigation")]
        public virtual ICollection<REQUIREMENT_LEVELS> REQUIREMENT_LEVELS { get; set; }
    }
}
