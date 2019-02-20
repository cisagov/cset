using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_SOURCE_FILES
    {
        public int Requirement_Id { get; set; }
        public int Gen_File_Id { get; set; }
        [StringLength(850)]
        public string Section_Ref { get; set; }
        public int? Page_Number { get; set; }
        [StringLength(2000)]
        public string Destination_String { get; set; }

        [ForeignKey("Gen_File_Id")]
        [InverseProperty("REQUIREMENT_SOURCE_FILES")]
        public virtual GEN_FILE Gen_File_ { get; set; }
        [ForeignKey("Requirement_Id")]
        [InverseProperty("REQUIREMENT_SOURCE_FILES")]
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
