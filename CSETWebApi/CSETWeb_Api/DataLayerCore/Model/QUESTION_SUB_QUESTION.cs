using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class QUESTION_SUB_QUESTION
    {
        public int Question_Id { get; set; }
        public int Sub_Question_Id { get; set; }
        public int Question_Group_Id { get; set; }
        public int List_Order { get; set; }

        public virtual NEW_QUESTION Question_ { get; set; }
    }
}
