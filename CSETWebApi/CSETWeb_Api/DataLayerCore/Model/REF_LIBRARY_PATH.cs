using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class REF_LIBRARY_PATH
    {
        public REF_LIBRARY_PATH()
        {
            GEN_FILE_LIB_PATH_CORL = new HashSet<GEN_FILE_LIB_PATH_CORL>();
            InverseParent_Path_ = new HashSet<REF_LIBRARY_PATH>();
        }

        [Column(TypeName = "numeric(38, 0)")]
        public decimal Lib_Path_Id { get; set; }
        [Column(TypeName = "numeric(38, 0)")]
        public decimal? Parent_Path_Id { get; set; }
        [StringLength(60)]
        public string Path_Name { get; set; }

        [ForeignKey("Parent_Path_Id")]
        [InverseProperty("InverseParent_Path_")]
        public virtual REF_LIBRARY_PATH Parent_Path_ { get; set; }
        [InverseProperty("Lib_Path_")]
        public virtual ICollection<GEN_FILE_LIB_PATH_CORL> GEN_FILE_LIB_PATH_CORL { get; set; }
        [InverseProperty("Parent_Path_")]
        public virtual ICollection<REF_LIBRARY_PATH> InverseParent_Path_ { get; set; }
    }
}