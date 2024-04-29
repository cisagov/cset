//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.Helpers;
using Ionic.Zip;
using Microsoft.IdentityModel.Tokens;
using CSETWebCore.Business.Demographic.DemographicIO.Models;
using CSETWebCore.Business.Demographic.DemographicIO; 



namespace CSETWebCore.Business.Demographic.Export
{
    public class DemographicsExportManager
    {
        private readonly CSETContext _context;
        private readonly IDictionary<int, string> demographics;

        public DemographicsExportManager(CSETContext context)
        {
            this._context = context;

            demographics = _context.DEMOGRAPHICS.Select(t => new { t.Assessment_Id, t.OrganizationName })
                .ToDictionary(t => t.Assessment_Id, t => t.OrganizationName);

            SetupBindings();
        }

        private void SetupBindings()
        {
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION, jCIS_CSI_SERVICE_COMPOSITION>();
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS, jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS>();
            TinyMapper.Bind<CIS_CSI_SERVICE_DEMOGRAPHICS, jCIS_CSI_SERVICE_DEMOGRAPHICS>();
            TinyMapper.Bind<DEMOGRAPHICS, jDEMOGRAPHICS>();
            TinyMapper.Bind<DETAILS_DEMOGRAPHICS, jDETAILS_DEMOGRAPHICS>();
        }


        ///// <summary>
        ///// 
        ///// </summary>
        ///// <param name="assessmentId"></param>
        ///// <returns></returns>
        private UploadDemographicsModel CopyForExport(int assessmentId)
        {
            var model = new UploadDemographicsModel();

            foreach (var item in _context.CIS_CSI_SERVICE_COMPOSITION.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jCIS_CSI_SERVICE_COMPOSITION.Add(TinyMapper.Map<CIS_CSI_SERVICE_COMPOSITION, jCIS_CSI_SERVICE_COMPOSITION>(item));

            }

            foreach (var item in _context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Add(TinyMapper.Map<CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS, jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS>(item));

            }

            foreach (var item in _context.CIS_CSI_SERVICE_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jCIS_CSI_SERVICE_DEMOGRAPHICS.Add(TinyMapper.Map<CIS_CSI_SERVICE_DEMOGRAPHICS, jCIS_CSI_SERVICE_DEMOGRAPHICS>(item));

            }

            foreach (var item in _context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jDEMOGRAPHICS.Add(TinyMapper.Map<DEMOGRAPHICS, jDEMOGRAPHICS>(item));
            }


            return model;
        }


        /// <summary>
        /// Gathers the data for an assessment and returns a model.json file, along with any attached documents.
        /// If desired, only the model.json will be returned, named to match the assessment name.
        /// </summary>
        private Stream ArchiveStream(int assessmentId)
        {
            var archiveStream = new MemoryStream();
            var model = CopyForExport(assessmentId);

            //using (var archive = new ZipFile())
            //{
            //    if (password != null && password != "")
            //    {
            //        archive.Password = password;
            //    }

            //    foreach (var standard in model.jAVAILABLE_STANDARDS)
            //    {
            //        if (!standard.Selected)
            //        {
            //            continue;
            //        }

            //        var set = _context.SETS
            //            .Include(s => s.Set_Category)
            //            .Where(s => s.Set_Name == standard.Set_Name).FirstOrDefault();
            //        if (set == null || !set.Is_Custom)
            //        {
            //            continue;
            //        }


            //        var qq = from nq in _context.NEW_QUESTION
            //                 join nqs in _context.NEW_QUESTION_SETS on nq.Question_Id equals nqs.Question_Id
            //                 where nqs.Set_Name == standard.Set_Name
            //                 select nq;

            //        var questions = qq.ToList();
            //        set.NEW_QUESTION = new List<NEW_QUESTION>(questions);


            //        var rq = _context.REQUIREMENT_SETS
            //            .Include(s => s.Requirement)
            //            .ThenInclude(s => s.REQUIREMENT_LEVELS)
            //            .Where(s => s.Set_Name == standard.Set_Name)
            //            .Select(s => s.Requirement);

            //        set.NEW_REQUIREMENT = new List<NEW_REQUIREMENT>(rq.ToList());



            //        var extStandard = StandardConverter.ToExternalStandard(set, _context);
            //        var setname = Regex.Replace(extStandard.shortName, @"\W", "_");

            //        // Export Set
            //        //var standardEntry = archive.CreateEntry($"{setname}.json");
            //        var jsonStandard = JsonConvert.SerializeObject(extStandard, Formatting.Indented);

            //        ZipEntry standardEntry = archive.AddEntry($"{setname}.json", jsonStandard);


            //        //Set the GUID at time of export so we are sure it's right!!!
            //        model.jANSWER = model.jANSWER.Where(s => s.Is_Requirement).GroupJoin(set.NEW_REQUIREMENT, s => s.Question_Or_Requirement_Id, s => s.Requirement_Id, (t, s) =>
            //        {
            //            var req = s.FirstOrDefault();
            //            if (req != null)
            //            {
            //                var buffer = Encoding.Default.GetBytes($"{extStandard.shortName}|||{req.Requirement_Title}|||{req.Requirement_Text}");
            //                t.Custom_Question_Guid = new Guid(MD5.Create().ComputeHash(buffer)).ToString();
            //            }
            //            return t;
            //        }).Concat(model.jANSWER.Where(s => !s.Is_Requirement).GroupJoin(questions, s => s.Question_Or_Requirement_Id, s => s.Question_Id, (t, s) =>
            //        {
            //            var req = s.FirstOrDefault();
            //            if (req != null)
            //            {
            //                var buffer = Encoding.Default.GetBytes(req.Simple_Question);
            //                t.Custom_Question_Guid = new Guid(MD5.Create().ComputeHash(buffer)).ToString();
            //            }
            //            return t;
            //        })).ToList();

            //        model.CustomStandards.Add(setname);



            //        // if doing a full export, include documents/artifacts
            //        if (!jsonOnly)
            //        {
            //            var files = extStandard.requirements.SelectMany(s => s.references.Concat(new ExternalResource[] { s.source })).OfType<ExternalResource>().Distinct();
            //            foreach (var file in files)
            //            {
            //                var genFile = _context.GEN_FILE.FirstOrDefault(s => s.File_Name == file.fileName && (s.Is_Uploaded));
            //                if (genFile == null || model.CustomStandardDocs.Contains(file.fileName))
            //                    continue;

            //                var doc = genFile.ToExternalDocument();
            //                var jsonDoc = JsonConvert.SerializeObject(doc, Formatting.Indented);

            //                ZipEntry docEntry = archive.AddEntry($"{doc.ShortName}.json", jsonDoc);

            //                model.CustomStandardDocs.Add(file.fileName);
            //            }
            //        }
            //    }


            //    model.ExportDateTime = DateTime.UtcNow;

            //    var json = JsonConvert.SerializeObject(model, Formatting.Indented);


            //    if (jsonOnly)
            //    {
            //        // Write only the JSON portion as a stand-alone file to the stream
            //        byte[] bytes = Encoding.UTF8.GetBytes(json);
            //        archiveStream.Write(bytes, 0, bytes.Length);
            //    }
            //    else
            //    {
            //        // Write the ZIP file with the JSON and any artifacts attached.
            //        ZipEntry jsonEntry = archive.AddEntry("model.json", json);
            //        ZipEntry hint = archive.AddEntry($"{passwordHint}.hint", passwordHint);
            //        archive.Save(archiveStream);
            //    }
            //}


            archiveStream.Seek(0, SeekOrigin.Begin);
            return archiveStream;
        }


        /// <summary>
        /// Export an assessment by its ID. 
        /// Can optionally provide a password and password hint that will be used during import process.
        /// </summary>
        /// <param name="assessmentId">The ID of the assessment to export</param>
        /// <param name="fileExtension">The extension of the export file</param>
        /// <param name="password">If not empty, this password will be required to import the assessment</param>
        /// <param name="passwordHint">An optional password hint</param>
        /// <returns>An AssessmentExportFile object containing the file name and the file contents</returns>
        public DemographicsExportFile ExportDemographics(int assessmentId, string fileExtension)
        {
            // determine file name
            var fileName = $"{assessmentId}{fileExtension}";
            var assessmentName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
            if (!string.IsNullOrEmpty(assessmentName))
            {
                fileName = $"{assessmentName}{fileExtension}";
            }

            // export the assessment
            Stream assessmentFileContents = ArchiveStream(assessmentId);

            // mark the assessment as clean after export
            var assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            assessment.ModifiedSinceLastExport = false;
            _context.SaveChanges();

            return new DemographicsExportFile(fileName, assessmentFileContents);
        }


        
    }
}
