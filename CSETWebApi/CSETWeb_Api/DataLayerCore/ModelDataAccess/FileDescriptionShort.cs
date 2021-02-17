//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace DataAccess.Model
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
        public string Name { get; internal set; }
    }
}

