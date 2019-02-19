using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class RECENT_FILES
    {
        public string AssessmentName { get; set; }
        public string Filename { get; set; }
        public string FilePath { get; set; }
        public DateTime LastOpenedTime { get; set; }
        public int RecentFileId { get; set; }
    }
}
