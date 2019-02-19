using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REPORT_OPTIONS
    {
        public REPORT_OPTIONS()
        {
            REPORT_OPTIONS_SELECTION = new HashSet<REPORT_OPTIONS_SELECTION>();
        }

        public int Report_Option_Id { get; set; }
        public string Display_Name { get; set; }

        public virtual ICollection<REPORT_OPTIONS_SELECTION> REPORT_OPTIONS_SELECTION { get; set; }
    }
}
