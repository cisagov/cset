using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class NIST_SAL_QUESTIONS
    {
        public NIST_SAL_QUESTIONS()
        {
            NIST_SAL_QUESTION_ANSWERS = new HashSet<NIST_SAL_QUESTION_ANSWERS>();
        }

        public int Question_Id { get; set; }
        public int Question_Number { get; set; }
        [StringLength(7000)]
        public string Question_Text { get; set; }

        [InverseProperty("Question_")]
        public virtual ICollection<NIST_SAL_QUESTION_ANSWERS> NIST_SAL_QUESTION_ANSWERS { get; set; }
    }
}