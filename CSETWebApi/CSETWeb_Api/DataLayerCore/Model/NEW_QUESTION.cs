using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NEW_QUESTION
    {
        public NEW_QUESTION()
        {
            COMPONENT_QUESTIONS = new HashSet<COMPONENT_QUESTIONS>();
            COMPONENT_STANDARD_QUESTIONS = new HashSet<COMPONENT_STANDARD_QUESTIONS>();
            NERC_RISK_RANKING = new HashSet<NERC_RISK_RANKING>();
            NEW_QUESTION_SETS = new HashSet<NEW_QUESTION_SETS>();
            QUESTION_SUB_QUESTION = new HashSet<QUESTION_SUB_QUESTION>();
            REQUIREMENT_QUESTIONS = new HashSet<REQUIREMENT_QUESTIONS>();
            REQUIREMENT_QUESTIONS_SETS = new HashSet<REQUIREMENT_QUESTIONS_SETS>();
        }

        public int Question_Id { get; set; }
        public string Std_Ref { get; set; }
        public int Std_Ref_Number { get; set; }
        public string Simple_Question { get; set; }
        public string Universal_Sal_Level { get; set; }
        public int? Weight { get; set; }
        public int? Question_Group_Id { get; set; }
        public int? Question_Group_Number { get; set; }
        public string Original_Set_Name { get; set; }
        public byte[] Question_Hash { get; set; }
        public int? Ranking { get; set; }
        public int Heading_Pair_Id { get; set; }
        public string Std_Ref_Id { get; set; }

        public virtual UNIVERSAL_SUB_CATEGORY_HEADINGS Heading_Pair_ { get; set; }
        public virtual SETS Original_Set_NameNavigation { get; set; }
        public virtual ICollection<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
        public virtual ICollection<COMPONENT_STANDARD_QUESTIONS> COMPONENT_STANDARD_QUESTIONS { get; set; }
        public virtual ICollection<NERC_RISK_RANKING> NERC_RISK_RANKING { get; set; }
        public virtual ICollection<NEW_QUESTION_SETS> NEW_QUESTION_SETS { get; set; }
        public virtual ICollection<QUESTION_SUB_QUESTION> QUESTION_SUB_QUESTION { get; set; }
        public virtual ICollection<REQUIREMENT_QUESTIONS> REQUIREMENT_QUESTIONS { get; set; }
        public virtual ICollection<REQUIREMENT_QUESTIONS_SETS> REQUIREMENT_QUESTIONS_SETS { get; set; }
    }
}
