using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    [Table("Server", Schema = "HangFire")]
    public partial class Server
    {
        [StringLength(100)]
        public string Id { get; set; }
        public string Data { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime LastHeartbeat { get; set; }
    }
}
