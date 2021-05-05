using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FILE_KEYWORDS
    {
        public int Gen_File_Id { get; set; }
        [StringLength(60)]
        public string Keyword { get; set; }

        [ForeignKey("Gen_File_Id")]
        [InverseProperty("FILE_KEYWORDS")]
        public virtual GEN_FILE Gen_File_ { get; set; }
    }
}