//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace CSETWebCore.Model.Maturity
{
    public class GroupingSpanishRow
    {
        public GroupingSpanishRow() { }

        public int Grouping_Id { get; set; }

        public string English_Title { get; set; }

        public string Spanish_Title { get; set; }

        public int Sequence { get; set; }

        public int Parent_Id { get; set; }
    }
}