using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class STANDARD_SELECTION
    {
        public STANDARD_SELECTION()
        {
            ASSESSMENT_SELECTED_LEVELS = new HashSet<ASSESSMENT_SELECTED_LEVELS>();
            NIST_SAL_INFO_TYPES = new HashSet<NIST_SAL_INFO_TYPES>();
            NIST_SAL_QUESTION_ANSWERS = new HashSet<NIST_SAL_QUESTION_ANSWERS>();
        }

        [Key]
        public int Assessment_Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Application_Mode { get; set; }
        [Required]
        [StringLength(10)]
        public string Selected_Sal_Level { get; set; }
        [StringLength(50)]
        public string Last_Sal_Determination_Type { get; set; }
        [StringLength(50)]
        public string Sort_Set_Name { get; set; }
        public bool Is_Advanced { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("STANDARD_SELECTION")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Last_Sal_Determination_Type")]
        [InverseProperty("STANDARD_SELECTION")]
        public virtual SAL_DETERMINATION_TYPES Last_Sal_Determination_TypeNavigation { get; set; }
        public virtual UNIVERSAL_SAL_LEVEL Selected_Sal_LevelNavigation { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ASSESSMENT_SELECTED_LEVELS> ASSESSMENT_SELECTED_LEVELS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<NIST_SAL_INFO_TYPES> NIST_SAL_INFO_TYPES { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<NIST_SAL_QUESTION_ANSWERS> NIST_SAL_QUESTION_ANSWERS { get; set; }
    }
}
