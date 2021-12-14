using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class ACETFilter
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }

        public List<ACETFilterSetting> Settings { get; set; }

        public bool B { get; set; }
        public bool E { get; set; }
        public bool Int { get; set; }
        public bool A { get; set; }
        public bool Inn { get; set; }
    }
}