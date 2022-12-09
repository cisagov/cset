using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class ACETFilter
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }

        public bool IsOn { get; set; }

        public int Financial_Level_Id { get; set; }
        public bool GroupAllSettingsFalse { get; set; }
    }
}