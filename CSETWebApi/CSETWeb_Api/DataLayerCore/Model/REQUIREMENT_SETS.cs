using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_SETS
    {
        public int Requirement_Id { get; set; }
        public string Set_Name { get; set; }
        public int Requirement_Sequence { get; set; }

        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
