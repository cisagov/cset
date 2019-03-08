using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ADDRESS
    {
        [StringLength(150)]
        public string PrimaryEmail { get; set; }
        [StringLength(50)]
        public string AddressType { get; set; }
        public Guid Id { get; set; }
        [StringLength(150)]
        public string City { get; set; }
        [StringLength(150)]
        public string Country { get; set; }
        [StringLength(150)]
        public string Line1 { get; set; }
        [StringLength(150)]
        public string Line2 { get; set; }
        [StringLength(150)]
        public string State { get; set; }
        [StringLength(150)]
        public string Zip { get; set; }

        [ForeignKey("Id")]
        [InverseProperty("ADDRESS")]
        public virtual USER_DETAIL_INFORMATION IdNavigation { get; set; }
    }
}