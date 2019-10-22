//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.ImportAssessment;
using CSETWeb_Api.BusinessLogic.ImportAssessment.Models.Version_9_0_1;
using CSETWeb_Api.BusinessManagers;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class ImportManager
    {

        public async Task ProcessCSETAssessmentImport(byte[] zipFileFromDatabase, int currentUserId)
        {
            using (CSET_Context context = new CSET_Context())
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


                    UploadAssessmentModel model = (UploadAssessmentModel)JsonConvert.DeserializeObject(jsonObject, new UploadAssessmentModel().GetType());
                    foreach (var doc in model.CustomStandardDocs)
                    {
                        var genFile = context.GEN_FILE.FirstOrDefault(s => s.File_Name == doc);
                        if (genFile == null)
                        {
                            StreamReader docReader = new StreamReader(zip.GetEntry(doc + ".json").Open());
                            var docModel = JsonConvert.DeserializeObject<ExternalDocument>(docReader.ReadToEnd());
                            genFile = docModel.ToGenFile();
                            var extension = Path.GetExtension(genFile.File_Name).Substring(1);
                            genFile.File_Type_ = context.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefault();

                            try
                            {
                                context.FILE_REF_KEYS.Add(new FILE_REF_KEYS { Doc_Num = genFile.Doc_Num });
                                await context.SaveChangesAsync();
                            }
                            catch
                            {
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
                        var originalSetName = setModel.ShortName;
                        foreach (var testSet in sets)
                        {
                            setModel.ShortName = testSet.Short_Name;
                            var testSetJson = JsonConvert.SerializeObject(testSet.ToExternalStandard(), Formatting.Indented);
                            if (testSetJson == setJson)
                            {
                                set = testSet;
                                break;
                            }
                            else
                            {
                                setModel.ShortName = originalSetName;
                            }
                        }
                        if (set == null)
                        {
                            int incr = 1;
                            while (sets.Any(s => s.Short_Name == setModel.ShortName))
                            {
                                setModel.ShortName = originalSetName + " " + incr;
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
                            availableStandard.Set_Name = Regex.Replace(setModel.ShortName, @"\W", "_");
                        }
                    }

                    string email = context.USERS.Where(x => x.UserId == currentUserId).First().PrimaryEmail;

                    Importer import = new Importer();
                    int newAssessmentId = import.RunImportManualPortion(model, currentUserId, email, context);
                    import.RunImportAutomatic(newAssessmentId, jsonObject, context);
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
            }
        }


        private void SaveFileToDB(ZipArchiveEntry entry, DOCUMENT_FILE doc)
        {
            var stream = entry.Open();
            string contentType2 = MimeMapping.GetMimeMapping(entry.FullName);
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
            doc.ContentType = contentType2;
            doc.Name = entry.Name;
            doc.Data = bytes;
        }

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
            //string output = process.StandardOutput.ReadToEnd();
            //Console.WriteLine("Output");
            //Console.WriteLine(output);
            //Console.WriteLine("Error");
            //string error = process.StandardError.ReadToEnd();
            //Console.WriteLine(error);
            process.WaitForExit();// Waits here for the process to exit.
        }
    }
}


