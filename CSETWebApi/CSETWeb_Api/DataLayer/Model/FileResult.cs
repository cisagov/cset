//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace DataAccess.Model
{
    public class FileResult
    {
        public List<string> FileNames { get; set; }
        public string Tiitle { get; set; }
        public DateTime CreatedTimestamp { get; set; }
        public DateTime UpdatedTimestamp { get; set; }
        public List<string> ContentTypes { get; set; }
        public List<string> Names { get; set; }
    }
}

