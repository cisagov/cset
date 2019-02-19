using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DOCUMENT_ANSWERS
    {
        public int Document_Id { get; set; }
        public int Answer_Id { get; set; }

        public virtual ANSWER Answer_ { get; set; }
        public virtual DOCUMENT_FILE Document_ { get; set; }
    }
}
