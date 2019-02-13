using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class CUSTOM_BASE_STANDARDS
    {
        [StringLength(50)]
        public string Custom_Questionaire_Name { get; set; }
        [StringLength(50)]
        public string Base_Standard { get; set; }

        [ForeignKey("Custom_Questionaire_Name")]
        [InverseProperty("CUSTOM_BASE_STANDARDS")]
        public virtual CUSTOM_QUESTIONAIRES Custom_Questionaire_NameNavigation { get; set; }
    }
}