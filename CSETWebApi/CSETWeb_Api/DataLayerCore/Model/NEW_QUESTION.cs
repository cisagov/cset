using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class NEW_QUESTION
    {
        public NEW_QUESTION()
        {
            COMPONENT_QUESTIONS = new HashSet<COMPONENT_QUESTIONS>();
            FINANCIAL_QUESTIONS = new HashSet<FINANCIAL_QUESTIONS>();
            NERC_RISK_RANKING = new HashSet<NERC_RISK_RANKING>();
            NEW_QUESTION_SETS = new HashSet<NEW_QUESTION_SETS>();
            REQUIREMENT_QUESTIONS = new HashSet<REQUIREMENT_QUESTIONS>();
            REQUIREMENT_QUESTIONS_SETS = new HashSet<REQUIREMENT_QUESTIONS_SETS>();
        }

        public int Question_Id { get; set; }
        [Required]
        [StringLength(55)]
        public string Std_Ref { get; set; }
        public int Std_Ref_Number { get; set; }
        [StringLength(7338)]
        public string Simple_Question { get; set; }
        [Required]
        [StringLength(10)]
        public string Universal_Sal_Level { get; set; }
        public int? Weight { get; set; }
        public int? Question_Group_Id { get; set; }
        public int? Question_Group_Number { get; set; }
        [Required]
        [StringLength(50)]
        public string Original_Set_Name { get; set; }
        [MaxLength(32)]
        public byte[] Question_Hash { get; set; }
        public int? Ranking { get; set; }
        public int Heading_Pair_Id { get; set; }
        [StringLength(106)]
        public string Std_Ref_Id { get; set; }

        public virtual UNIVERSAL_SUB_CATEGORY_HEADINGS Heading_Pair_ { get; set; }
        [ForeignKey("Original_Set_Name")]
        [InverseProperty("NEW_QUESTION")]
        public virtual SETS Original_Set_NameNavigation { get; set; }
        [ForeignKey("Universal_Sal_Level")]
        [InverseProperty("NEW_QUESTION")]
        public virtual UNIVERSAL_SAL_LEVEL Universal_Sal_LevelNavigation { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<FINANCIAL_QUESTIONS> FINANCIAL_QUESTIONS { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<NERC_RISK_RANKING> NERC_RISK_RANKING { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<NEW_QUESTION_SETS> NEW_QUESTION_SETS { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<REQUIREMENT_QUESTIONS> REQUIREMENT_QUESTIONS { get; set; }
        [InverseProperty("Question_")]
        public virtual ICollection<REQUIREMENT_QUESTIONS_SETS> REQUIREMENT_QUESTIONS_SETS { get; set; }
    }
}