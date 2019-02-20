using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class USER_DETAIL_INFORMATION
    {
        public USER_DETAIL_INFORMATION()
        {
            ADDRESS = new HashSet<ADDRESS>();
            USERS = new HashSet<USERS>();
        }

        public Guid Id { get; set; }
        [StringLength(150)]
        public string CellPhone { get; set; }
        [Required]
        [StringLength(150)]
        public string FirstName { get; set; }
        [Required]
        [StringLength(150)]
        public string LastName { get; set; }
        [StringLength(150)]
        public string HomePhone { get; set; }
        [StringLength(150)]
        public string OfficePhone { get; set; }
        [StringLength(150)]
        public string ImagePath { get; set; }
        [StringLength(150)]
        public string JobTitle { get; set; }
        [StringLength(150)]
        public string Organization { get; set; }
        [StringLength(150)]
        public string PrimaryEmail { get; set; }
        [StringLength(150)]
        public string SecondaryEmail { get; set; }

        [InverseProperty("IdNavigation")]
        public virtual ICollection<ADDRESS> ADDRESS { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual ICollection<USERS> USERS { get; set; }
    }
}
