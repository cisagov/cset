//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.ImportAssessment.Models.Version_9_2;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace CSETWeb_Api.BusinessLogic.AssessmentIO.Export
{
    public class AssessmentExportManager
    {
        private readonly CSET_Context context;
        private readonly IDictionary<int, string> questionGroupHeadings;
        private readonly IDictionary<int, string> universalSubHeadings;

        public AssessmentExportManager(CSET_Context context)
        {
            this.context = context;

            questionGroupHeadings = context.QUESTION_GROUP_HEADING.Select(t => new { t.Question_Group_Heading_Id, t.Question_Group_Heading1 })
                .ToDictionary(t => t.Question_Group_Heading_Id, t => t.Question_Group_Heading1);

            universalSubHeadings = context.UNIVERSAL_SUB_CATEGORIES.Select(t => new { t.Universal_Sub_Category_Id, t.Universal_Sub_Category })
                .ToDictionary(t => t.Universal_Sub_Category_Id, t => t.Universal_Sub_Category);

            SetupBindings();
        }

        private void SetupBindings()
        {
            TinyMapper.Bind<ADDRESS, jADDRESS>();
            TinyMapper.Bind<ANSWER, jANSWER>();
            TinyMapper.Bind<ASSESSMENTS, jASSESSMENTS>();
            TinyMapper.Bind<ASSESSMENTS_REQUIRED_DOCUMENTATION, jASSESSMENTS_REQUIRED_DOCUMENTATION>();
            TinyMapper.Bind<ASSESSMENTS_REQUIRED_DOCUMENTATION, jASSESSMENTS_REQUIRED_DOCUMENTATION>();
            TinyMapper.Bind<ASSESSMENT_CONTACTS, jASSESSMENT_CONTACTS>();
            TinyMapper.Bind<ASSESSMENT_DIAGRAM_COMPONENTS, jASSESSMENT_DIAGRAM_COMPONENTS>();
            TinyMapper.Bind<ASSESSMENT_DIAGRAM_COMPONENTS, jASSESSMENT_DIAGRAM_COMPONENTS>();
            TinyMapper.Bind<ASSESSMENT_IRP, jASSESSMENT_IRP>();
            TinyMapper.Bind<ASSESSMENT_IRP, jASSESSMENT_IRP>();
            TinyMapper.Bind<ASSESSMENT_IRP_HEADER, jASSESSMENT_IRP_HEADER>();
            TinyMapper.Bind<ASSESSMENT_IRP_HEADER, jASSESSMENT_IRP_HEADER>();
            TinyMapper.Bind<ASSESSMENT_SELECTED_LEVELS, jASSESSMENT_SELECTED_LEVELS>();
            TinyMapper.Bind<AVAILABLE_STANDARDS, jAVAILABLE_STANDARDS>();
            TinyMapper.Bind<CNSS_CIA_JUSTIFICATIONS, jCNSS_CIA_JUSTIFICATIONS>();
            TinyMapper.Bind<CSET_VERSION, jCSET_VERSION>();
            TinyMapper.Bind<CUSTOM_BASE_STANDARDS, jCUSTOM_BASE_STANDARDS>();
            TinyMapper.Bind<CUSTOM_QUESTIONAIRES, jCUSTOM_QUESTIONAIRES>();
            TinyMapper.Bind<CUSTOM_QUESTIONAIRE_QUESTIONS, jCUSTOM_QUESTIONAIRE_QUESTIONS>();
            TinyMapper.Bind<DEMOGRAPHICS, jDEMOGRAPHICS>();
            TinyMapper.Bind<DIAGRAM_CONTAINER, jDIAGRAM_CONTAINER>();
            TinyMapper.Bind<DIAGRAM_CONTAINER, jDIAGRAM_CONTAINER>();
            TinyMapper.Bind<DOCUMENT_ANSWERS, jDOCUMENT_ANSWERS>();
            TinyMapper.Bind<DOCUMENT_FILE, jDOCUMENT_FILE>();
            TinyMapper.Bind<FINANCIAL_ASSESSMENT_VALUES, jFINANCIAL_ASSESSMENT_VALUES>();
            TinyMapper.Bind<FINANCIAL_ASSESSMENT_VALUES, jFINANCIAL_ASSESSMENT_VALUES>();
            TinyMapper.Bind<FINANCIAL_HOURS, jFINANCIAL_HOURS>();
            TinyMapper.Bind<FINANCIAL_HOURS, jFINANCIAL_HOURS>();
            TinyMapper.Bind<FINDING, jFINDING>();
            TinyMapper.Bind<FINDING_CONTACT, jFINDING_CONTACT>();
            TinyMapper.Bind<FRAMEWORK_TIER_TYPE_ANSWER, jFRAMEWORK_TIER_TYPE_ANSWER>();
            TinyMapper.Bind<GENERAL_SAL, jGENERAL_SAL>();
            TinyMapper.Bind<GENERAL_SAL, jGENERAL_SAL>();
            TinyMapper.Bind<INFORMATION, jINFORMATION>();
            TinyMapper.Bind<NIST_SAL_INFO_TYPES, jNIST_SAL_INFO_TYPES>();
            TinyMapper.Bind<NIST_SAL_QUESTION_ANSWERS, jNIST_SAL_QUESTION_ANSWERS>();
            TinyMapper.Bind<PARAMETER_ASSESSMENT, jPARAMETER_ASSESSMENT>();
            TinyMapper.Bind<PARAMETER_VALUES, jPARAMETER_VALUES>();
            TinyMapper.Bind<STANDARD_SELECTION, jSTANDARD_SELECTION>();
            TinyMapper.Bind<SUB_CATEGORY_ANSWERS, jSUB_CATEGORY_ANSWERS>();
            TinyMapper.Bind<SUB_CATEGORY_ANSWERS, jSUB_CATEGORY_ANSWERS>();
            TinyMapper.Bind<USER_DETAIL_INFORMATION, jUSER_DETAIL_INFORMATION>();
            TinyMapper.Bind<NIST_SAL_QUESTIONS, jNIST_SAL_QUESTION_ANSWERS>(config =>
            {
                config.Ignore(x => x.Question_Text);
            });
        }

        private UploadAssessmentModel CopyForExport(int assessmentId)
        {
            var assessmentDate = DateTime.MinValue;
            var model = new UploadAssessmentModel();

            foreach (var item in context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENTS.Add(TinyMapper.Map<ASSESSMENTS, jASSESSMENTS>(item));
                assessmentDate = item.Assessment_Date;
            }


            foreach (var item in context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENT_CONTACTS.Add(TinyMapper.Map<ASSESSMENT_CONTACTS,jASSESSMENT_CONTACTS>(item));
            }


            foreach (var item in context.ANSWER
                .Include(x => x.FINDING)
                .ThenInclude(x => x.FINDING_CONTACT)
                .Where(x => x.Assessment_Id == assessmentId))
            {
                model.jANSWER.Add(TinyMapper.Map<ANSWER,jANSWER>(item));
                foreach (var f in item.FINDING)
                {
                    model.jFINDING.Add(TinyMapper.Map<FINDING,jFINDING>(f));
                    foreach (var fc in f.FINDING_CONTACT)
                    {
                        model.jFINDING_CONTACT.Add(TinyMapper.Map<FINDING_CONTACT,jFINDING_CONTACT>(fc));
                    }
                }
            }


            foreach (var item in context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENT_SELECTED_LEVELS.Add(TinyMapper.Map<ASSESSMENT_SELECTED_LEVELS,jASSESSMENT_SELECTED_LEVELS>(item));
            }

            foreach (var item in context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jAVAILABLE_STANDARDS.Add(TinyMapper.Map<AVAILABLE_STANDARDS,jAVAILABLE_STANDARDS>(item));
            }

            foreach (var item in context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jCNSS_CIA_JUSTIFICATIONS.Add(TinyMapper.Map<CNSS_CIA_JUSTIFICATIONS,jCNSS_CIA_JUSTIFICATIONS>(item));
            }

            foreach (var item in context.CSET_VERSION)
            {
                model.jCSET_VERSION.Add(TinyMapper.Map<CSET_VERSION,jCSET_VERSION>(item));
            }

            foreach (var item in context.CUSTOM_BASE_STANDARDS)
            {
                model.jCUSTOM_BASE_STANDARDS.Add(TinyMapper.Map<CUSTOM_BASE_STANDARDS,jCUSTOM_BASE_STANDARDS>(item));
            }

            foreach (var item in context.CUSTOM_QUESTIONAIRES)
            {
                model.jCUSTOM_QUESTIONAIRES.Add(TinyMapper.Map<CUSTOM_QUESTIONAIRES,jCUSTOM_QUESTIONAIRES>(item));
            }

            foreach (var item in context.CUSTOM_QUESTIONAIRE_QUESTIONS)
            {
                model.jCUSTOM_QUESTIONAIRE_QUESTIONS.Add(TinyMapper.Map<CUSTOM_QUESTIONAIRE_QUESTIONS,jCUSTOM_QUESTIONAIRE_QUESTIONS>(item));
            }

            foreach (var item in context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jDEMOGRAPHICS.Add(TinyMapper.Map<DEMOGRAPHICS,jDEMOGRAPHICS>(item));
            }

            foreach (var item in context.DOCUMENT_FILE.Include(x => x.DOCUMENT_ANSWERS).ThenInclude(x => x.Answer_).Where(x => x.Assessment_Id == assessmentId))
            {
                model.jDOCUMENT_FILE.Add(TinyMapper.Map<DOCUMENT_FILE,jDOCUMENT_FILE>(item));
                foreach (var a in item.ANSWERs())
                {
                    model.jDOCUMENT_ANSWERS.Add(new jDOCUMENT_ANSWERS()
                    {
                        Answer_Id = a.Answer_Id,
                        Document_Id = item.Document_Id
                    });
                }
            }

            foreach (var item in context.FRAMEWORK_TIER_TYPE_ANSWER.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jFRAMEWORK_TIER_TYPE_ANSWER.Add(TinyMapper.Map<FRAMEWORK_TIER_TYPE_ANSWER,jFRAMEWORK_TIER_TYPE_ANSWER>(item));
            }

            foreach (var item in context.INFORMATION.Where(x => x.Id == assessmentId))
            {
                var oInfo = TinyMapper.Map<INFORMATION,jINFORMATION>(item);
                oInfo.Assessment_Date = assessmentDate;
                model.jINFORMATION.Add(oInfo);
            }

            foreach (var item in context.NIST_SAL_INFO_TYPES.Where(x => x.Selected == true && x.Assessment_Id == assessmentId))
            {
                model.jNIST_SAL_INFO_TYPES.Add(TinyMapper.Map<NIST_SAL_INFO_TYPES,jNIST_SAL_INFO_TYPES>(item));
            }

            foreach (var item in context.NIST_SAL_QUESTION_ANSWERS)
            {
                model.jNIST_SAL_QUESTION_ANSWERS.Add(TinyMapper.Map<NIST_SAL_QUESTION_ANSWERS,jNIST_SAL_QUESTION_ANSWERS>(item));
            }

            var parameterslist = from a in context.ASSESSMENTS
                                 join an in context.ANSWER on a.Assessment_Id equals an.Assessment_Id
                                 join p in context.PARAMETER_VALUES on an.Answer_Id equals p.Answer_Id
                                 where a.Assessment_Id == assessmentId
                                 select p;
            foreach (var item in parameterslist.Where(x => x.Parameter_Is_Default == false))
            {
                model.jPARAMETER_VALUES.Add(TinyMapper.Map<PARAMETER_VALUES,jPARAMETER_VALUES>(item));
            }

            foreach (var item in context.PARAMETER_ASSESSMENT.Where(x => x.Assessment_ID == assessmentId))
            {
                model.jPARAMETER_ASSESSMENTs.Add(TinyMapper.Map<PARAMETER_ASSESSMENT,jPARAMETER_ASSESSMENT>(item));
            }

            foreach (var item in context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jSTANDARD_SELECTION.Add(TinyMapper.Map<STANDARD_SELECTION,jSTANDARD_SELECTION>(item));
            }

            foreach (var item in context.GENERAL_SAL.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jGENERAL_SAL.Add(TinyMapper.Map<GENERAL_SAL,jGENERAL_SAL>(item));
            }

            foreach (var item in context.SUB_CATEGORY_ANSWERS.Where(x => x.Assessement_Id == assessmentId))
            {
                model.jSUB_CATEGORY_ANSWERS.Add(TinyMapper.Map<SUB_CATEGORY_ANSWERS,jSUB_CATEGORY_ANSWERS>(item));
            }

            // NCUA data
            foreach (var item in context.FINANCIAL_HOURS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jFINANCIAL_HOURS.Add(TinyMapper.Map<FINANCIAL_HOURS,jFINANCIAL_HOURS>(item));
            }

            foreach (var item in context.FINANCIAL_ASSESSMENT_VALUES.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jFINANCIAL_ASSESSMENT_VALUES.Add(TinyMapper.Map<FINANCIAL_ASSESSMENT_VALUES,jFINANCIAL_ASSESSMENT_VALUES>(item));
            }

            foreach (var item in context.ASSESSMENTS_REQUIRED_DOCUMENTATION.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENTS_REQUIRED_DOCUMENTATION.Add(TinyMapper.Map<ASSESSMENTS_REQUIRED_DOCUMENTATION,jASSESSMENTS_REQUIRED_DOCUMENTATION>(item));
            }

            foreach (var item in context.ASSESSMENT_IRP_HEADER.Where(x => x.ASSESSMENT_ID == assessmentId))
            {
                model.jASSESSMENT_IRP_HEADER.Add(TinyMapper.Map<ASSESSMENT_IRP_HEADER,jASSESSMENT_IRP_HEADER>(item));
            }

            foreach (var item in context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENT_IRP.Add(TinyMapper.Map<ASSESSMENT_IRP,jASSESSMENT_IRP>(item));
            }

            foreach (var item in context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jASSESSMENT_DIAGRAM_COMPONENTS.Add(TinyMapper.Map<ASSESSMENT_DIAGRAM_COMPONENTS,jASSESSMENT_DIAGRAM_COMPONENTS>(item));
            }

            foreach (var item in context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessmentId))
            {
                model.jDIAGRAM_CONTAINER.Add(TinyMapper.Map<DIAGRAM_CONTAINER,jDIAGRAM_CONTAINER>(item));
            }

            return model;
        }

        public Stream ArchiveStream(int assessmentId)
        {
            var archiveStream = new MemoryStream();
            var model = CopyForExport(assessmentId);

            using (var archive = new ZipArchive(archiveStream, ZipArchiveMode.Create, true))
            {
                foreach (var standard in model.jAVAILABLE_STANDARDS)
                {
                    var set = context.SETS
                        .Include(s => s.NEW_QUESTION)
                        .Include(s => s.NEW_REQUIREMENT)
                            .ThenInclude(s => s.REQUIREMENT_LEVELS)
                        .Include(s => s.Set_Category_)
                        .FirstOrDefault(s => s.Set_Name == standard.Set_Name && standard.Selected);

                    if (set == null || !set.Is_Custom)
                        continue;

                    var extStandard = set.ToExternalStandard();
                    var setname = Regex.Replace(extStandard.ShortName, @"\W", "_");

                    // Export Set
                    var standardEntry = archive.CreateEntry($"{setname}.json");
                    var jsonStandard = JsonConvert.SerializeObject(extStandard, Formatting.Indented);
                    using (var writer = new StreamWriter(standardEntry.Open()))
                    {
                        writer.Write(jsonStandard);
                    }

                    //Set the GUID at time of export so we are sure it's right!!!
                    model.jANSWER = model.jANSWER.Where(s => s.Is_Requirement).GroupJoin(set.NEW_REQUIREMENT, s => s.Question_Or_Requirement_Id, s => s.Requirement_Id, (t, s) =>
                    {
                        var req = s.FirstOrDefault();
                        if (req != null)
                        {
                            var buffer = Encoding.Default.GetBytes($"{extStandard.ShortName}|||{req.Requirement_Title}|||{req.Requirement_Text}");
                            t.Custom_Question_Guid = new Guid(new MD5CryptoServiceProvider().ComputeHash(buffer)).ToString();
                        }
                        return t;
                    }).Concat(model.jANSWER.Where(s => !s.Is_Requirement).GroupJoin(set.NEW_QUESTION, s => s.Question_Or_Requirement_Id, s => s.Question_Id, (t, s) =>
                    {
                        var req = s.FirstOrDefault();
                        if (req != null)
                        {
                            var buffer = Encoding.Default.GetBytes(req.Simple_Question);
                            t.Custom_Question_Guid = new Guid(new MD5CryptoServiceProvider().ComputeHash(buffer)).ToString();
                        }
                        return t;
                    })).ToList();

                    model.CustomStandards.Add(setname);

                    var files = extStandard.Requirements.SelectMany(s => s.References.Concat(new ExternalResource[] { s.Source })).OfType<ExternalResource>().Distinct();
                    foreach (var file in files)
                    {
                        var genFile = context.GEN_FILE.FirstOrDefault(s => s.File_Name == file.FileName && (s.Is_Uploaded ?? false));
                        if (genFile == null || model.CustomStandardDocs.Contains(file.FileName))
                            continue;

                        var doc = genFile.ToExternalDocument();
                        var docEntry = archive.CreateEntry($"{doc.ShortName}.json");
                        var jsonDoc = JsonConvert.SerializeObject(doc, Formatting.Indented);
                        using (var writer = new StreamWriter(docEntry.Open()))
                        {
                            writer.Write(jsonDoc);
                        }
                        model.CustomStandardDocs.Add(file.FileName);
                    }
                }

                model.ExportDateTime = DateTime.UtcNow;

                var json = JsonConvert.SerializeObject(model, Formatting.Indented);
                var modelEntry = archive.CreateEntry("model.json");
                using (var writer = new StreamWriter(modelEntry.Open()))
                {
                    writer.Write(json);
                }
            }

            archiveStream.Seek(0, SeekOrigin.Begin);
            return archiveStream;
        }
    }
}
