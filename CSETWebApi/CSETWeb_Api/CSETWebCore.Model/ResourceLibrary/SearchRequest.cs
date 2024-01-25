//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.ResourceLibrary
{
    public class SearchRequest
    {
        public string term { get; set; }

        public bool isProcurement { get; set; }
        public bool isCatalog { get; set; }
        public bool isResourceDocs { get; set; }

        public SearchRequest()
        {
            this.isProcurement = true;
            this.isCatalog = false;
            this.isResourceDocs = true;
        }
    }
}