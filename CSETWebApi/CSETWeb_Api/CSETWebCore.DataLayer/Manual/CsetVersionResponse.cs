using System;
namespace CSETWebCore.DataLayer.Model
{
    /// <summary>
    /// 
    /// </summary>
    public class CsetVersion
    {
        public Version CodebaseVersion { get; set; }
        public Version DatabaseVersion { get; set; }
    }

    public class Version
    {
        public int MajorVersion { get; set; } = 0;
        public int MinorVersion { get; set; } = 0;
        public int Build { get; set; } = 0;
        public int Revision { get; set; } = 0;
    }
}

