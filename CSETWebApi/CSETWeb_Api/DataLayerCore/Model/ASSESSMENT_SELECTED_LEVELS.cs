using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class ASSESSMENT_SELECTED_LEVELS
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public string Level_Name { get; set; }
        [Required]
        [StringLength(50)]
        public string Standard_Specific_Sal_Level { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("ASSESSMENT_SELECTED_LEVELS")]
        public virtual STANDARD_SELECTION Assessment_ { get; set; }
        [ForeignKey("Level_Name")]
        [InverseProperty("ASSESSMENT_SELECTED_LEVELS")]
        public virtual LEVEL_NAMES Level_NameNavigation { get; set; }
    }
}