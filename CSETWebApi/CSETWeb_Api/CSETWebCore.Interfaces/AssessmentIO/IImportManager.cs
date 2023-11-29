//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    public interface IImportManager
    {
        Task ProcessCSETAssessmentImport(byte[] zipFileFromDatabase, int? currentUserId, string accessKey, CSETContext context, string password = "", bool overwriteAssessment = false);
        void LaunchLegacyCSETProcess(string csetFilePath, string token, string processPath, string apiURL);
    }
}