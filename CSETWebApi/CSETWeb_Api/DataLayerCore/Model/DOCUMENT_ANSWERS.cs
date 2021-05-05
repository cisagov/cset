using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class DOCUMENT_ANSWERS
    {
        public int Document_Id { get; set; }
        public int Answer_Id { get; set; }

        [ForeignKey("Answer_Id")]
        [InverseProperty("DOCUMENT_ANSWERS")]
        public virtual ANSWER Answer_ { get; set; }
        [ForeignKey("Document_Id")]
        [InverseProperty("DOCUMENT_ANSWERS")]
        public virtual DOCUMENT_FILE Document_ { get; set; }
    }
}