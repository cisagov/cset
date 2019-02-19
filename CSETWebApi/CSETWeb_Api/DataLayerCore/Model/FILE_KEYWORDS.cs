using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class FILE_KEYWORDS
    {
        public int Gen_File_Id { get; set; }
        public string Keyword { get; set; }

        public virtual GEN_FILE Gen_File_ { get; set; }
    }
}
