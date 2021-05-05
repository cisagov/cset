using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class GEN_FILE_LIB_PATH_CORL
    {
        public int Gen_File_Id { get; set; }
        [Column(TypeName = "numeric(38, 0)")]
        public decimal Lib_Path_Id { get; set; }

        [ForeignKey("Gen_File_Id")]
        [InverseProperty("GEN_FILE_LIB_PATH_CORL")]
        public virtual GEN_FILE Gen_File_ { get; set; }
        [ForeignKey("Lib_Path_Id")]
        [InverseProperty("GEN_FILE_LIB_PATH_CORL")]
        public virtual REF_LIBRARY_PATH Lib_Path_ { get; set; }
    }
}