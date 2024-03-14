//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{

    public class ACETFilter
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }

        public List<ACETDomainTiers> Tiers { get; set; }
    }


    public class ACETDomainTiers
    {
        public bool IsOn { get; set; }
        public int Financial_Level_Id { get; set; }
    }


    public class ACETDomainFilterSetting
    {
        public String DomainName { get; set; }
        public int DomainId { get; set; }

        public bool IsOn { get; set; }
        public int Financial_Level_Id { get; set; }
    }

}