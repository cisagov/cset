using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REPORT_STANDARDS_SELECTION
    {
        public int Assesment_Id { get; set; }
        public string Report_Set_Entity_Name { get; set; }
        public int Report_Section_Order { get; set; }
        public bool Is_Selected { get; set; }

        public virtual ASSESSMENTS Assesment_ { get; set; }
        public virtual SETS Report_Set_Entity_NameNavigation { get; set; }
    }
}
