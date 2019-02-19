using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class PROCUREMENT_DEPENDENCY
    {
        public int Procurement_Id { get; set; }
        public int Dependencies_Id { get; set; }

        public virtual PROCUREMENT_LANGUAGE_DATA Dependencies_ { get; set; }
        public virtual PROCUREMENT_LANGUAGE_DATA Procurement_ { get; set; }
    }
}
