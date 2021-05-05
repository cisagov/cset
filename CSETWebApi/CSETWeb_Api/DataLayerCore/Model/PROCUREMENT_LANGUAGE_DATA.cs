using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class PROCUREMENT_LANGUAGE_DATA
    {
        public PROCUREMENT_LANGUAGE_DATA()
        {
            PROCUREMENT_DEPENDENCYDependencies_ = new HashSet<PROCUREMENT_DEPENDENCY>();
            PROCUREMENT_DEPENDENCYProcurement_ = new HashSet<PROCUREMENT_DEPENDENCY>();
            PROCUREMENT_REFERENCES = new HashSet<PROCUREMENT_REFERENCES>();
        }

        public int Procurement_Id { get; set; }
        public int? Parent_Heading_Id { get; set; }
        [StringLength(50)]
        public string Section_Number { get; set; }
        public string Topic_Name { get; set; }
        public string Heading { get; set; }
        public string Basis { get; set; }
        public string Language_Guidance { get; set; }
        public string Procurement_Language { get; set; }
        public string Fatmeasures { get; set; }
        public string Satmeasures { get; set; }
        public string Maintenance_Guidance { get; set; }
        public string References_Doc { get; set; }
        public string Flow_Document { get; set; }

        [ForeignKey("Parent_Heading_Id")]
        [InverseProperty("PROCUREMENT_LANGUAGE_DATA")]
        public virtual PROCUREMENT_LANGUAGE_HEADINGS Parent_Heading_ { get; set; }
        [InverseProperty("Dependencies_")]
        public virtual ICollection<PROCUREMENT_DEPENDENCY> PROCUREMENT_DEPENDENCYDependencies_ { get; set; }
        [InverseProperty("Procurement_")]
        public virtual ICollection<PROCUREMENT_DEPENDENCY> PROCUREMENT_DEPENDENCYProcurement_ { get; set; }
        [InverseProperty("Procurement_")]
        public virtual ICollection<PROCUREMENT_REFERENCES> PROCUREMENT_REFERENCES { get; set; }
    }
}