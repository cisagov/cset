using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class ACETFilter
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }

        public List<ACETFilterSetting> Settings { get; set; }

        public int Financial_Level_Id { get; set; } 
    }
}