//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

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
