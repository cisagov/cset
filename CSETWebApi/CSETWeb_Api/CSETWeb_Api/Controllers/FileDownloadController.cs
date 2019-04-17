//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.ImportAssessment.Export;
using CSETWeb_Api.Helpers;
using DataAccess;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    public class FileDownloadController : ApiController
    {
        private FileRepository _fileRepository;

        public FileDownloadController()
        {
            this._fileRepository = new FileRepository();
        }

        [Route("api/files/download/{id}")]
        [HttpGet]
        public HttpResponseMessage Download(int id, string token)
        {
            int assessmentId = Auth.AssessmentForUser(token);
            var fileDescription = _fileRepository.GetFileDescription(id);


            var result = new HttpResponseMessage(HttpStatusCode.OK);

            using (CSET_Context context = new CSET_Context())
            {
                foreach (DOCUMENT_FILE f in context.DOCUMENT_FILE.Where(x => x.Document_Id == id))
                {
                    var stream = new MemoryStream(f.Data);
                    result.Content = new StreamContent(stream);
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue(f.ContentType);
                    result.Content.Headers.Add("content-disposition", "attachment; filename=\"" + f.Name + "\"");
                    return result;
                }
            }

            return null;
        }

        [Route("api/files/export")]
        [HttpGet]
        public HttpResponseMessage Download(string token)
        {
            int _assessmentId = Auth.AssessmentForUser(token);
            var result = new HttpResponseMessage(HttpStatusCode.OK);
            string filename = ".csetw";
            using (CSET_Context context = new CSET_Context())
            {
                string assessmentName = context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault().Assessment_Name;
                if (assessmentName != null)
                    filename = assessmentName + filename;
                ExportAssessment export = new ExportAssessment(context);
                var exportCopy = export.CopyForExport(_assessmentId);

                MemoryStream zipToOpen = new MemoryStream();

                ZipArchive archive = new ZipArchive(zipToOpen, ZipArchiveMode.Create, true);
                foreach (var standard in exportCopy.jAVAILABLE_STANDARDS)
                {
                    var set = context.SETS
                        .Include(s => s.NEW_QUESTION)
                        .Include(s => s.NEW_REQUIREMENT)
                        .Include(s => s.Set_Category_)
                        .FirstOrDefault(s => s.Set_Name == standard.Set_Name && standard.Selected);
                    if (set != null)
                        if (set.Is_Custom)
                        {
                            //Export Set
                            var externalSet = set.ToExternalStandard();
                            var setname = Regex.Replace(externalSet.ShortName, @"\W", "_");
                            ZipArchiveEntry standardEntry = archive.CreateEntry(setname + ".json");
                            string jsonStandard = JsonConvert.SerializeObject(externalSet, Formatting.Indented);
                            using (StreamWriter writer = new StreamWriter(standardEntry.Open()))
                            {
                                writer.Write(jsonStandard);
                                writer.Close();
                            }
                            //Set the GUID at time of export so we are sure it's right!!!
                            exportCopy.jANSWER = exportCopy.jANSWER.Where(s => s.Is_Requirement).GroupJoin(set.NEW_REQUIREMENT, s => s.Question_Or_Requirement_Id, s => s.Requirement_Id, (t, s) =>
                                   {
                                       var req = s.FirstOrDefault();
                                       if (req != null)
                                       {
                                           t.Custom_Question_Guid = new Guid(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(Encoding.Default.GetBytes(externalSet.ShortName + "|||" + req.Requirement_Title + "|||" + req.Requirement_Text))).ToString();
                                       }
                                       return t;
                                   }).Concat(exportCopy.jANSWER.Where(s => !s.Is_Requirement).GroupJoin(set.NEW_QUESTION, s => s.Question_Or_Requirement_Id, s => s.Question_Id, (t, s) =>
                                   {
                                       var req = s.FirstOrDefault();
                                       if (req != null)
                                       {
                                           t.Custom_Question_Guid = new Guid(new System.Security.Cryptography.MD5CryptoServiceProvider().ComputeHash(Encoding.Default.GetBytes(req.Simple_Question))).ToString();
                                       }
                                       return t;
                                   })).ToList();
                            exportCopy.CustomStandards.Add(setname);
                            var files = externalSet.Requirements.SelectMany(s => s.References.Concat(new List<ExternalResource> { s.Source })).Distinct();
                            foreach (var file in files)
                            {
                                var genFile = context.GEN_FILE.FirstOrDefault(s => s.File_Name == file.FileName && s.Is_Uploaded == true);
                                if (genFile != null && !exportCopy.CustomStandardDocs.Any(s => s == file.FileName))
                                {
                                    var doc = genFile.ToExternalDocument();
                                    ZipArchiveEntry docEntry = archive.CreateEntry(doc.ShortName + ".json");
                                    string jsonDoc = JsonConvert.SerializeObject(doc, Formatting.Indented);
                                    using (StreamWriter writer = new StreamWriter(docEntry.Open()))
                                    {
                                        writer.Write(jsonDoc);
                                        writer.Close();
                                    }
                                    exportCopy.CustomStandardDocs.Add(file.FileName);
                                }
                            }

                        }
                }

                string json = JsonConvert.SerializeObject(exportCopy, Formatting.Indented);
                ZipArchiveEntry modelEntry = archive.CreateEntry("model.json");
                using (StreamWriter writer = new StreamWriter(modelEntry.Open()))
                {
                    writer.Write(json);
                    writer.Close();
                }
                foreach (var doc in context.DOCUMENT_FILE.Where(x => x.Assessment_Id == _assessmentId && x.Data != null))
                {
                    ZipArchiveEntry dest = archive.CreateEntry(doc.Path);
                    Stream destStream = dest.Open();
                    destStream.Write(doc.Data, 0, doc.Data.Length);
                    destStream.Close();
                }

                archive.Dispose();

                zipToOpen.Seek(0, SeekOrigin.Begin);
                result.Content = new StreamContent(zipToOpen);
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                result.Content.Headers.Add("content-disposition", "attachment; filename=\"" + filename + "\"");

                return result;



            }
        }
    }
}


