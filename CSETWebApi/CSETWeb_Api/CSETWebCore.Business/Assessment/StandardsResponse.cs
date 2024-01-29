//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Business.Assessment
{
    public class StandardsResponse
    {
        public List<StandardCategory> Categories;
        public int QuestionCount;
        public int RequirementCount;
    }


    /// <summary>
    /// 
    /// </summary>
    public class StandardCategory
    {
        public string CategoryName { get; set; }
        public List<Standard> Standards { get; set; }

        public StandardCategory()
        {
            Standards = new List<Standard>();
        }
    }


    /// <summary>
    /// This is the model for the Standard that is displayed on the 
    /// Cybersecurity Standard Selection screen.
    /// </summary>
    public class Standard
    {
        public string Code { get; set; }
        public string FullName { get; set; }
        public string Description { get; set; }
        public bool Selected { get; set; }
        public bool Recommended { get; set; }
    }
}