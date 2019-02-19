using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_STANDARD_QUESTIONS
    {
        public int Question_Id { get; set; }
        public int Requirement_id { get; set; }
        public string Component_Type { get; set; }

        public virtual COMPONENT_SYMBOLS Component_TypeNavigation { get; set; }
        public virtual NEW_QUESTION Question_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
