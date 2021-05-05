using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class CUSTOM_QUESTIONAIRES
    {
        public CUSTOM_QUESTIONAIRES()
        {
            CUSTOM_BASE_STANDARDS = new HashSet<CUSTOM_BASE_STANDARDS>();
            CUSTOM_QUESTIONAIRE_QUESTIONS = new HashSet<CUSTOM_QUESTIONAIRE_QUESTIONS>();
        }

        [Key]
        [StringLength(50)]
        public string Custom_Questionaire_Name { get; set; }
        [StringLength(800)]
        public string Description { get; set; }
        [Required]
        [StringLength(50)]
        public string Set_Name { get; set; }

        [InverseProperty("Custom_Questionaire_NameNavigation")]
        public virtual ICollection<CUSTOM_BASE_STANDARDS> CUSTOM_BASE_STANDARDS { get; set; }
        [InverseProperty("Custom_Questionaire_NameNavigation")]
        public virtual ICollection<CUSTOM_QUESTIONAIRE_QUESTIONS> CUSTOM_QUESTIONAIRE_QUESTIONS { get; set; }
    }
}