using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REFERENCES_DATA
    {
        public REFERENCES_DATA()
        {
            PROCUREMENT_REFERENCES = new HashSet<PROCUREMENT_REFERENCES>();
            RECOMMENDATIONS_REFERENCES = new HashSet<RECOMMENDATIONS_REFERENCES>();
        }

        public int Reference_Id { get; set; }
        public int? Reference_Doc_Id { get; set; }
        public string Reference_Sections { get; set; }

        public virtual REFERENCE_DOCS Reference_Doc_ { get; set; }
        public virtual ICollection<PROCUREMENT_REFERENCES> PROCUREMENT_REFERENCES { get; set; }
        public virtual ICollection<RECOMMENDATIONS_REFERENCES> RECOMMENDATIONS_REFERENCES { get; set; }
    }
}
