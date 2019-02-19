using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PROCUREMENT_LANGUAGE_HEADINGS
    {
        public PROCUREMENT_LANGUAGE_HEADINGS()
        {
            PROCUREMENT_LANGUAGE_DATA = new HashSet<PROCUREMENT_LANGUAGE_DATA>();
        }

        public int Id { get; set; }
        public int? Heading_Num { get; set; }
        public string Heading_Name { get; set; }

        public virtual ICollection<PROCUREMENT_LANGUAGE_DATA> PROCUREMENT_LANGUAGE_DATA { get; set; }
    }
}
