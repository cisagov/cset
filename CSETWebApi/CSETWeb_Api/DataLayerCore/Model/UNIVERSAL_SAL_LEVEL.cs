using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class UNIVERSAL_SAL_LEVEL
    {
        public UNIVERSAL_SAL_LEVEL()
        {
            NEW_QUESTION = new HashSet<NEW_QUESTION>();
            NEW_QUESTION_LEVELS = new HashSet<NEW_QUESTION_LEVELS>();
            STANDARD_SELECTION = new HashSet<STANDARD_SELECTION>();
            STANDARD_TO_UNIVERSAL_MAP = new HashSet<STANDARD_TO_UNIVERSAL_MAP>();
        }

        [Key]
        [Column("Universal_Sal_Level")]
        [StringLength(10)]
        public string Universal_Sal_Level1 { get; set; }
        public int Sal_Level_Order { get; set; }
        [Required]
        [StringLength(10)]
        public string Full_Name_Sal { get; set; }

        [InverseProperty("Universal_Sal_LevelNavigation")]
        public virtual ICollection<NEW_QUESTION> NEW_QUESTION { get; set; }
        [InverseProperty("Universal_Sal_LevelNavigation")]
        public virtual ICollection<NEW_QUESTION_LEVELS> NEW_QUESTION_LEVELS { get; set; }
        public virtual ICollection<STANDARD_SELECTION> STANDARD_SELECTION { get; set; }
        [InverseProperty("Universal_Sal_LevelNavigation")]
        public virtual ICollection<STANDARD_TO_UNIVERSAL_MAP> STANDARD_TO_UNIVERSAL_MAP { get; set; }
    }
}