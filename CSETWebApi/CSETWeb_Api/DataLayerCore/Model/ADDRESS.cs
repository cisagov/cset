using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class ADDRESS
    {
        public string PrimaryEmail { get; set; }
        public string AddressType { get; set; }
        public Guid Id { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Line1 { get; set; }
        public string Line2 { get; set; }
        public string State { get; set; }
        public string Zip { get; set; }

        public virtual USER_DETAIL_INFORMATION IdNavigation { get; set; }
    }
}
