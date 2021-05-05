using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REPORT_STANDARDS_SELECTION
    {
        public int Assesment_Id { get; set; }
        [StringLength(50)]
        public string Report_Set_Entity_Name { get; set; }
        public int Report_Section_Order { get; set; }
        public bool Is_Selected { get; set; }

        [ForeignKey("Assesment_Id")]
        [InverseProperty("REPORT_STANDARDS_SELECTION")]
        public virtual ASSESSMENTS Assesment_ { get; set; }
        [ForeignKey("Report_Set_Entity_Name")]
        [InverseProperty("REPORT_STANDARDS_SELECTION")]
        public virtual SETS Report_Set_Entity_NameNavigation { get; set; }
    }
}