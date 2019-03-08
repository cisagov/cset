using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_SYMBOLS_GM_TO_CSET
    {
        [Key]
        [StringLength(200)]
        public string GM_FingerType { get; set; }
        public int Id { get; set; }

        [ForeignKey("Id")]
        [InverseProperty("COMPONENT_SYMBOLS_GM_TO_CSET")]
        public virtual COMPONENT_SYMBOLS IdNavigation { get; set; }
    }
}