using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FINANCIAL_ASSESSMENT_VALUES
    {
        public int Assessment_Id { get; set; }
        [StringLength(250)]
        public string AttributeName { get; set; }
        [StringLength(50)]
        public string AttributeValue { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("FINANCIAL_ASSESSMENT_VALUES")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("AttributeName")]
        [InverseProperty("FINANCIAL_ASSESSMENT_VALUES")]
        public virtual FINANCIAL_ATTRIBUTES AttributeNameNavigation { get; set; }
    }
}