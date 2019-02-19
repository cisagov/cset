using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SUB_CATEGORY_ANSWERS
    {
        public int Assessement_Id { get; set; }
        public int Heading_Pair_Id { get; set; }
        public int Component_Id { get; set; }
        public bool Is_Component { get; set; }
        public bool Is_Override { get; set; }
        public string Answer_Text { get; set; }

        public virtual ANSWER_LOOKUP Answer_TextNavigation { get; set; }
        public virtual ASSESSMENTS Assessement_ { get; set; }
        public virtual UNIVERSAL_SUB_CATEGORY_HEADINGS Heading_Pair_ { get; set; }
    }
}
