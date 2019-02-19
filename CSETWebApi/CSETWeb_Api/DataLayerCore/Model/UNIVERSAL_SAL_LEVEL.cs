using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class UNIVERSAL_SAL_LEVEL
    {
        public UNIVERSAL_SAL_LEVEL()
        {
            NEW_QUESTION_LEVELS = new HashSet<NEW_QUESTION_LEVELS>();
            STANDARD_SELECTION = new HashSet<STANDARD_SELECTION>();
            STANDARD_TO_UNIVERSAL_MAP = new HashSet<STANDARD_TO_UNIVERSAL_MAP>();
        }

        public string Universal_Sal_Level1 { get; set; }
        public int Sal_Level_Order { get; set; }
        public string Full_Name_Sal { get; set; }

        public virtual ICollection<NEW_QUESTION_LEVELS> NEW_QUESTION_LEVELS { get; set; }
        public virtual ICollection<STANDARD_SELECTION> STANDARD_SELECTION { get; set; }
        public virtual ICollection<STANDARD_TO_UNIVERSAL_MAP> STANDARD_TO_UNIVERSAL_MAP { get; set; }
    }
}
