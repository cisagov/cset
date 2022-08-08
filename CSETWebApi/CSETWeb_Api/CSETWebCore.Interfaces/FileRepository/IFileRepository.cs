using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.FileRepository
{
    public interface IFileRepository
    {
        Task<IEnumerable<FileDescriptionShort>> AddFileDescriptions(FileResult fileResult);

        IEnumerable<FileDescriptionShort> GetAllFiles(int assessment_id);

        DOCUMENT_FILE GetFileDescription(int id);
    }
}