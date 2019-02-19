using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_SELECTION
    {
        public STANDARD_SELECTION()
        {
            ASSESSMENT_SELECTED_LEVELS = new HashSet<ASSESSMENT_SELECTED_LEVELS>();
            NIST_SAL_INFO_TYPES = new HashSet<NIST_SAL_INFO_TYPES>();
            NIST_SAL_QUESTION_ANSWERS = new HashSet<NIST_SAL_QUESTION_ANSWERS>();
        }

        public int Assessment_Id { get; set; }
        public string Application_Mode { get; set; }
        public string Selected_Sal_Level { get; set; }
        public string Last_Sal_Determination_Type { get; set; }
        public string Sort_Set_Name { get; set; }
        public bool Is_Advanced { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual SAL_DETERMINATION_TYPES Last_Sal_Determination_TypeNavigation { get; set; }
        public virtual UNIVERSAL_SAL_LEVEL Selected_Sal_LevelNavigation { get; set; }
        public virtual ICollection<ASSESSMENT_SELECTED_LEVELS> ASSESSMENT_SELECTED_LEVELS { get; set; }
        public virtual ICollection<NIST_SAL_INFO_TYPES> NIST_SAL_INFO_TYPES { get; set; }
        public virtual ICollection<NIST_SAL_QUESTION_ANSWERS> NIST_SAL_QUESTION_ANSWERS { get; set; }
    }
}
