using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class IRP_HEADER
    {
        public IRP_HEADER()
        {
            ASSESSMENT_IRP_HEADER = new HashSet<ASSESSMENT_IRP_HEADER>();
            IRP = new HashSet<IRP>();
        }

        [Key]
        public int IRP_Header_Id { get; set; }
        [StringLength(200)]
        public string Header { get; set; }

        [InverseProperty("IRP_HEADER_")]
        public virtual ICollection<ASSESSMENT_IRP_HEADER> ASSESSMENT_IRP_HEADER { get; set; }
        [InverseProperty("Header_")]
        public virtual ICollection<IRP> IRP { get; set; }
    }
}