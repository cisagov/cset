//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.ImportAssessment.Models.Version_10_1;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Model.Diagram;
using log4net;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    public class ImportManager
    {
        private ITokenManager _token;
        private IAssessmentUtil _assessmentUtil;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        public ImportManager(ITokenManager token, IAssessmentUtil assessmentUtil)
        {
            this._token = token;
            this._assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="zipFileFromDatabase"></param>
        /// <param name="currentUserId"></param>
        /// <returns></returns>
        public async Task ProcessCSETAssessmentImport(byte[] zipFileFromDatabase, int currentUserId, CSETContext context)
        {
            //* read from db and set as memory stream here.
            using (Stream fs = new MemoryStream(zipFileFromDatabase))
            {
                ZipArchive zip = new ZipArchive(fs);
                StreamReader r = new StreamReader(zip.GetEntry("model.json").Open());
                string jsonObject = r.ReadToEnd();

                // Apply any data updates to older versions
                ImportUpgradeManager upgrader = new ImportUpgradeManager();
                jsonObject = upgrader.Upgrade(jsonObject);


                try
                {
                    UploadAssessmentModel model = (UploadAssessmentModel)JsonConvert.DeserializeObject(jsonObject, new UploadAssessmentModel().GetType());

                    foreach (var doc in model.CustomStandardDocs)
                    {
                        var genFile = await context.GEN_FILE.FirstOrDefaultAsync(s => s.File_Name == doc);
                        if (genFile == null)
                        {
                            StreamReader docReader = new StreamReader(zip.GetEntry(doc + ".json").Open());
                            var docModel = JsonConvert.DeserializeObject<ExternalDocument>(docReader.ReadToEnd());
                            genFile = ReferenceConverter.ToGenFile(docModel);
                            var extension = Path.GetExtension(genFile.File_Name).Substring(1);
                            genFile.File_Type = await context.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefaultAsync();

                            try
                            {
                                await context.FILE_REF_KEYS.AddAsync(new FILE_REF_KEYS { Doc_Num = genFile.Doc_Num });
                                await context.SaveChangesAsync();
                            }
                            catch (Exception exc)
                            {
                                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

                                throw;
                            }

                            await context.GEN_FILE.AddAsync(genFile);
                            await context.SaveChangesAsync();
                        }
                    }

                    foreach (var standard in model.CustomStandards)
                    {
                        var sets = await context.SETS.Where(s => s.Set_Name.Contains(standard)).ToListAsync();
                        SETS set = null;
                        StreamReader setReader = new StreamReader(zip.GetEntry(standard + ".json").Open());
                        var setJson = setReader.ReadToEnd();
                        var setModel = JsonConvert.DeserializeObject<ExternalStandard>(setJson);
                        var originalSetName = setModel.shortName;
                        foreach (var testSet in sets)
                        {
                            setModel.shortName = testSet.Short_Name;
                            var testSetJson = JsonConvert.SerializeObject(testSet.ToExternalStandard(), Newtonsoft.Json.Formatting.Indented);
                            if (testSetJson == setJson)
                            {
                                set = testSet;
                                break;
                            }
                            else
                            {
                                setModel.shortName = originalSetName;
                            }
                        }

                        if (set == null)
                        {
                            int incr = 1;
                            while (sets.Any(s => s.Short_Name == setModel.shortName))
                            {
                                setModel.shortName = originalSetName + " " + incr;
                                incr++;
                            }
                            var setResult = await setModel.ToSet();
                            if (setResult.IsSuccess)
                            {
                                await context.SETS.AddAsync(setResult.Result);

                                foreach (var question in setResult.Result.NEW_REQUIREMENT.SelectMany(s => s.NEW_QUESTIONs()).Where(s => s.Question_Id != 0).ToList())
                                {
                                    context.Entry(question).State = EntityState.Unchanged;
                                }
                                try
                                {
                                    await context.SaveChangesAsync();
                                }
                                catch (Exception exc)
                                {
                                    log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

                                    throw;
                                }

                                //Set the GUID at time of export so we are sure it's right!!!
                                model.jANSWER = model.jANSWER.Where(s => s.Is_Requirement).GroupJoin(setResult.Result.NEW_REQUIREMENT, s => s.Custom_Question_Guid, req => new Guid(new MD5CryptoServiceProvider().ComputeHash(Encoding.Default.GetBytes(originalSetName + "|||" + req.Requirement_Title + "|||" + req.Requirement_Text))).ToString(), (erea, s) =>
                                {
                                    var req = s.FirstOrDefault();
                                    if (req != null)
                                    {
                                        erea.Question_Or_Requirement_Id = req.Requirement_Id;
                                    }
                                    return erea;
                                }).Concat(model.jANSWER.Where(s => !s.Is_Requirement).GroupJoin(setResult.Result.NEW_QUESTION, s => s.Custom_Question_Guid, req => new Guid(new MD5CryptoServiceProvider().ComputeHash(Encoding.Default.GetBytes(req.Simple_Question))).ToString(), (erer, s) =>
                                {
                                    var req = s.FirstOrDefault();
                                    if (req != null)
                                    {
                                        erer.Question_Or_Requirement_Id = req.Question_Id;
                                    }
                                    return erer;
                                })).ToList();
                            }
                        }

                        foreach (var availableStandard in model.jAVAILABLE_STANDARDS.Where(s => s.Set_Name == Regex.Replace(originalSetName, @"\W", "_") && s.Selected))
                        {
                            availableStandard.Set_Name = Regex.Replace(setModel.shortName, @"\W", "_");
                        }
                    }

                    string email = context.USERS.Where(x => x.UserId == currentUserId).First().PrimaryEmail;



                    Importer import = new Importer();
                    int newAssessmentId = await import.RunImportManualPortion(model, currentUserId, email, context, _token, _assessmentUtil);
                    import.RunImportAutomatic(newAssessmentId, jsonObject, context);



                    // Save the diagram
                    var assessment = await context.ASSESSMENTS.Where(x => x.Assessment_Id == newAssessmentId).FirstOrDefaultAsync();
                    if (!string.IsNullOrEmpty(assessment.Diagram_Markup))
                    {
                        var diagramManager = new DiagramManager(context);
                        var diagReq = new DiagramRequest()
                        {
                            DiagramXml = assessment.Diagram_Markup,
                            AnalyzeDiagram = false,
                            revision = false
                        };
                        var xDocDiagram = new XmlDocument();
                        xDocDiagram.LoadXml(assessment.Diagram_Markup);
                        diagramManager.SaveDiagram(newAssessmentId, xDocDiagram, diagReq);
                    }



                    // Clean up any imported standards that are unselected
                    var unselectedStandards = await context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == newAssessmentId && !x.Selected).ToListAsync();
                    context.AVAILABLE_STANDARDS.RemoveRange(unselectedStandards);
                    await context.SaveChangesAsync();


                    //NOTE THAT THIS ENTRY WILL ONLY COME FROM A OLD .cset file 
                    //IMPORT
                    ZipArchiveEntry importLegacyDiagram = zip.GetEntry("Diagram.csetd");
                    if (importLegacyDiagram != null)
                    {
                        StreamReader ldr = new StreamReader(importLegacyDiagram.Open());
                        string oldXml = ldr.ReadToEnd();
                        DiagramManager dm = new DiagramManager(context);
                        dm.ImportOldCSETDFile(oldXml, newAssessmentId);
                    }
                }
                catch (Exception exc)
                {
                    log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

                    throw;
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="entry"></param>
        /// <param name="doc"></param>
        private void SaveFileToDB(ZipArchiveEntry entry, DOCUMENT_FILE doc)
        {
            var stream = entry.Open();

            // determine the content type
            var provider = new FileExtensionContentTypeProvider();
            string contentType;
            if (!provider.TryGetContentType(entry.FullName, out contentType))
            {
                contentType = "application/octet-stream";
            }


            string fileHash;
            byte[] bytes;
            using (var ms = new MemoryStream())
            {
                stream.CopyTo(ms);
                bytes = ms.ToArray();
            }
            // Hash the file so that we can determine if it is already attached to another question
            using (var md5 = MD5.Create())
            {
                var hash = md5.ComputeHash(bytes);
                fileHash = BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
            }
            doc.UpdatedTimestamp = DateTime.Now;
            doc.ContentType = contentType;
            doc.Name = entry.Name;
            doc.Data = bytes;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="csetFilePath"></param>
        /// <param name="token"></param>
        /// <param name="processPath"></param>
        /// <param name="apiURL"></param>
        /// <returns></returns>
        public void LaunchLegacyCSETProcess(string csetFilePath, string token, string processPath, string apiURL)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("\"" + csetFilePath + "\" ");
            sb.Append(token ?? "test");
            sb.Append(" " + apiURL);
            string varargs = sb.ToString();
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = processPath,
                    Arguments = varargs,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };
            process.Start();
            process.WaitForExit();// Waits here for the process to exit.
        }
    }
}
