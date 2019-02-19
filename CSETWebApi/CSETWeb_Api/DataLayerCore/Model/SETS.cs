using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SETS
    {
        public SETS()
        {
            AVAILABLE_STANDARDS = new HashSet<AVAILABLE_STANDARDS>();
            CUSTOM_STANDARD_BASE_STANDARDBase_StandardNavigation = new HashSet<CUSTOM_STANDARD_BASE_STANDARD>();
            CUSTOM_STANDARD_BASE_STANDARDCustom_Questionaire_NameNavigation = new HashSet<CUSTOM_STANDARD_BASE_STANDARD>();
            NEW_QUESTION = new HashSet<NEW_QUESTION>();
            NEW_QUESTION_SETS = new HashSet<NEW_QUESTION_SETS>();
            NEW_REQUIREMENT = new HashSet<NEW_REQUIREMENT>();
            REPORT_STANDARDS_SELECTION = new HashSet<REPORT_STANDARDS_SELECTION>();
            REQUIREMENT_QUESTIONS_SETS = new HashSet<REQUIREMENT_QUESTIONS_SETS>();
            REQUIREMENT_SETS = new HashSet<REQUIREMENT_SETS>();
            SECTOR_STANDARD_RECOMMENDATIONS = new HashSet<SECTOR_STANDARD_RECOMMENDATIONS>();
            SET_FILES = new HashSet<SET_FILES>();
            STANDARD_CATEGORY_SEQUENCE = new HashSet<STANDARD_CATEGORY_SEQUENCE>();
            STANDARD_SOURCE_FILE = new HashSet<STANDARD_SOURCE_FILE>();
            UNIVERSAL_SUB_CATEGORY_HEADINGS = new HashSet<UNIVERSAL_SUB_CATEGORY_HEADINGS>();
        }

        public string Set_Name { get; set; }
        public string Full_Name { get; set; }
        public string Short_Name { get; set; }
        public bool? Is_Displayed { get; set; }
        public bool Is_Pass_Fail { get; set; }
        public string Old_Std_Name { get; set; }
        public int? Set_Category_Id { get; set; }
        public int? Order_In_Category { get; set; }
        public int? Report_Order_Section_Number { get; set; }
        public int? Aggregation_Standard_Number { get; set; }
        public bool Is_Question { get; set; }
        public bool Is_Requirement { get; set; }
        public int Order_Framework_Standards { get; set; }
        public string Standard_ToolTip { get; set; }
        public bool Is_Deprecated { get; set; }
        public string Upgrade_Set_Name { get; set; }
        public bool Is_Custom { get; set; }
        public DateTime? Date { get; set; }
        public bool IsEncryptedModule { get; set; }
        public bool? IsEncryptedModuleOpen { get; set; }

        public virtual SETS_CATEGORY Set_Category_ { get; set; }
        public virtual ICollection<AVAILABLE_STANDARDS> AVAILABLE_STANDARDS { get; set; }
        public virtual ICollection<CUSTOM_STANDARD_BASE_STANDARD> CUSTOM_STANDARD_BASE_STANDARDBase_StandardNavigation { get; set; }
        public virtual ICollection<CUSTOM_STANDARD_BASE_STANDARD> CUSTOM_STANDARD_BASE_STANDARDCustom_Questionaire_NameNavigation { get; set; }
        public virtual ICollection<NEW_QUESTION> NEW_QUESTION { get; set; }
        public virtual ICollection<NEW_QUESTION_SETS> NEW_QUESTION_SETS { get; set; }
        public virtual ICollection<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
        public virtual ICollection<REPORT_STANDARDS_SELECTION> REPORT_STANDARDS_SELECTION { get; set; }
        public virtual ICollection<REQUIREMENT_QUESTIONS_SETS> REQUIREMENT_QUESTIONS_SETS { get; set; }
        public virtual ICollection<REQUIREMENT_SETS> REQUIREMENT_SETS { get; set; }
        public virtual ICollection<SECTOR_STANDARD_RECOMMENDATIONS> SECTOR_STANDARD_RECOMMENDATIONS { get; set; }
        public virtual ICollection<SET_FILES> SET_FILES { get; set; }
        public virtual ICollection<STANDARD_CATEGORY_SEQUENCE> STANDARD_CATEGORY_SEQUENCE { get; set; }
        public virtual ICollection<STANDARD_SOURCE_FILE> STANDARD_SOURCE_FILE { get; set; }
        public virtual ICollection<UNIVERSAL_SUB_CATEGORY_HEADINGS> UNIVERSAL_SUB_CATEGORY_HEADINGS { get; set; }
    }
}
