using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REFERENCE_DOCS
    {
        public REFERENCE_DOCS()
        {
            REFERENCES_DATA = new HashSet<REFERENCES_DATA>();
        }

        public int Reference_Doc_Id { get; set; }
        public string Doc_Name { get; set; }
        public string Doc_Link { get; set; }
        public string Doc_Short { get; set; }
        public DateTime? Date_Updated { get; set; }
        public DateTime? Date_Last_Checked { get; set; }
        public string Doc_Url { get; set; }
        public string Doc_Notes { get; set; }

        public virtual ICollection<REFERENCES_DATA> REFERENCES_DATA { get; set; }
    }
}
