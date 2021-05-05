using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REFERENCES_DATA
    {
        public REFERENCES_DATA()
        {
            PROCUREMENT_REFERENCES = new HashSet<PROCUREMENT_REFERENCES>();
            RECOMMENDATIONS_REFERENCES = new HashSet<RECOMMENDATIONS_REFERENCES>();
        }

        public int Reference_Id { get; set; }
        public int? Reference_Doc_Id { get; set; }
        public string Reference_Sections { get; set; }

        [ForeignKey("Reference_Doc_Id")]
        [InverseProperty("REFERENCES_DATA")]
        public virtual REFERENCE_DOCS Reference_Doc_ { get; set; }
        [InverseProperty("Reference_")]
        public virtual ICollection<PROCUREMENT_REFERENCES> PROCUREMENT_REFERENCES { get; set; }
        [InverseProperty("Reference_")]
        public virtual ICollection<RECOMMENDATIONS_REFERENCES> RECOMMENDATIONS_REFERENCES { get; set; }
    }
}