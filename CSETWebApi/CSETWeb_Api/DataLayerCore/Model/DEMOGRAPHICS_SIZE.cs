using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DEMOGRAPHICS_SIZE
    {
        public DEMOGRAPHICS_SIZE()
        {
            DEMOGRAPHICS = new HashSet<DEMOGRAPHICS>();
        }

        public int DemographicId { get; set; }
        public string Size { get; set; }
        public string Description { get; set; }
        public int? ValueOrder { get; set; }

        public virtual ICollection<DEMOGRAPHICS> DEMOGRAPHICS { get; set; }
    }
}
