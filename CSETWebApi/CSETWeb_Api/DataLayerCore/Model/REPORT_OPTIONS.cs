using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REPORT_OPTIONS
    {
        public REPORT_OPTIONS()
        {
            REPORT_OPTIONS_SELECTION = new HashSet<REPORT_OPTIONS_SELECTION>();
        }

        [Key]
        public int Report_Option_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Display_Name { get; set; }

        [InverseProperty("Report_Option_")]
        public virtual ICollection<REPORT_OPTIONS_SELECTION> REPORT_OPTIONS_SELECTION { get; set; }
    }
}
