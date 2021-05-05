//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWebCore.DataLayer;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public class DocumentImporter
    {
        public DocumentImporter()
        {
        }
        public void Import(IExternalDocument document)
        {
            var http = new HttpClient();

        }
        public async Task ImportAsync(IExternalDocument document)
        {
            //var genFile = new GEN_FILE();
            //genFile.Title = document.Name;
            //genFile.Short_Name = document.ShortName;
            //genFile.Name = document.ShortName;
            //genFile.Doc_Num = document.ShortName;
            //using (var http = new HttpClient())
            //{
            //    var docFile = await http.GetAsync(document.Uri);
            //    genFile.File_Name = docFile.Content.Headers.ContentDisposition.FileName;
            //    if (genFile.File_Name == null)
            //    {
            //        var uri = new Uri(document.Uri);
            //        if (uri.IsFile)
            //        {
            //            genFile.File_Name = Path.GetFileName(uri.LocalPath);
            //        }
            //    }
            //    using(var db=new CSET_Context())
            //    {
            //        genFile.File_Size = docFile.Content.Headers.ContentLength;
            //        var extension = Path.GetExtension(genFile.File_Name);
            //        genFile.FILE_TYPE = db.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefault();
            //        genFile.Data = await docFile.Content.ReadAsByteArrayAsync();
            //        genFile.Is_Uploaded = true;
            //        db.GEN_FILE.Add(genFile);
            //        await db.SaveChangesAsync();

            //    }
            //    return;
            //}

        }

        

        public GEN_FILE LookupGenFile(string p)
        {
            GEN_FILE gf;
            using (var db = new CSET_Context())
            { 
               gf  = (from h in db.GEN_FILE
                      where h.File_Name == p
                      orderby h.Gen_File_Id descending
                      select h).FirstOrDefault();

            }
            return gf;
        }

        internal int LookupGenFileId(string fileName)
        {            
            using (var db = new CSET_Context())

            {
                GEN_FILE gf = (from h in db.GEN_FILE
                      where h.File_Name == fileName
                      orderby h.Gen_File_Id descending
                      select h).FirstOrDefault();
                if (gf == null)
                    return 0;
                return gf.Gen_File_Id;
            }
            
        }
    }
}


