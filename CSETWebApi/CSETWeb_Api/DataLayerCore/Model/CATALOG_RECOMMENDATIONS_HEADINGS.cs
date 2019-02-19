using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CATALOG_RECOMMENDATIONS_HEADINGS
    {
        public CATALOG_RECOMMENDATIONS_HEADINGS()
        {
            CATALOG_RECOMMENDATIONS_DATA = new HashSet<CATALOG_RECOMMENDATIONS_DATA>();
        }

        public int Id { get; set; }
        public int Heading_Num { get; set; }
        public string Heading_Name { get; set; }

        public virtual ICollection<CATALOG_RECOMMENDATIONS_DATA> CATALOG_RECOMMENDATIONS_DATA { get; set; }
    }
}
