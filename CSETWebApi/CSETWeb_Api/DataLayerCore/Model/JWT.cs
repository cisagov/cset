using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class JWT
    {
        public string Secret { get; set; }
        public DateTime Generated { get; set; }
    }
}
