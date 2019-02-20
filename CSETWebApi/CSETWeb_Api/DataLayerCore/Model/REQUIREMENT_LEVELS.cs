using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_LEVELS
    {
        public int Requirement_Id { get; set; }
        [StringLength(50)]
        public string Standard_Level { get; set; }
        [StringLength(5)]
        public string Level_Type { get; set; }
        public int? Id { get; set; }

        [ForeignKey("Level_Type")]
        [InverseProperty("REQUIREMENT_LEVELS")]
        public virtual REQUIREMENT_LEVEL_TYPE Level_TypeNavigation { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("REQUIREMENT_LEVELS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        [ForeignKey("Standard_Level")]
        [InverseProperty("REQUIREMENT_LEVELS")]
        public virtual STANDARD_SPECIFIC_LEVEL Standard_LevelNavigation { get; set; }
    }
}
