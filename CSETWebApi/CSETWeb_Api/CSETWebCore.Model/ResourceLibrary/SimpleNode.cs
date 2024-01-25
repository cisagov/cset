//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.ResourceLibrary
{
    public class SimpleNode
    {
        public List<SimpleNode> children { get; set; }
        public string label { get; set; }
        public string value { get; set; }
        public string DocId { get; set; }
        public string DatePublished { get; set; }
        public string HeadingTitle { get; set; }
        public string HeadingText { get; set; }
    }
}