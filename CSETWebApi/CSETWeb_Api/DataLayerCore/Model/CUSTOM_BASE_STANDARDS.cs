using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_BASE_STANDARDS
    {
        public string Custom_Questionaire_Name { get; set; }
        public string Base_Standard { get; set; }

        public virtual CUSTOM_QUESTIONAIRES Custom_Questionaire_NameNavigation { get; set; }
    }
}
