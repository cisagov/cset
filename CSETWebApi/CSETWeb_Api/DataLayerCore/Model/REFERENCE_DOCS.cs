using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REFERENCE_DOCS
    {
        public REFERENCE_DOCS()
        {
            REFERENCES_DATA = new HashSet<REFERENCES_DATA>();
        }

        public int Reference_Doc_Id { get; set; }
        public string Doc_Name { get; set; }
        public string Doc_Link { get; set; }
        [StringLength(50)]
        public string Doc_Short { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? Date_Updated { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? Date_Last_Checked { get; set; }
        public string Doc_Url { get; set; }
        public string Doc_Notes { get; set; }

        [InverseProperty("Reference_Doc_")]
        public virtual ICollection<REFERENCES_DATA> REFERENCES_DATA { get; set; }
    }
}
