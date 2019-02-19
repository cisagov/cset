using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DOCUMENT_FILE
    {
        public DOCUMENT_FILE()
        {
            DOCUMENT_ANSWERS = new HashSet<DOCUMENT_ANSWERS>();
            INFORMATION = new HashSet<INFORMATION>();
        }

        public int Assessment_Id { get; set; }
        public int Document_Id { get; set; }
        public string Path { get; set; }
        public string Title { get; set; }
        public string FileMd5 { get; set; }
        public string ContentType { get; set; }
        public DateTime? CreatedTimestamp { get; set; }
        public DateTime? UpdatedTimestamp { get; set; }
        public string Name { get; set; }
        public byte[] Data { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual DEMOGRAPHICS Assessment_Navigation { get; set; }
        public virtual ICollection<DOCUMENT_ANSWERS> DOCUMENT_ANSWERS { get; set; }
        public virtual ICollection<INFORMATION> INFORMATION { get; set; }
    }
}
