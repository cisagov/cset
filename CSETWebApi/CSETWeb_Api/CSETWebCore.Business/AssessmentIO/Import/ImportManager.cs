//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.ImportAssessment.Models.Version_10_1;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Interfaces;
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
using System.Web;
using System.Xml;
using CSETWebCore.Helpers;
using CSETWebCore.Business.Diagram;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.StaticFiles;


namespace CSETWebCore.Business.AssessmentIO.Import
{
    public class ImportManager
    {
        private TokenManager _token;
        private AssessmentUtil _assessmentUtil;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        public ImportManager(TokenManager token, AssessmentUtil assessmentUtil)
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
                        var genFile = context.GEN_FILE.FirstOrDefault(s => s.File_Name == doc);
                        if (genFile == null)
                        {
                            StreamReader docReader = new StreamReader(zip.GetEntry(doc + ".json").Open());
                            var docModel = JsonConvert.DeserializeObject<ExternalDocument>(docReader.ReadToEnd());
                            genFile = ReferenceConverter.ToGenFile(docModel);
                            var extension = Path.GetExtension(genFile.File_Name).Substring(1);
                            genFile.File_Type_ = context.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefault();

                            try
                            {
                                context.FILE_REF_KEYS.Add(new FILE_REF_KEYS { Doc_Num = genFile.Doc_Num });
                                await context.SaveChangesAsync();
                            }
                            catch (Exception e)
                            {
                                throw e;
                            }
                            context.GEN_FILE.Add(genFile);
                            context.SaveChanges();
                        }
                    }

                    foreach (var standard in model.CustomStandards)
                    {
                        var sets = context.SETS.Where(s => s.Set_Name.Contains(standard)).ToList();
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
                                context.SETS.Add(setResult.Result);

                                foreach (var question in setResult.Result.NEW_REQUIREMENT.SelectMany(s => s.NEW_QUESTIONs()).Where(s => s.Question_Id != 0).ToList())
                                {
                                    context.Entry(question).State = EntityState.Unchanged;
                                }
                                try
                                {
                                    await context.SaveChangesAsync();
                                }
                                catch (Exception e)
                                {
                                    throw (e);
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
                    int newAssessmentId = import.RunImportManualPortion(model, currentUserId, email, context, _token, _assessmentUtil);
                    import.RunImportAutomatic(newAssessmentId, jsonObject, context);



                    // Save the diagram
                    var assessment = context.ASSESSMENTS.Where(x => x.Assessment_Id == newAssessmentId).FirstOrDefault();
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



                    // Clean up any imported standards that are unselected or deprecated
                    var unselectedStandards = context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == newAssessmentId && !x.Selected).ToList();
                    context.AVAILABLE_STANDARDS.RemoveRange(unselectedStandards);
                    var deprecatedStandards = from av in context.AVAILABLE_STANDARDS
                                              join set in context.SETS on av.Set_Name equals set.Set_Name
                                              where set.Is_Deprecated
                                              select av;
                    context.AVAILABLE_STANDARDS.RemoveRange(deprecatedStandards.ToList());
                    context.SaveChanges();


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
                catch (Exception e)
                {
                    throw e;
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
        public async Task LaunchLegacyCSETProcess(string csetFilePath, string token, string processPath, string apiURL)
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
