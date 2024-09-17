//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.ResourceLibrary;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;


namespace CSETWebCore.Business.RepositoryLibrary
{
    public class ReferenceDocumentManager
    {
        private readonly CSETContext _context;
        private readonly IWebHostEnvironment _environment;
        private readonly IConfiguration _configuration;

        /// <summary>
        /// 
        /// </summary>
        public ReferenceDocumentManager(CSETContext context, IWebHostEnvironment environment, IConfiguration configuration)
        {
            _context = context;
            _environment = environment;
            _configuration = configuration;
        }


        /// <summary>
        /// Locates a reference document defined in the GEN_FILE table.  The identifier can be the 
        /// Gen_File_Id or the name of the physical file.
        /// 
        /// If a record is found, its binary Stream is returned if the Data column contains data.
        /// 
        /// If not, the physical file is found and returned as a Stream.
        /// </summary>
        /// <param name="fileId"></param>
        /// <returns></returns>
        public ReferenceFileResponse? FindLocalReferenceDocument(string fileId)
        {
            var hashLocation = fileId.IndexOf('#');
            if (hashLocation > -1)
            {
                fileId = fileId.Substring(0, hashLocation);
            }


            if (!int.TryParse(fileId, out int id))
            {
                // if the identifier is not an int, assume it's the filename, and get his gen_file_id
                var f = _context.GEN_FILE.Where(f => f.File_Name == fileId).FirstOrDefault();
                if (f != null)
                {
                    id = f.Gen_File_Id;
                }
            }

            var files = from gf in _context.GEN_FILE
                        join ft1 in _context.FILE_TYPE on gf.File_Type_Id equals ft1.File_Type_Id into tt
                        from ft in tt.DefaultIfEmpty()
                        where (gf.Gen_File_Id == id)
                        select new { gf, ft };

            var refDoc = files.FirstOrDefault();
            if (refDoc == null)
            {
                return null;
            }


            try
            {
                Stream stream;

                // use binary data if available, otherwise get physical file
                if (refDoc.gf.Data != null)
                {
                    stream = new MemoryStream(refDoc.gf.Data);
                }
                else
                {
                    var physicalDocPath = _configuration.GetValue<string>("RefDocPath") ?? "Documents";

                    var docPath = Path.Combine(_environment.ContentRootPath, physicalDocPath, refDoc.gf.File_Name);
                    stream = new FileStream(docPath, FileMode.Open, FileAccess.Read);
                }

                string filename = refDoc.gf.File_Name;


                // determine the contentType
                var contentType = "application/octet-stream";
                if (refDoc.ft != null && refDoc.ft.Mime_Type != null)
                {
                    contentType = refDoc.ft.Mime_Type;
                }
                else
                {
                    new FileExtensionContentTypeProvider()
                    .TryGetContentType(filename, out contentType);
                }


                return new ReferenceFileResponse() { Id = refDoc.gf.Gen_File_Id, FileName = filename, ContentType = contentType, Stream = stream };
            }
            catch (Exception ex)
            {
                NLog.LogManager.GetCurrentClassLogger().Error(ex);

                return null;
            }
        }


        /// <summary>
        /// Overwrites the GEN_FILE [Data] column with the contents of the Stream.
        /// </summary>
        /// <param name="genFileId"></param>
        /// <param name="stream"></param>
        public void SaveDataBuffer(int genFileId, Stream stream)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                var genfile = _context.GEN_FILE.Where(x => x.Gen_File_Id == genFileId).FirstOrDefault();
                if (genfile == null)
                {
                    return;
                }

                stream.CopyTo(ms);
                genfile.Data = ms.ToArray();
                _context.SaveChanges();
            }
        }
    }
}
