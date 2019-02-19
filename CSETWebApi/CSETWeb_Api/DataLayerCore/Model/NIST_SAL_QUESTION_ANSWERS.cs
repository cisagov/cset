using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NIST_SAL_QUESTION_ANSWERS
    {
        public int Assessment_Id { get; set; }
        public int Question_Id { get; set; }
        public string Question_Answer { get; set; }

        public virtual STANDARD_SELECTION Assessment_ { get; set; }
        public virtual NIST_SAL_QUESTIONS Question_ { get; set; }
    }
}
