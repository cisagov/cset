using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class RECOMMENDATIONS_REFERENCES
    {
        public int Data_Id { get; set; }
        public int Reference_Id { get; set; }

        public virtual CATALOG_RECOMMENDATIONS_DATA Data_ { get; set; }
        public virtual REFERENCES_DATA Reference_ { get; set; }
    }
}
