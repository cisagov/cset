using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class LEVEL_BACKUP_ACET
    {
        public int requirement_id { get; set; }
        [StringLength(50)]
        public string Standard_Level { get; set; }
    }
}