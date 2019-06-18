using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class GEN_FILE
    {
        public GEN_FILE()
        {
            FILE_KEYWORDS = new HashSet<FILE_KEYWORDS>();
            GEN_FILE_LIB_PATH_CORL = new HashSet<GEN_FILE_LIB_PATH_CORL>();
            REQUIREMENT_REFERENCES = new HashSet<REQUIREMENT_REFERENCES>();
            REQUIREMENT_SOURCE_FILES = new HashSet<REQUIREMENT_SOURCE_FILES>();
            SET_FILES = new HashSet<SET_FILES>();
        }

        public int Gen_File_Id { get; set; }
        [Column(TypeName = "numeric(38, 0)")]
        public decimal? File_Type_Id { get; set; }
        [Required]
        [StringLength(250)]
        public string File_Name { get; set; }
        [Required]
        [StringLength(250)]
        public string Title { get; set; }
        [StringLength(250)]
        public string Name { get; set; }
        public double? File_Size { get; set; }
        [Required]
        [StringLength(40)]
        public string Doc_Num { get; set; }
        [StringLength(500)]
        public string Comments { get; set; }
        [StringLength(250)]
        public string Description { get; set; }
        [Required]
        [StringLength(60)]
        public string Short_Name { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? Publish_Date { get; set; }
        [StringLength(20)]
        public string Doc_Version { get; set; }
        [StringLength(2000)]
        public string Summary { get; set; }
        [StringLength(50)]
        public string Source_Type { get; set; }
        public byte[] Data { get; set; }
        [Required]
        public bool? Is_Uploaded { get; set; }

        [ForeignKey("Doc_Num")]
        [InverseProperty("GEN_FILE")]
        public virtual FILE_REF_KEYS Doc_NumNavigation { get; set; }
        [ForeignKey("File_Type_Id")]
        [InverseProperty("GEN_FILE")]
        public virtual FILE_TYPE File_Type_ { get; set; }
        [InverseProperty("Gen_File_")]
        public virtual ICollection<FILE_KEYWORDS> FILE_KEYWORDS { get; set; }
        [InverseProperty("Gen_File_")]
        public virtual ICollection<GEN_FILE_LIB_PATH_CORL> GEN_FILE_LIB_PATH_CORL { get; set; }
        [InverseProperty("Gen_File_")]
        public virtual ICollection<REQUIREMENT_REFERENCES> REQUIREMENT_REFERENCES { get; set; }
        [InverseProperty("Gen_File_")]
        public virtual ICollection<REQUIREMENT_SOURCE_FILES> REQUIREMENT_SOURCE_FILES { get; set; }
        [InverseProperty("Gen_File_")]
        public virtual ICollection<SET_FILES> SET_FILES { get; set; }
    }
}