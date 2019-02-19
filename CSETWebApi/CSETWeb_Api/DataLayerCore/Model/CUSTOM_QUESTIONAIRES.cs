using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_QUESTIONAIRES
    {
        public CUSTOM_QUESTIONAIRES()
        {
            CUSTOM_BASE_STANDARDS = new HashSet<CUSTOM_BASE_STANDARDS>();
            CUSTOM_QUESTIONAIRE_QUESTIONS = new HashSet<CUSTOM_QUESTIONAIRE_QUESTIONS>();
        }

        public string Custom_Questionaire_Name { get; set; }
        public string Description { get; set; }
        public string Set_Name { get; set; }

        public virtual ICollection<CUSTOM_BASE_STANDARDS> CUSTOM_BASE_STANDARDS { get; set; }
        public virtual ICollection<CUSTOM_QUESTIONAIRE_QUESTIONS> CUSTOM_QUESTIONAIRE_QUESTIONS { get; set; }
    }
}
