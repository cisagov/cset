using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class NEW_QUESTION_LEVELS
    {
        public int New_Question_Set_Id { get; set; }
        [StringLength(10)]
        public string Universal_Sal_Level { get; set; }
        public int? IgnoreMe { get; set; }

        [ForeignKey("New_Question_Set_Id")]
        [InverseProperty("NEW_QUESTION_LEVELS")]
        public virtual NEW_QUESTION_SETS New_Question_Set_ { get; set; }
        [ForeignKey("Universal_Sal_Level")]
        [InverseProperty("NEW_QUESTION_LEVELS")]
        public virtual UNIVERSAL_SAL_LEVEL Universal_Sal_LevelNavigation { get; set; }
    }
}