//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using DataAccess.Model;

namespace DataAccess
{
    public interface IFileRepository
    {
        IEnumerable<FileDescriptionShort> AddFileDescriptions(FileResult fileResult);

        IEnumerable<FileDescriptionShort> GetAllFiles();

        FileDescription GetFileDescription(int id);
    }
}


