using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
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
                SetMessages.Add( message);           
        }

        public String GetMessage()
        {
            return String.Join("\n\n", SetMessages);
        }
    }
}
