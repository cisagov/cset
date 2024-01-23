//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;

namespace CSETWebCore.Business.Merit
{
    public interface IJSONFileExport
    {
        void SendFileToMerit(string filename, string data, string uncPath);
        bool DoesDirectoryExist(string uncPath);
        bool DoesFileExist(string filename, string uncPath);
        public Guid GetAssessmentGuid(int assessId, CSETContext context);
        public void SetNewAssessmentGuid(int assessId, Guid newGuid, CSETContext context);
        public string GetUncPath(CSETContext context);
        public void SaveUncPath(string uncPath, CSETContext context);


    }
}