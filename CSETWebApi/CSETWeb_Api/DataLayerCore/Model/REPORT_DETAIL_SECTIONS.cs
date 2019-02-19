using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REPORT_DETAIL_SECTIONS
    {
        public REPORT_DETAIL_SECTIONS()
        {
            REPORT_DETAIL_SECTION_SELECTION = new HashSet<REPORT_DETAIL_SECTION_SELECTION>();
        }

        public int Report_Section_Id { get; set; }
        public string Display_Name { get; set; }
        public int Display_Order { get; set; }
        public int Report_Order { get; set; }
        public string Tool_Tip { get; set; }

        public virtual ICollection<REPORT_DETAIL_SECTION_SELECTION> REPORT_DETAIL_SECTION_SELECTION { get; set; }
    }
}
