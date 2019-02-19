using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_QUESTIONS
    {
        public int Question_Id { get; set; }
        public string Component_Type { get; set; }
        public int Weight { get; set; }
        public int Rank { get; set; }
        public string Seq { get; set; }

        public virtual COMPONENT_SYMBOLS Component_TypeNavigation { get; set; }
        public virtual NEW_QUESTION Question_ { get; set; }
    }
}
