using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REQUIREMENT_SOURCE_FILES
    {
        public int Requirement_Id { get; set; }
        public int Gen_File_Id { get; set; }
        public string Section_Ref { get; set; }
        public int? Page_Number { get; set; }
        public string Destination_String { get; set; }

        public virtual GEN_FILE Gen_File_ { get; set; }
        public virtual NEW_REQUIREMENT Requirement_ { get; set; }
    }
}
