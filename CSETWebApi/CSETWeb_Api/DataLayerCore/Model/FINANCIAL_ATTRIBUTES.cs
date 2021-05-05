using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FINANCIAL_ATTRIBUTES
    {
        public FINANCIAL_ATTRIBUTES()
        {
            FINANCIAL_ASSESSMENT_VALUES = new HashSet<FINANCIAL_ASSESSMENT_VALUES>();
        }

        [Key]
        [StringLength(250)]
        public string AttributeName { get; set; }

        [InverseProperty("AttributeNameNavigation")]
        public virtual ICollection<FINANCIAL_ASSESSMENT_VALUES> FINANCIAL_ASSESSMENT_VALUES { get; set; }
    }
}