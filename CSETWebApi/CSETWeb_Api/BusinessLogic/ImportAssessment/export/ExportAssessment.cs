//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using CSETWeb_Api.BusinessLogic.ImportAssessment.Models;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.ImportAssessment.Export
{
    public class ExportAssessment
    {   
        private Dictionary<int, String> questionGroupHeadings;
        private Dictionary<int, String> universalSubHeadings;
        private CsetwebContext entitites;

        public ExportAssessment(CsetwebContext entities)
        {
            this.entitites = entities;
            
                questionGroupHeadings = entities.QUESTION_GROUP_HEADING.Select(t => new { t.Question_Group_Heading_Id, t.Question_Group_Heading1})
               .ToDictionary(t => t.Question_Group_Heading_Id, t => t.Question_Group_Heading1);

                universalSubHeadings = entities.UNIVERSAL_SUB_CATEGORIES.Select(t => new { t.Universal_Sub_Category_Id, t.Universal_Sub_Category })
               .ToDictionary(t => t.Universal_Sub_Category_Id, t => t.Universal_Sub_Category);
            
            setupBindings();
        }

        /**
         * Go through the list of tables
         * for each table select out the rows and 
         * copy them to the corresponding json object
         * push it across the wire, fix it on the other side.
         */
        public UploadAssessmentModel CopyForExport(int _assessmentId)
        {
            var assessmentDate = DateTime.MinValue;

            UploadAssessmentModel model = new UploadAssessmentModel();
            foreach (var item in entitites.ASSESSMENTS.Where(x => x.Assessment_Id == _assessmentId))
            {
                model.jASSESSMENTS.Add(TinyMapper.Map<jASSESSMENTS>(item));
                assessmentDate = item.Assessment_Date;
            }

            foreach (var item in entitites.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == _assessmentId))
            {
               model.jASSESSMENT_CONTACTS.Add(TinyMapper.Map<jASSESSMENT_CONTACTS>(item));
            }
            foreach (var c in entitites.ANSWER.Include("FINDING").Where(x=> x.Assessment_Id == _assessmentId)) {
                model.jANSWER.Add(TinyMapper.Map<jANSWER>(c));
                foreach (var f in c.FINDING) {
                    model.jFINDING.Add(TinyMapper.Map<jFINDING>(c));
                    foreach (var fc in f.FINDING_CONTACT) {
                        model.jFINDING_CONTACT.Add(TinyMapper.Map<jFINDING_CONTACT>(c));
                    }
                }
            }
            foreach (var c in entitites.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == _assessmentId)) { model.jASSESSMENT_SELECTED_LEVELS.Add(TinyMapper.Map<jASSESSMENT_SELECTED_LEVELS>(c)); }
            foreach (var c in entitites.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == _assessmentId)) { model.jAVAILABLE_STANDARDS.Add(TinyMapper.Map<jAVAILABLE_STANDARDS>(c)); }
            foreach (var c in entitites.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId)) { model.jCNSS_CIA_JUSTIFICATIONS.Add(TinyMapper.Map<jCNSS_CIA_JUSTIFICATIONS>(c)); }
            foreach (var c in entitites.CSET_VERSION) { model.jCSET_VERSION.Add(TinyMapper.Map<jCSET_VERSION>(c)); }
            foreach (var c in entitites.CUSTOM_BASE_STANDARDS) { model.jCUSTOM_BASE_STANDARDS.Add(TinyMapper.Map<jCUSTOM_BASE_STANDARDS>(c)); }
            foreach (var c in entitites.CUSTOM_QUESTIONAIRES) { model.jCUSTOM_QUESTIONAIRES.Add(TinyMapper.Map<jCUSTOM_QUESTIONAIRES>(c)); }
            foreach (var c in entitites.CUSTOM_QUESTIONAIRE_QUESTIONS) { model.jCUSTOM_QUESTIONAIRE_QUESTIONS.Add(TinyMapper.Map<jCUSTOM_QUESTIONAIRE_QUESTIONS>(c)); }
            foreach (var c in entitites.DEMOGRAPHICS.Where(x => x.Assessment_Id == _assessmentId)) { model.jDEMOGRAPHICS.Add(TinyMapper.Map<jDEMOGRAPHICS>(c)); }
            foreach (var c in entitites.DOCUMENT_FILE.Include("Answer").Where(x => x.Assessment_Id == _assessmentId)) {
                model.jDOCUMENT_FILE.Add(TinyMapper.Map<jDOCUMENT_FILE>(c));
                foreach (var a in c.ANSWER)
                {
                    model.jDOCUMENT_ANSWERS.Add(new jDOCUMENT_ANSWERS()
                    {
                        Answer_Id = a.Answer_Id,
                        Document_Id = c.Document_Id
                    });
                }
            }
            foreach (var c in entitites.FRAMEWORK_TIER_TYPE_ANSWER.Where(x => x.Assessment_Id == _assessmentId)) {
                model.jFRAMEWORK_TIER_TYPE_ANSWER.Add(TinyMapper.Map<jFRAMEWORK_TIER_TYPE_ANSWER>(c));
            }
            foreach (var c in entitites.INFORMATION.Where(x=> x.Id == _assessmentId)) {
                var oInfo = TinyMapper.Map<jINFORMATION>(c);
                oInfo.Assessment_Date = assessmentDate;
                model.jINFORMATION.Add(oInfo);
            }
            foreach (var c in entitites.NIST_SAL_INFO_TYPES.Where(x=> x.Selected==true && x.Assessment_Id == _assessmentId)) { model.jNIST_SAL_INFO_TYPES.Add(TinyMapper.Map<jNIST_SAL_INFO_TYPES>(c)); }
            foreach (var c in entitites.NIST_SAL_QUESTIONS) { model.jNIST_SAL_QUESTION_ANSWERS.Add(TinyMapper.Map<jNIST_SAL_QUESTION_ANSWERS>(c)); }
            var parameterslist = from a in entitites.ASSESSMENTS
                                 join an in entitites.ANSWER on a.Assessment_Id equals an.Assessment_Id
                                 join p in entitites.PARAMETER_VALUES on an.Answer_Id equals p.Answer_Id
                                 where a.Assessment_Id == _assessmentId
                                 select p; 
            foreach (var c in parameterslist.Where(x=> x.Parameter_Is_Default == false)) { model.jPARAMETER_VALUES.Add(TinyMapper.Map<jPARAMETER_VALUES>(c)); }
            foreach (var c in entitites.PARAMETER_ASSESSMENT.Where(x => x.Assessment_ID == _assessmentId)) { model.jPARAMETER_ASSESSMENTs.Add(TinyMapper.Map<jPARAMETER_ASSESSMENT>(c)); }
            foreach (var c in entitites.STANDARD_SELECTION.Where(x=> x.Assessment_Id == _assessmentId)) { model.jSTANDARD_SELECTION.Add(TinyMapper.Map<jSTANDARD_SELECTION>(c));}
            foreach (var c in entitites.GENERAL_SAL.Where(x=> x.Assessment_Id == _assessmentId)) { model.jGENERAL_SAL.Add(TinyMapper.Map<jGENERAL_SAL>(c)); }
            foreach (var c in entitites.SUB_CATEGORY_ANSWERS.Where(x=> x.Assessement_Id == _assessmentId)) {model.jSUB_CATEGORY_ANSWERS.Add(TinyMapper.Map<jSUB_CATEGORY_ANSWERS>(c));}
            return model;
        }

        private void setupBindings()
        {

            TinyMapper.Bind<ADDRESS, jADDRESS>();
            TinyMapper.Bind<jUSER_DETAIL_INFORMATION, jUSER_DETAIL_INFORMATION>();
            TinyMapper.Bind<ASSESSMENT_SELECTED_LEVELS, jASSESSMENT_SELECTED_LEVELS>();
            TinyMapper.Bind<AVAILABLE_STANDARDS, jAVAILABLE_STANDARDS>();
            TinyMapper.Bind<CNSS_CIA_JUSTIFICATIONS, jCNSS_CIA_JUSTIFICATIONS>();
            //TinyMapper.Bind<ASSESSMENT_CONTACTS, jASSESSMENT_CONTACTS>(config => 
            //    { config.Ignore(x => x.Assessment_Contact_Id); }               
            //);
            //TinyMapper.Bind<CUSTOM_QUESTIONAIRES, jCUSTOM_QUESTIONAIRES>(config =>
            //{
            //});
            //TinyMapper.Bind<CUSTOM_BASE_STANDARDS, jCUSTOM_BASE_STANDARDS>(config =>
            //{
            //});
            TinyMapper.Bind<DEMOGRAPHICS, jDEMOGRAPHICS>();

            //TinyMapper.Bind<CUSTOM_STANDARD_BASE_STANDARD, jCUSTOM_STANDARD_BASE_STANDARD>(config =>
            //{
            //});
            //TinyMapper.Bind<CUSTOM_QUESTIONAIRE_QUESTIONS, jCUSTOM_QUESTIONAIRE_QUESTIONS>(config =>
            //{
            //});
            //TinyMapper.Bind<DOCUMENT_FILE, jDOCUMENT_FILE>(config =>
            //{
            //});
            //may have to create a custom type converter
            TinyMapper.Bind<FINDING_CONTACT, jFINDING_CONTACT>();
           
            //TinyMapper.Bind<STANDARD_SELECTION, jSTANDARD_SELECTION>(config =>
            //{
            //});

            //TinyMapper.Bind<FRAMEWORK_TIER_TYPE_ANSWER, jFRAMEWORK_TIER_TYPE_ANSWER>(config =>
            //{
            //});
            
            //TinyMapper.Bind<SUB_CATEGORY_ANSWERS, jSUB_CATEGORY_ANSWERS>(config =>
            //{
            //});

            //TinyMapper.Bind<FINDING, jFINDING>(config =>
            //{
            //});
            //TinyMapper.Bind<ANSWER, jANSWER>(config =>
            //{
            //});
            TinyMapper.Bind<NIST_SAL_INFO_TYPES, jNIST_SAL_INFO_TYPES>();
            TinyMapper.Bind<NIST_SAL_QUESTIONS, jNIST_SAL_QUESTION_ANSWERS>(config =>
            {   
                config.Ignore(x => x.Question_Text);
            });
            //TinyMapper.Bind<INFORMATION, jINFORMATION>(config =>
            //{
            //});

            //TinyMapper.Bind<PARAMETER_VALUES, jPARAMETER_VALUES>(config =>
            //{
            //});
        }
    }
}


