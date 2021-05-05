using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class RECOMMENDATIONS_REFERENCES
    {
        public int Data_Id { get; set; }
        public int Reference_Id { get; set; }

        [ForeignKey("Data_Id")]
        [InverseProperty("RECOMMENDATIONS_REFERENCES")]
        public virtual CATALOG_RECOMMENDATIONS_DATA Data_ { get; set; }
        [ForeignKey("Reference_Id")]
        [InverseProperty("RECOMMENDATIONS_REFERENCES")]
        public virtual REFERENCES_DATA Reference_ { get; set; }
    }
}