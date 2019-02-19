using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_QUESTIONS
    {
        public int Question_Id { get; set; }
        public int Requirement_Id { get; set; }

        public virtual NEW_QUESTION Question_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
