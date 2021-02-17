//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Helpers.upload
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
