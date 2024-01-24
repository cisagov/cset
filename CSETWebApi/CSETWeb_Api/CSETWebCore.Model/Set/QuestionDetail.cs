//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class QuestionDetail
    {
        public int QuestionID { get; set; }
        public string QuestionText { get; set; }
        public string QuestionGroupHeading { get; set; }

        /// <summary>
        /// The primary key of the UNIVERSAL_SUBCATEGORY_HEADING.
        /// </summary>
        public int PairID { get; set; }
        public string Subcategory { get; set; }
        public string SubHeading { get; set; }

        public int DisplayNumber { get; set; }
        public string Title { get; set; }
        public bool IsCustom { get; set; }
        public List<string> SalLevels { get; set; } = new List<string>();
    }
}