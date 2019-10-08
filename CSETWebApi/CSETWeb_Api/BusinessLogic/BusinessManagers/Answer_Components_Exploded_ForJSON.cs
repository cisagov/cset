//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWeb_Api.BusinessManagers
{
    public class Answer_Components_Exploded_ForJSON     
    {   
        public int Assessment_Id { get; set; }
        public Nullable<int> Answer_Id { get; set; }
        public int Question_Id { get; set; }
        public string Answer_Text { get; set; }
        public Nullable<int> Question_Number { get; set; }
        public string QuestionText { get; set; }
        public string ComponentName { get; set; }
        public string Component_Type { get; set; }
        public bool Is_Component { get; set; }
        public string Component_GUID { get; set; }        
        public string ZoneName { get; set; }
        public string SAL { get; set; }
        
    }
}