using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class SETS_CATEGORY
    {
        public SETS_CATEGORY()
        {
            SETS = new HashSet<SETS>();
        }

        public int Set_Category_Id { get; set; }
        [StringLength(250)]
        public string Set_Category_Name { get; set; }

        [InverseProperty("Set_Category_")]
        public virtual ICollection<SETS> SETS { get; set; }
    }
}