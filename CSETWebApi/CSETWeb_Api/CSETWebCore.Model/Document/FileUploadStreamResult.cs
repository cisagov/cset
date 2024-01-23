//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Document
{
    public class FileUploadStreamResult
    {
        public FileUploadStreamResult()
        {
            this.FileResultList = new List<FileUploadResult>();
            this.ErrorsList = new List<string>();
        }

        public Dictionary<string, string> FormNameValues { get; set; }
        public List<string> ErrorsList;

        public List<FileUploadResult> FileResultList { get; set; }
    }
}