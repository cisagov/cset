using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class CSET_VERSION
    {
        public int Id { get; set; }
        public decimal Version_Id { get; set; }
        public string Cset_Version1 { get; set; }
        public string Build_Number { get; set; }
    }
}
