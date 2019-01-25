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

namespace CSET_Main.Questions.POCO
{
    public class RequirementTabData
    {
        public int RequirementID { get; set; }
        public String Text { get; set; }
        public String SupplementalInfo { get; set; }

        public string Set_Name { get; set; }
    }

    /// <summary>
    /// Container for returning questions related to a requirement.
    /// </summary>
    public class RelatedQuestion
    {
        public int QuestionID { get; set; }
        public string QuestionText { get; set; }
    }
}


