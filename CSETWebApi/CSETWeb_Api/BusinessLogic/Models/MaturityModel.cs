//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSETWeb_Api.Models;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityModel
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public int MaturityTargetLevel { get; set; }
        public List<MaturityLevel> Levels { get; set; }
        public string QuestionsAlias { get; set; }
    }
}
