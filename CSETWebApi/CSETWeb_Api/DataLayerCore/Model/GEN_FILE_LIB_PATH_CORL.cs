using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GEN_FILE_LIB_PATH_CORL
    {
        public int Gen_File_Id { get; set; }
        public decimal Lib_Path_Id { get; set; }

        public virtual GEN_FILE Gen_File_ { get; set; }
        public virtual REF_LIBRARY_PATH Lib_Path_ { get; set; }
    }
}
