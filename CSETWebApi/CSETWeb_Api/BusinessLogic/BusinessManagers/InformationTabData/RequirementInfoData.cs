//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class RequirementInfoData
    {
        public int RequirementID { get; set; }
        public string SetName { get; set; }
        public String Category { get; set; }
        public NEW_REQUIREMENT Requirement { get; set; }
        public Dictionary<String, SET> Sets { get; set; }
    }
}


