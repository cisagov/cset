//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Questions.POCO;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;

namespace CSET_Main.Questions.Slice
{
    public class Requirement_And_Set
    {
        public Boolean IsFramework { get; set; }
        public Boolean IsCNSSI { get; set; }
        public NEW_REQUIREMENT NewRequirement { get; set; }
        public List<REQUIREMENT_LEVELS> RequirementLevels { get; set; }
        public QuestionPoco Question { get; set; }


        public SETS Set { get; set; }

        public string Set_Name_Short { get { return Set.Short_Name; } }

        public string Set_Full_Name { get { return Set.Full_Name; } }

        public string SET_Name { get { return Set.Set_Name; } }
    }
}


