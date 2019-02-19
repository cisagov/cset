using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SYMBOL_GROUPS
    {
        public SYMBOL_GROUPS()
        {
            COMPONENT_SYMBOLS = new HashSet<COMPONENT_SYMBOLS>();
        }

        public int Id { get; set; }
        public string Symbol_Group_Name { get; set; }
        public string Symbol_Group_Title { get; set; }

        public virtual ICollection<COMPONENT_SYMBOLS> COMPONENT_SYMBOLS { get; set; }
    }
}
