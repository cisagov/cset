using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class APP_CODE
    {
        public APP_CODE()
        {
            DEMOGRAPHICS_ASSET_VALUES = new HashSet<DEMOGRAPHICS_ASSET_VALUES>();
        }

        [Key]
        [StringLength(10)]
        public string AppCode { get; set; }
        [StringLength(50)]
        public string Description { get; set; }

        [InverseProperty("AppCodeNavigation")]
        public virtual ICollection<DEMOGRAPHICS_ASSET_VALUES> DEMOGRAPHICS_ASSET_VALUES { get; set; }
    }
}