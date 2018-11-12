//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class FrameworkInfoData
    {
        public int RequirementID { get; set; }
        public bool IsCustomQuestion { get; set; }
        public String References { get; set; }       
        public String Question { get; set; }
        public String SupplementalInfo { get; set; }
        public String SetName { get; set; }
        public String Category { get; set; }


        public string Title { get; set; }
    }
}


