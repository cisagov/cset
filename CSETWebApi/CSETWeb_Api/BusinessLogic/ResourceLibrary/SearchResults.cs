//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
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
            this.isProcurement = true;
            this.isCatalog = false;
            this.isResourceDocs = true;
        }
    }
}

