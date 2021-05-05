using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FINDING
    {
        public FINDING()
        {
            FINDING_CONTACT = new HashSet<FINDING_CONTACT>();
        }

        public int Answer_Id { get; set; }
        [Key]
        public int Finding_Id { get; set; }
        public string Summary { get; set; }
        public string Issue { get; set; }
        public string Impact { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public DateTime? Resolution_Date { get; set; }
        public int? Importance_Id { get; set; }

        [ForeignKey("Answer_Id")]
        [InverseProperty("FINDING")]
        public virtual ANSWER Answer_ { get; set; }
        [ForeignKey("Importance_Id")]
        [InverseProperty("FINDING")]
        public virtual IMPORTANCE Importance_ { get; set; }
        [InverseProperty("Finding_")]
        public virtual ICollection<FINDING_CONTACT> FINDING_CONTACT { get; set; }
    }
}