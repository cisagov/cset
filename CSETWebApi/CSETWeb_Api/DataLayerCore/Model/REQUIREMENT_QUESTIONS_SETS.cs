using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_QUESTIONS_SETS
    {
        public int Question_Id { get; set; }
        public int Requirement_Id { get; set; }
        public string Set_Name { get; set; }

        public virtual NEW_QUESTION Question_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
