//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.DataLayer.Model
{
    public class AllUploadedFiles
    {
        public List<FileDescriptionShort> FileShortDescriptions { get; set; }
    }
    public class FileDescriptionShort
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Path { get; set; }
        public string Name { get; set; }
    }
}

