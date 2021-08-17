//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWeb_Api.Controllers
{
    public class SearchRequest
    {
        public string term { get; set; }

        public Boolean isProcurement { get; set; }
        public Boolean isCatalog  { get; set; }
        public Boolean isResourceDocs  { get; set; }

        public SearchRequest()
        {
            this.isProcurement = false;
            this.isCatalog = false;
            this.isResourceDocs = true;
        }
    }
}

