//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Demographic.DemographicIO;
using CSETWebCore.Business.Demographic.DemographicIO.Models;
using CSETWebCore.DataLayer.Model;
using Nelibur.ObjectMapper;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;


namespace CSETWebCore.Business.Demographic.Export
{
    public class DemographicsExportManager
    {
        private readonly CSETContext _context;

        /// <summary>
        /// Some screen items stored in DETAILS_DEMOGRAPHICS are not presented on the UI as "demographics" 
        /// and importing/overwriting their values could be confusing to the user.  
        /// </summary>
        private readonly List<string> _detailsDemographicsNotExported = new List<string>() { "ORG-POC", "SELF-ASSESS", "TECH-DOMAIN" };


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public DemographicsExportManager(CSETContext context)
        {
            this._context = context;

            SetupBindings();
        }


        /// <summary>
        /// 
        /// </summary>
        private void SetupBindings()
        {
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION, jCIS_CSI_SERVICE_COMPOSITION>();
            TinyMapper.Bind<CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS, jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS>();
            TinyMapper.Bind<CIS_CSI_SERVICE_DEMOGRAPHICS, jCIS_CSI_SERVICE_DEMOGRAPHICS>();
            TinyMapper.Bind<DETAILS_DEMOGRAPHICS, jDETAILS_DEMOGRAPHICS>();
            TinyMapper.Bind<ASSESSMENT_SECTOR_SUBSECTOR, jASSESSMENT_SECTOR_SUBSECTOR>();
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

            foreach (var item in _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId))
            {
                // do not include some values - not considered part of a demographics export
                if (_detailsDemographicsNotExported.Contains(item.DataItemName))
                {
                    continue;
                }

                model.jDETAILS_DEMOGRAPHICS.Add(TinyMapper.Map<DETAILS_DEMOGRAPHICS, jDETAILS_DEMOGRAPHICS>(item));
            }

            foreach (var item in _context.ASSESSMENT_SECTOR_SUBSECTOR.Where(x => x.Assessment_Id == assessmentId).OrderBy(x => x.Sequence))
            {
                model.jASSESSMENT_SECTOR_SUBSECTOR.Add(TinyMapper.Map<ASSESSMENT_SECTOR_SUBSECTOR, jASSESSMENT_SECTOR_SUBSECTOR>(item));
            }

            return model;
        }


        /// <summary>
        /// Gathers the data for an assessment demographic and returns a .json file.
        /// The filename will be that of the Facility Name, if known.
        /// </summary>
        private Stream ArchiveStream(int assessmentId)
        {
            var model = CopyForExport(assessmentId);
            var json = JsonConvert.SerializeObject(model, Formatting.Indented);

            // Write the JSON content to the MemoryStream
            byte[] bytes = Encoding.UTF8.GetBytes(json);
            var archiveStream = new MemoryStream();
            archiveStream.Write(bytes, 0, bytes.Length);

            // Reset the position of the stream to the beginning
            archiveStream.Seek(0, SeekOrigin.Begin);

            return archiveStream;
        }


        /// <summary>
        /// Export an assessment by its ID. 
        /// </summary>
        /// <param name="assessmentId">The ID of the assessment to export</param>
        /// <param name="fileExtension">The extension of the export file</param>
        /// <returns>An DemographicsExportFile object containing the file name and the file contents</returns>
        public DemographicsExportFile ExportDemographics(int assessmentId)
        {
            // determine file name
            var fileName = $"Organization - CSET demographics.json";

            var facilityName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Facility_Name;
            if (!string.IsNullOrEmpty(facilityName))
            {
                fileName = $"{facilityName} - CSET demographics.json";
            }

            // export the assessment
            Stream assessmentFileContents = ArchiveStream(assessmentId);

            return new DemographicsExportFile(fileName, assessmentFileContents);
        }
    }
}
