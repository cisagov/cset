using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PROCUREMENT_REFERENCES
    {
        public int Procurement_Id { get; set; }
        public int Reference_Id { get; set; }

        public virtual PROCUREMENT_LANGUAGE_DATA Procurement_ { get; set; }
        public virtual REFERENCES_DATA Reference_ { get; set; }
    }
}
