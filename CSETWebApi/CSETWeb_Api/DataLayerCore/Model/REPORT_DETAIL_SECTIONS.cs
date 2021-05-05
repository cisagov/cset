using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REPORT_DETAIL_SECTIONS
    {
        public REPORT_DETAIL_SECTIONS()
        {
            REPORT_DETAIL_SECTION_SELECTION = new HashSet<REPORT_DETAIL_SECTION_SELECTION>();
        }

        [Key]
        public int Report_Section_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string Display_Name { get; set; }
        public int Display_Order { get; set; }
        public int Report_Order { get; set; }
        [StringLength(500)]
        public string Tool_Tip { get; set; }

        [InverseProperty("Report_Section_")]
        public virtual ICollection<REPORT_DETAIL_SECTION_SELECTION> REPORT_DETAIL_SECTION_SELECTION { get; set; }
    }
}