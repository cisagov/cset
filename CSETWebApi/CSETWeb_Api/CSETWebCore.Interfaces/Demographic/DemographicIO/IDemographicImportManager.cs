//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.IO;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Demographic.Import
{
    public interface IDemographicImportManager
    {
        Task ProcessCSETDemographicImport(byte[] zipFileFromDatabase, int? currentUserId, int assessmentid, string accessKey, CSETContext context, string password = "", bool overwriteAssessment = false);
    }
}

