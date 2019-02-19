using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_SYMBOLS_GM_TO_CSET
    {
        public string GM_FingerType { get; set; }
        public int Id { get; set; }

        public virtual COMPONENT_SYMBOLS IdNavigation { get; set; }
    }
}
