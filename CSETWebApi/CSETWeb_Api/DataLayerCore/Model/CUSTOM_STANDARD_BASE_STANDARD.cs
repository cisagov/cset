using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_STANDARD_BASE_STANDARD
    {
        public string Custom_Questionaire_Name { get; set; }
        public string Base_Standard { get; set; }
        public int Custom_Standard_Base_Standard_Id { get; set; }

        public virtual SETS Base_StandardNavigation { get; set; }
        public virtual SETS Custom_Questionaire_NameNavigation { get; set; }
    }
}
