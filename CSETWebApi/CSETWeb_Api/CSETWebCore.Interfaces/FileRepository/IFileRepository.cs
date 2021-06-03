using System.Collections.Generic;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Interfaces.FileRepository
{
    public interface IFileRepository
    {
        IEnumerable<FileDescriptionShort> AddFileDescriptions(FileResult fileResult);

        IEnumerable<FileDescriptionShort> GetAllFiles(int assessment_id);

        DOCUMENT_FILE GetFileDescription(int id);
    }
}