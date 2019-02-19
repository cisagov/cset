using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NEW_QUESTION_SETS
    {
        public NEW_QUESTION_SETS()
        {
            NEW_QUESTION_LEVELS = new HashSet<NEW_QUESTION_LEVELS>();
        }

        public string Set_Name { get; set; }
        public int Question_Id { get; set; }
        public int New_Question_Set_Id { get; set; }

        public virtual NEW_QUESTION Question_ { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
        public virtual ICollection<NEW_QUESTION_LEVELS> NEW_QUESTION_LEVELS { get; set; }
    }
}
