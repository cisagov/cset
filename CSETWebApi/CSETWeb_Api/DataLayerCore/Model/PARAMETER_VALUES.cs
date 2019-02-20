using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class PARAMETER_VALUES
    {
        public int Answer_Id { get; set; }
        public int Parameter_Id { get; set; }
        [Required]
        [StringLength(2000)]
        public string Parameter_Value { get; set; }
        public bool Parameter_Is_Default { get; set; }

        [ForeignKey("Answer_Id")]
        [InverseProperty("PARAMETER_VALUES")]
        public virtual ANSWER Answer_ { get; set; }
        [ForeignKey("Parameter_Id")]
        [InverseProperty("PARAMETER_VALUES")]
        public virtual PARAMETERS Parameter_ { get; set; }
    }
}
