using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class USER_SECURITY_QUESTIONS
    {
        public int UserId { get; set; }
        [StringLength(250)]
        public string SecurityQuestion1 { get; set; }
        [StringLength(250)]
        public string SecurityAnswer1 { get; set; }
        [StringLength(250)]
        public string SecurityQuestion2 { get; set; }
        [StringLength(250)]
        public string SecurityAnswer2 { get; set; }

        [ForeignKey("UserId")]
        [InverseProperty("USER_SECURITY_QUESTIONS")]
        public virtual USERS User { get; set; }
    }
}
