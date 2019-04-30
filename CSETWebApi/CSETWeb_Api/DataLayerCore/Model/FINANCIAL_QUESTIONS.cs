using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FINANCIAL_QUESTIONS
    {
        public int StmtNumber { get; set; }
        public int Question_Id { get; set; }
        public int? Id { get; set; }

        [ForeignKey("Question_Id")]
        [InverseProperty("FINANCIAL_QUESTIONS")]
        public virtual NEW_QUESTION Question_ { get; set; }
        [ForeignKey("StmtNumber")]
        [InverseProperty("FINANCIAL_QUESTIONS")]
        public virtual FINANCIAL_DETAILS StmtNumberNavigation { get; set; }
    }
}