using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

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
        [StringLength(3990)]
        public string Path { get; set; }
        [StringLength(3990)]
        public string Title { get; set; }
        [StringLength(32)]
        public string FileMd5 { get; set; }
        [StringLength(200)]
        public string ContentType { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? CreatedTimestamp { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? UpdatedTimestamp { get; set; }
        [StringLength(500)]
        public string Name { get; set; }
        public byte[] Data { get; set; }

        [ForeignKey("Assessment_Id")]
        [InverseProperty("DOCUMENT_FILE")]
        public virtual ASSESSMENTS Assessment_ { get; set; }
        [ForeignKey("Assessment_Id")]
        [InverseProperty("DOCUMENT_FILE")]
        public virtual DEMOGRAPHICS Assessment_Navigation { get; set; }
        [InverseProperty("Document_")]
        public virtual ICollection<DOCUMENT_ANSWERS> DOCUMENT_ANSWERS { get; set; }
        [InverseProperty("eMass_Document_")]
        public virtual ICollection<INFORMATION> INFORMATION { get; set; }
    }
}
