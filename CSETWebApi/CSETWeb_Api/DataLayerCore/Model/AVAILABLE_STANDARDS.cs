using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class AVAILABLE_STANDARDS
    {
        public int Assessment_Id { get; set; }
        public string Set_Name { get; set; }
        public bool Selected { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
