using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ANSWER_LOOKUP
    {
        public ANSWER_LOOKUP()
        {
            ANSWER = new HashSet<ANSWER>();
            SUB_CATEGORY_ANSWERS = new HashSet<SUB_CATEGORY_ANSWERS>();
        }

        public string Answer_Text { get; set; }
        public string Answer_Full_Name { get; set; }

        public virtual ICollection<ANSWER> ANSWER { get; set; }
        public virtual ICollection<SUB_CATEGORY_ANSWERS> SUB_CATEGORY_ANSWERS { get; set; }
    }
}
