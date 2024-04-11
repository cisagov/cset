//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 


namespace CSETWebCore.DataLayer.Model
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class Answer_RequirementsXXX
    {
        [Key]
        public int Answer_Id { get; set; }
        public int Assessment_Id { get; set; }
        public Nullable<bool> Mark_For_Review { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public bool Is_Requirement { get; set; }
        public int Question_Or_Requirement_Id { get; set; }
        public Nullable<int> Question_Number { get; set; }
        public string Answer_Text { get; set; }
        public string Component_Guid { get; set; }
        public bool Is_Component { get; set; }
        public bool Is_Framework { get; set; }
    }
}


