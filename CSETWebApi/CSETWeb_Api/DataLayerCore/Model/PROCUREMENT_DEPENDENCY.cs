using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class PROCUREMENT_DEPENDENCY
    {
        public int Procurement_Id { get; set; }
        public int Dependencies_Id { get; set; }

        [ForeignKey("Dependencies_Id")]
        [InverseProperty("PROCUREMENT_DEPENDENCYDependencies_")]
        public virtual PROCUREMENT_LANGUAGE_DATA Dependencies_ { get; set; }
        [ForeignKey("Procurement_Id")]
        [InverseProperty("PROCUREMENT_DEPENDENCYProcurement_")]
        public virtual PROCUREMENT_LANGUAGE_DATA Procurement_ { get; set; }
    }
}
