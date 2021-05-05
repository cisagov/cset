using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class IMPORTANCE
    {
        public IMPORTANCE()
        {
            FINDING = new HashSet<FINDING>();
        }

        public int Importance_Id { get; set; }
        [StringLength(50)]
        public string Value { get; set; }

        [InverseProperty("Importance_")]
        public virtual ICollection<FINDING> FINDING { get; set; }
    }
}