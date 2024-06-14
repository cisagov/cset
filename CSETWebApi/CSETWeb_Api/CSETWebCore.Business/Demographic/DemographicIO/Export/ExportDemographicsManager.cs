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

            SetupBindings();
        }

        private void SetupBindings()
        {
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION, jCIS_CSI_SERVICE_COMPOSITION>();
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS, jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS>();
            TinyMapper.Bind<CIS_CSI_SERVICE_DEMOGRAPHICS, jCIS_CSI_SERVICE_DEMOGRAPHICS>();
            TinyMapper.Bind<DEMOGRAPHICS, jDEMOGRAPHICS>();
            TinyMapper.Bind<DETAILS_DEMOGRAPHICS, jDETAILS_DEMOGRAPHICS>();
            TinyMapper.Bind<INFORMATION, jORG_DETAILS>();
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

            foreach (var item in _context.INFORMATION.Where(x => x.Id == assessmentId))
            {
                model.jORG_DETAILS.Add(TinyMapper.Map<INFORMATION, jORG_DETAILS>(item));
            }

            foreach (var item in _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId))
            {
                if (item.DataItemName == "ORG-POC")
                {
                    continue;
                }
                model.jDETAILS_DEMOGRAPHICS.Add(TinyMapper.Map<DETAILS_DEMOGRAPHICS, jDETAILS_DEMOGRAPHICS>(item));
            }

            return model;
        }


        /// <summary>
        /// Gathers the data for an assessment demographic and returns a model.json file.
        /// If desired, only the model.json will be returned, named to match the assessment name.
        /// </summary>
        private Stream ArchiveStream(int assessmentId)
        {
            var archiveStream = new MemoryStream();
            var model = CopyForExport(assessmentId);

            using (var archive = new ZipFile())
            {
                var json = JsonConvert.SerializeObject(model, Formatting.Indented);

                // Write only the JSON portion as a stand-alone file to the stream
                byte[] bytes = Encoding.UTF8.GetBytes(json);
                archiveStream.Write(bytes, 0, bytes.Length);

            }
            archiveStream.Seek(0, SeekOrigin.Begin);
            return archiveStream;
        }


        /// <summary>
        /// Export an assessment by its ID. 
        /// </summary>
        /// <param name="assessmentId">The ID of the assessment to export</param>
        /// <param name="fileExtension">The extension of the export file</param>
        /// <returns>An DemographicsExportFile object containing the file name and the file contents</returns>
        public DemographicsExportFile ExportDemographics(int assessmentId, string fileExtension)
        {
            // determine file name
            var fileName = $"{assessmentId}{fileExtension}";
            var facilityName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Facility_Name;
            if (!string.IsNullOrEmpty(facilityName))
            {
                fileName = $"{facilityName}{fileExtension}";
            }

            // export the assessment
            Stream assessmentFileContents = ArchiveStream(assessmentId);

            return new DemographicsExportFile(fileName, assessmentFileContents);
        }


        
    }
}
