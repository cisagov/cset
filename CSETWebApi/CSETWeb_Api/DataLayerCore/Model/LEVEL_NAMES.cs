using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class LEVEL_NAMES
    {
        public LEVEL_NAMES()
        {
            ASSESSMENT_SELECTED_LEVELS = new HashSet<ASSESSMENT_SELECTED_LEVELS>();
        }

        [StringLength(50)]
        public string Level_Name { get; set; }

        [InverseProperty("Level_NameNavigation")]
        public virtual ICollection<ASSESSMENT_SELECTED_LEVELS> ASSESSMENT_SELECTED_LEVELS { get; set; }
    }
}
