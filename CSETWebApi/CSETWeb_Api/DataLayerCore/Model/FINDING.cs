using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FINDING
    {
        public FINDING()
        {
            FINDING_CONTACT = new HashSet<FINDING_CONTACT>();
        }

        public int Answer_Id { get; set; }
        public int Finding_Id { get; set; }
        public string Summary { get; set; }
        public string Issue { get; set; }
        public string Impact { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public DateTime? Resolution_Date { get; set; }
        public int? Importance_Id { get; set; }

        public virtual ANSWER Answer_ { get; set; }
        public virtual IMPORTANCE Importance_ { get; set; }
        public virtual ICollection<FINDING_CONTACT> FINDING_CONTACT { get; set; }
    }
}
