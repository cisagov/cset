//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWebCore.DataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public static class ReferenceConverter
    {
        public static GEN_FILE ToGenFile(this IExternalDocument document)
        {
            var genFile = new GEN_FILE();
            genFile.Data = document.Data;
            genFile.Is_Uploaded = true;
            genFile.File_Size = document.FileSize;
            genFile.Title = document.Name;
            genFile.Name = document.ShortName;
            genFile.Doc_Num = document.ShortName;
            genFile.Short_Name = document.ShortName;
            genFile.File_Name = document.FileName;
            return genFile;
        }
        public static ExternalDocument ToExternalDocument(this GEN_FILE genFile)
        {
            var document = new ExternalDocument();
            document.Data = genFile.Data;
            document.FileSize = genFile.File_Size;
            document.Name = genFile.Title;
            document.ShortName = genFile.Doc_Num;
            document.FileName = genFile.File_Name;
            return document;
        }
    }
}


