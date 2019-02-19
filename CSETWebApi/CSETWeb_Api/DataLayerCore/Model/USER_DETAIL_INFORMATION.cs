using System;
using System.Collections.Generic;

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
        public string CellPhone { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string HomePhone { get; set; }
        public string OfficePhone { get; set; }
        public string ImagePath { get; set; }
        public string JobTitle { get; set; }
        public string Organization { get; set; }
        public string PrimaryEmail { get; set; }
        public string SecondaryEmail { get; set; }

        public virtual ICollection<ADDRESS> ADDRESS { get; set; }
        public virtual ICollection<USERS> USERS { get; set; }
    }
}
