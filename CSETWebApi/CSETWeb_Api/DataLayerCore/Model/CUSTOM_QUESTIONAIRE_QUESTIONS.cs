using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_QUESTIONAIRE_QUESTIONS
    {
        public string Custom_Questionaire_Name { get; set; }
        public int Question_Id { get; set; }

        public virtual CUSTOM_QUESTIONAIRES Custom_Questionaire_NameNavigation { get; set; }
    }
}
