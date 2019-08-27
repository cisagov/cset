using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class NETWORK_WARNINGS
    {
        public int Assessment_Id { get; set; }
        public int Id { get; set; }
        [StringLength(1000)]
        public string WarningText { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("NETWORK_WARNINGS")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
    }
}