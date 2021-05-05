using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class QUESTION_SUB_QUESTION
    {
        public int Question_Id { get; set; }
        public int Sub_Question_Id { get; set; }
        public int Question_Group_Id { get; set; }
        public int List_Order { get; set; }

        [ForeignKey("Question_Id")]
        [InverseProperty("QUESTION_SUB_QUESTION")]
        public virtual NEW_QUESTION Question_ { get; set; }
    }
}