using System;
namespace CSETWebCore.DataLayer.Model
{

    public class CsetVersionResponse
    {
        public int MajorVersion { get; set; }
        public int MinorVersion { get; set; }
        public int Patch { get; set; }
        public int Build { get; set; }
    }

}

