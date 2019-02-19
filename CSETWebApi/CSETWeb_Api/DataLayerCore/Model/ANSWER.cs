using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ANSWER
    {
        public ANSWER()
        {
            DOCUMENT_ANSWERS = new HashSet<DOCUMENT_ANSWERS>();
            FINDING = new HashSet<FINDING>();
            PARAMETER_VALUES = new HashSet<PARAMETER_VALUES>();
        }

        public int Assessment_Id { get; set; }
        public int Answer_Id { get; set; }
        public bool Is_Requirement { get; set; }
        public int Question_Or_Requirement_Id { get; set; }
        public int Component_Id { get; set; }
        public bool? Mark_For_Review { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public int? Question_Number { get; set; }
        public string Answer_Text { get; set; }
        public string Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        public string Custom_Question_Guid { get; set; }
        public bool Is_Framework { get; set; }
        public int? Old_Answer_Id { get; set; }

        public virtual ANSWER_LOOKUP Answer_TextNavigation { get; set; }
        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual ICollection<DOCUMENT_ANSWERS> DOCUMENT_ANSWERS { get; set; }
        public virtual ICollection<FINDING> FINDING { get; set; }
        public virtual ICollection<PARAMETER_VALUES> PARAMETER_VALUES { get; set; }
    }
}
