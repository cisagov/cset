using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GEN_FILE
    {
        public GEN_FILE()
        {
            FILE_KEYWORDS = new HashSet<FILE_KEYWORDS>();
            GEN_FILE_LIB_PATH_CORL = new HashSet<GEN_FILE_LIB_PATH_CORL>();
            REQUIREMENT_REFERENCES = new HashSet<REQUIREMENT_REFERENCES>();
            REQUIREMENT_SOURCE_FILES = new HashSet<REQUIREMENT_SOURCE_FILES>();
            SET_FILES = new HashSet<SET_FILES>();
        }

        public int Gen_File_Id { get; set; }
        public decimal? File_Type_Id { get; set; }
        public string File_Name { get; set; }
        public string Title { get; set; }
        public string Name { get; set; }
        public double? File_Size { get; set; }
        public string Doc_Num { get; set; }
        public string Comments { get; set; }
        public string Description { get; set; }
        public string Short_Name { get; set; }
        public DateTime? Publish_Date { get; set; }
        public string Doc_Version { get; set; }
        public string Summary { get; set; }
        public string Source_Type { get; set; }
        public byte[] Data { get; set; }
        public bool? Is_Uploaded { get; set; }

        public virtual FILE_REF_KEYS Doc_NumNavigation { get; set; }
        public virtual FILE_TYPE File_Type_ { get; set; }
        public virtual ICollection<FILE_KEYWORDS> FILE_KEYWORDS { get; set; }
        public virtual ICollection<GEN_FILE_LIB_PATH_CORL> GEN_FILE_LIB_PATH_CORL { get; set; }
        public virtual ICollection<REQUIREMENT_REFERENCES> REQUIREMENT_REFERENCES { get; set; }
        public virtual ICollection<REQUIREMENT_SOURCE_FILES> REQUIREMENT_SOURCE_FILES { get; set; }
        public virtual ICollection<SET_FILES> SET_FILES { get; set; }
    }
}
