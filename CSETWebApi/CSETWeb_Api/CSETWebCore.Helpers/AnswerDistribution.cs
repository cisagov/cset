//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Helpers
{
    public class AnswerDistribution
    {
        public static Dictionary<String, String> AnswerColorDefs = new Dictionary<string, string>();

        static AnswerDistribution()
        {
            AnswerColorDefs.Add("U", "#CCCCCC");
            AnswerColorDefs.Add("Y", "#28A745");
            AnswerColorDefs.Add("A", "#FFC107");
            AnswerColorDefs.Add("NA", "#007BFF");
            AnswerColorDefs.Add("N", "#DC3545");
        }
    }
}
