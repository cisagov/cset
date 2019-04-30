using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class NEW_QUESTION_SETS
    {
        public NEW_QUESTION_SETS()
        {
            NEW_QUESTION_LEVELS = new HashSet<NEW_QUESTION_LEVELS>();
        }

        [Required]
        [StringLength(50)]
        public string Set_Name { get; set; }
        public int Question_Id { get; set; }
        public int New_Question_Set_Id { get; set; }

        [ForeignKey("Question_Id")]
        [InverseProperty("NEW_QUESTION_SETS")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("Set_Name")]
        [InverseProperty("NEW_QUESTION_SETS")]
        public virtual SETS Set_NameNavigation { get; set; }
        [InverseProperty("New_Question_Set_")]
        public virtual ICollection<NEW_QUESTION_LEVELS> NEW_QUESTION_LEVELS { get; set; }
    }
}