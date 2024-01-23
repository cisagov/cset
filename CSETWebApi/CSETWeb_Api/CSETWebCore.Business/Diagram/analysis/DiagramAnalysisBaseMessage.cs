//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public abstract class DiagramAnalysisBaseMessage
    {

        public HashSet<String> SetMessages { get; set; }

        public DiagramAnalysisBaseMessage()
        {
            SetMessages = new HashSet<string>();
        }

        public void AddMessage(String message)
        {
            SetMessages.Add(message);
        }

        public String GetMessage()
        {
            return String.Join("\n\n", SetMessages);
        }
    }
}
