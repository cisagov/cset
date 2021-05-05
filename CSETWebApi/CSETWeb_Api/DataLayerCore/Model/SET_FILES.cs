using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class SET_FILES
    {
        [StringLength(50)]
        public string SetName { get; set; }
        public int Gen_File_Id { get; set; }
        [StringLength(50)]
        public string Comment { get; set; }

        [ForeignKey("Gen_File_Id")]
        [InverseProperty("SET_FILES")]
        public virtual GEN_FILE Gen_File_ { get; set; }
        [ForeignKey("SetName")]
        [InverseProperty("SET_FILES")]
        public virtual SETS SetNameNavigation { get; set; }
    }
}