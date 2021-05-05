using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COMBINED_CATEGORY
    {
        [Key]
        public int CombinedCategoryId { get; set; }
        [Required]
        [StringLength(100)]
        public string CategoryName { get; set; }
        public int Type_Question { get; set; }
        [StringLength(100)]
        public string Component_Type { get; set; }
        [StringLength(50)]
        public string Component_Guid { get; set; }
        public bool Is_Resolved { get; set; }
    }
}