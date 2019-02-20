using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("Schema", Schema = "HangFire")]
    public partial class Schema
    {
        public int Version { get; set; }
    }
}
