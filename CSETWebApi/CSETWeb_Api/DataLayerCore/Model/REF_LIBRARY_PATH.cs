using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class REF_LIBRARY_PATH
    {
        public REF_LIBRARY_PATH()
        {
            GEN_FILE_LIB_PATH_CORL = new HashSet<GEN_FILE_LIB_PATH_CORL>();
            InverseParent_Path_ = new HashSet<REF_LIBRARY_PATH>();
        }

        public decimal Lib_Path_Id { get; set; }
        public decimal? Parent_Path_Id { get; set; }
        public string Path_Name { get; set; }

        public virtual REF_LIBRARY_PATH Parent_Path_ { get; set; }
        public virtual ICollection<GEN_FILE_LIB_PATH_CORL> GEN_FILE_LIB_PATH_CORL { get; set; }
        public virtual ICollection<REF_LIBRARY_PATH> InverseParent_Path_ { get; set; }
    }
}
