//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class QuestionReferences
    {
        public List<RefDocument> SourceDocuments { get; set; } = new List<RefDocument>();
        public List<RefDocument> v { get; set; } = new List<RefDocument>();
    }

    public class RefDocument
    {
        public int QuestionId { get; set; }

        public string Title { get; set; }
        public string FileName { get; set; }
        public string SectionRef { get; set; }
    }

}
