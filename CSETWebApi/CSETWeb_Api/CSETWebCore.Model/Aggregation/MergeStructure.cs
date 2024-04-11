//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class MergeStructure
    {
        public Guid MergeID { get; set; }
        public List<string> Aliases = new List<string>();
        public List<MergeCategory> QuestionsCategories = new List<MergeCategory>();
        public List<MergeCategory> ComponentDefaultCategories = new List<MergeCategory>();
        public List<MergeCategory> ComponentOverrideCategories = new List<MergeCategory>();
    }
}