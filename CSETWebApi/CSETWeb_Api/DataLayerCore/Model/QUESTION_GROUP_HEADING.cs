using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class QUESTION_GROUP_HEADING
    {
        public QUESTION_GROUP_HEADING()
        {
            NEW_REQUIREMENT = new HashSet<NEW_REQUIREMENT>();
            UNIVERSAL_SUB_CATEGORY_HEADINGS = new HashSet<UNIVERSAL_SUB_CATEGORY_HEADINGS>();
        }

        [Key]
        [Column("Question_Group_Heading")]
        [StringLength(250)]
        public string Question_Group_Heading1 { get; set; }
        [Required]
        [StringLength(10)]
        public string Std_Ref { get; set; }
        public int Universal_Weight { get; set; }
        public int Question_Group_Heading_Id { get; set; }

        public virtual ICollection<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
        public virtual ICollection<UNIVERSAL_SUB_CATEGORY_HEADINGS> UNIVERSAL_SUB_CATEGORY_HEADINGS { get; set; }
    }
}
