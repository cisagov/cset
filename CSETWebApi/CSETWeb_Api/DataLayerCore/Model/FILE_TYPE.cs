using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class FILE_TYPE
    {
        public FILE_TYPE()
        {
            GEN_FILE = new HashSet<GEN_FILE>();
        }

        [Column(TypeName = "numeric(38, 0)")]
        public decimal File_Type_Id { get; set; }
        [Required]
        [Column("File_Type")]
        [StringLength(60)]
        public string File_Type1 { get; set; }
        [StringLength(60)]
        public string Mime_Type { get; set; }
        [StringLength(250)]
        public string Description { get; set; }

        [InverseProperty("File_Type_")]
        public virtual ICollection<GEN_FILE> GEN_FILE { get; set; }
    }
}