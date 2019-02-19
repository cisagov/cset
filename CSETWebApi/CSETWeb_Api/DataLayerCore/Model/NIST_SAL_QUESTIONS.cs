using System;
using System.Collections.Generic;

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
        public string Question_Text { get; set; }

        public virtual ICollection<NIST_SAL_QUESTION_ANSWERS> NIST_SAL_QUESTION_ANSWERS { get; set; }
    }
}
