using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class EXTRA_ACET_MAPPING
    {
        [StringLength(50)]
        public string Set_Name { get; set; }
        public int Question_Id { get; set; }
        public int New_Question_Set_Id { get; set; }
    }
}
