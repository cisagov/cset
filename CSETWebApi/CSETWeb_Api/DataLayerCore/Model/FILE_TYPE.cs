using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FILE_TYPE
    {
        public FILE_TYPE()
        {
            GEN_FILE = new HashSet<GEN_FILE>();
        }

        public decimal File_Type_Id { get; set; }
        public string File_Type1 { get; set; }
        public string Mime_Type { get; set; }
        public string Description { get; set; }

        public virtual ICollection<GEN_FILE> GEN_FILE { get; set; }
    }
}
