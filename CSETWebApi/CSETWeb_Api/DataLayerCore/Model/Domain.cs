using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class Domain
    {
        [StringLength(200)]
        public string DomainName { get; set; }
    }
}
