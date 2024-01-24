//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Set
{
    public class ReferenceDoc
    {
        public int ID { get; set; }
        public string FileName { get; set; }
        public string Title { get; set; }
        public string Name { get; set; }
        public string ShortName { get; set; }
        public string DocumentNumber { get; set; }
        public string DocumentVersion { get; set; }
        public DateTime? PublishDate { get; set; }
        public string Summary { get; set; }
        public string Description { get; set; }
        public string Comments { get; set; }
        public string SectionRef { get; set; }
        public bool IsUploaded { get; set; }
        public bool Selected { get; set; }

        /// <summary>
        /// To distinguish the documents whose information can be edited.
        /// </summary>
        public bool IsCustom { get; set; }
    }
}