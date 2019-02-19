using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NEW_QUESTION_LEVELS
    {
        public int New_Question_Set_Id { get; set; }
        public string Universal_Sal_Level { get; set; }

        public virtual NEW_QUESTION_SETS New_Question_Set_ { get; set; }
        public virtual UNIVERSAL_SAL_LEVEL Universal_Sal_LevelNavigation { get; set; }
    }
}
