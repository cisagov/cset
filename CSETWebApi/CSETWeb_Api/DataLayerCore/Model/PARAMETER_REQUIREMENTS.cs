using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PARAMETER_REQUIREMENTS
    {
        public int Requirement_Id { get; set; }
        public int Parameter_Id { get; set; }
        public int? ID { get; set; }

        [ForeignKey("Parameter_Id")]
        [InverseProperty("PARAMETER_REQUIREMENTS")]
        public virtual PARAMETERS Parameter_ { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("PARAMETER_REQUIREMENTS")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}