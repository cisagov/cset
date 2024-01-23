//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class QuestionReferences
    {
        public List<RefDocument> SourceDocuments { get; set; } = new List<RefDocument>();
        public List<RefDocument> AddtionalDocuments { get; set; } = new List<RefDocument>();
    }

    public class RefDocument
    {
        public int QuestionId { get; set; }

        public string Title { get; set; }
        public string FileName { get; set; }
        public string SectionRef { get; set; }
    }

}
