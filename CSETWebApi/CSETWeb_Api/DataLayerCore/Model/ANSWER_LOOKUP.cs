using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ANSWER_LOOKUP
    {
        public ANSWER_LOOKUP()
        {
            ANSWER = new HashSet<ANSWER>();
            SUB_CATEGORY_ANSWERS = new HashSet<SUB_CATEGORY_ANSWERS>();
        }

        [StringLength(50)]
        public string Answer_Text { get; set; }
        [Required]
        [StringLength(50)]
        public string Answer_Full_Name { get; set; }

        [InverseProperty("Answer_TextNavigation")]
        public virtual ICollection<ANSWER> ANSWER { get; set; }
        [InverseProperty("Answer_TextNavigation")]
        public virtual ICollection<SUB_CATEGORY_ANSWERS> SUB_CATEGORY_ANSWERS { get; set; }
    }
}
