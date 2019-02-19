using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class STANDARD_SOURCE_FILE
    {
        public string Set_Name { get; set; }
        public string Doc_Num { get; set; }

        public virtual FILE_REF_KEYS Doc_NumNavigation { get; set; }
        public virtual SETS Set_NameNavigation { get; set; }
    }
}
