using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NEW_REQUIREMENT
    {
        public NEW_REQUIREMENT()
        {
            COMPONENT_STANDARD_QUESTIONS = new HashSet<COMPONENT_STANDARD_QUESTIONS>();
            NERC_RISK_RANKING = new HashSet<NERC_RISK_RANKING>();
            PARAMETER_REQUIREMENTS = new HashSet<PARAMETER_REQUIREMENTS>();
            REQUIREMENT_LEVELS = new HashSet<REQUIREMENT_LEVELS>();
            REQUIREMENT_QUESTIONS = new HashSet<REQUIREMENT_QUESTIONS>();
            REQUIREMENT_QUESTIONS_SETS = new HashSet<REQUIREMENT_QUESTIONS_SETS>();
            REQUIREMENT_REFERENCES = new HashSet<REQUIREMENT_REFERENCES>();
            REQUIREMENT_SETS = new HashSet<REQUIREMENT_SETS>();
            REQUIREMENT_SOURCE_FILES = new HashSet<REQUIREMENT_SOURCE_FILES>();
        }

        public int Requirement_Id { get; set; }
        public string Requirement_Title { get; set; }
        public string Requirement_Text { get; set; }
        public string Supplemental_Info { get; set; }
        public string Standard_Category { get; set; }
        public string Standard_Sub_Category { get; set; }
        public int? Weight { get; set; }
        public string Implementation_Recommendations { get; set; }
        public string Original_Set_Name { get; set; }
        public byte[] Text_Hash { get; set; }
        public int? NCSF_Cat_Id { get; set; }
        public int? NCSF_Number { get; set; }
        public byte[] Supp_Hash { get; set; }
        public int? Ranking { get; set; }
        public int Question_Group_Heading_Id { get; set; }

        public virtual NCSF_CATEGORY NCSF_Cat_ { get; set; }
        public virtual SETS Original_Set_NameNavigation { get; set; }
        public virtual QUESTION_GROUP_HEADING Question_Group_Heading_ { get; set; }
        public virtual STANDARD_CATEGORY Standard_CategoryNavigation { get; set; }
        public virtual ICollection<COMPONENT_STANDARD_QUESTIONS> COMPONENT_STANDARD_QUESTIONS { get; set; }
        public virtual ICollection<NERC_RISK_RANKING> NERC_RISK_RANKING { get; set; }
        public virtual ICollection<PARAMETER_REQUIREMENTS> PARAMETER_REQUIREMENTS { get; set; }
        public virtual ICollection<REQUIREMENT_LEVELS> REQUIREMENT_LEVELS { get; set; }
        public virtual ICollection<REQUIREMENT_QUESTIONS> REQUIREMENT_QUESTIONS { get; set; }
        public virtual ICollection<REQUIREMENT_QUESTIONS_SETS> REQUIREMENT_QUESTIONS_SETS { get; set; }
        public virtual ICollection<REQUIREMENT_REFERENCES> REQUIREMENT_REFERENCES { get; set; }
        public virtual ICollection<REQUIREMENT_SETS> REQUIREMENT_SETS { get; set; }
        public virtual ICollection<REQUIREMENT_SOURCE_FILES> REQUIREMENT_SOURCE_FILES { get; set; }
    }
}
