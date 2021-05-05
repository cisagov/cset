using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_QUESTIONAIRE_QUESTIONS
    {
        [StringLength(50)]
        public string Custom_Questionaire_Name { get; set; }
        public int Question_Id { get; set; }

        [ForeignKey("Custom_Questionaire_Name")]
        [InverseProperty("CUSTOM_QUESTIONAIRE_QUESTIONS")]
        public virtual CUSTOM_QUESTIONAIRES Custom_Questionaire_NameNavigation { get; set; }
    }
}