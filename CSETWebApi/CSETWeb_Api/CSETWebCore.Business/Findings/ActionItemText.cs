//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.Collections.Generic;

namespace CSETWebCore.Business.Findings
{
    public class ActionItemText
    {
        public int Mat_Question_Id { get; set; }
        public string ActionItemOverrideText { get; set; }
    }
    public class ActionItemTextUpdate
    {
        public List<ActionItemText> actionTextItems { get; set; }
        public int finding_Id { get; set; }
}
}