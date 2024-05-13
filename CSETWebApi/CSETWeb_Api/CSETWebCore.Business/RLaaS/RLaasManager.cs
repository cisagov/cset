//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Document;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.RLaaS
{
    /// <summary>
    /// Resource Library as a Service Manager.
    /// </summary>
    public class RLaasManager
    {
        public CSETContext _context;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public RLaasManager(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// PUlls a document from the GEN_FILE record or a physical file
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ReferenceDocument GetDocument(string fileId)
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

            if (!files.Any()) 
            {
                return null;
            }

            var genFile = files.FirstOrDefault();

            var refDoc = new ReferenceDocument
            {
                GenFile = genFile.gf,
                FileType = genFile.ft
            };

            return refDoc;
        }




        public void StoreGenFileStream(string title, int answerId, FileUploadStreamResult result)
        {
            foreach (var file in result.FileResultList)
            {
                // first see if the document already exists on any question in this Assessment, based on the filename and hash
                var doc = _context.DOCUMENT_FILE.Where(f => f.FileMd5 == file.FileHash
                    && f.Name == file.FileName
                    && f.Assessment_Id == this.assessmentId).FirstOrDefault();

                if (doc == null)
                {
                    doc = new DOCUMENT_FILE()
                    {
                        Assessment_Id = this.assessmentId,
                        Title = string.IsNullOrWhiteSpace(title) ? "click to edit title" : title,
                        Path = file.FileName,  // this may end up being some other reference
                        Name = file.FileName,
                        FileMd5 = file.FileHash,
                        ContentType = file.ContentType,
                        CreatedTimestamp = DateTime.Now,
                        UpdatedTimestamp = DateTime.Now,
                        Data = file.FileBytes
                    };

                }
                else
                {
                    doc.Title = string.IsNullOrWhiteSpace(title) ? doc.Title : title;
                    doc.Name = file.FileName;
                }

                var answer = _context.ANSWER.Where(a => a.Answer_Id == answerId).FirstOrDefault();
                _context.DOCUMENT_FILE.Update(doc);
                _context.SaveChanges();

                DOCUMENT_ANSWERS temp = new DOCUMENT_ANSWERS() { Answer_Id = answer.Answer_Id, Document_Id = doc.Document_Id };
                if (_context.DOCUMENT_ANSWERS.Find(temp.Document_Id, temp.Answer_Id) == null)
                {
                    _context.DOCUMENT_ANSWERS.Add(temp);
                }
                else
                {
                    _context.DOCUMENT_ANSWERS.Update(temp);
                }

                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(doc.Assessment_Id);
            }

        }
    }
}
