using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class COMBINED_DOCUMENT_ANSWERS
    {
        public int Document_Id { get; set; }
        public int AnswerID { get; set; }

        [ForeignKey("AnswerID")]
        [InverseProperty("COMBINED_DOCUMENT_ANSWERS")]
        public virtual COMBINED_ANSWER Answer { get; set; }

        [ForeignKey("Document_Id")]
        [InverseProperty("COMBINED_DOCUMENT_ANSWERS")]
        public virtual DOCUMENT_FILE Document_ { get; set; }
    }
}