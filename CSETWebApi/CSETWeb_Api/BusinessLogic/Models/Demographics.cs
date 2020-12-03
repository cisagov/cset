//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Models
{
    public class Demographics
    {
        public int AssessmentId;
        public int? SectorId;
        public int? IndustryId;
        public int? Size;
        public int? AssetValue;
        public string OrganizationName;
        public string Agency;
        public int? OrganizationType;
        public int? Facilitator;
        public int? PointOfContact;
        public bool IsScoped;
    }
}

