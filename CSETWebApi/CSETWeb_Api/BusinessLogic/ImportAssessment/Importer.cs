//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Models;
using System;
using DataLayerCore.Model;
using System.Linq;
using System.Collections.Generic;
using CSETWeb_Api.BusinessLogic.ImportAssessment.Models;
using Nelibur.ObjectMapper;
using CSET_Main.Data.AssessmentData;
using BusinessLogic.Helpers;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;



namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    public class Importer
    {
        public Importer()
        {
            //ignore the emass document we are not using it anyway.
            TinyMapper.Bind<jINFORMATION, INFORMATION>(config =>
            {
                config.Ignore(x => x.eMass_Document_Id);
            });
            //copy the incoming information to an intermediary
            //then copy from the intermediary to destination
            //and permit updates.

            TinyMapper.Bind<INFORMATION, INFORMATION>(config =>
            {
                config.Ignore(x => x.Id);
                config.Ignore(x => x.IdNavigation);                
            });
        }

        public Tuple<int, Dictionary<int, DOCUMENT_FILE>> RunImport(UploadAssessmentModel model,
            int currentUserId, string primaryEmail
            , CSET_Context db)
        {
            //create the new assessment
            //copy each of the items to the table 
            //as the copy occurs change to the current assessment_id
            //update the answer id's             
            Dictionary<int, DOCUMENT_FILE> oldIdToNewDocument = new Dictionary<int, DOCUMENT_FILE>();
            AssessmentManager man = new AssessmentManager();
            AssessmentDetail detail = man.CreateNewAssessmentForImport(currentUserId);
            int _assessmentId = detail.Id;

            Dictionary<int, int> oldAnswerId = new Dictionary<int, int>();
            Dictionary<int, ANSWER> oldIdNewAnswer = new Dictionary<int, ANSWER>();

            Dictionary<String, int> oldUserNewUser = db.USERS.ToDictionary(x => x.PrimaryEmail, y => y.UserId);


            // go through the assessment contacts and 
            // if the contact does exist create it then add the id
            // if the contact does exist update the id
            foreach (var a in model.jASSESSMENT_CONTACTS.Where(x => x.PrimaryEmail != primaryEmail))
            {

                var item = TinyMapper.Map<ASSESSMENT_CONTACTS>(a);
                item.Assessment_Id = _assessmentId;
                item.PrimaryEmail = a.PrimaryEmail;
                int userid;
                if (oldUserNewUser.TryGetValue(a.PrimaryEmail, out userid))
                {
                    item.UserId = userid;
                }
                else
                {
                    item.UserId = null;
                }
                db.ASSESSMENT_CONTACTS.Add(item);
            }
            db.SaveChanges();


            foreach (var a in model.jUSER_DETAIL_INFORMATION)
            {
                if (db.USER_DETAIL_INFORMATION.Where(x => x.Id == a.Id).FirstOrDefault() == null)
                {
                    var userInfo = TinyMapper.Map<USER_DETAIL_INFORMATION>(a);
                    userInfo.FirstName = String.IsNullOrWhiteSpace(a.FirstName) ? "First Name" : a.FirstName;
                    userInfo.LastName = String.IsNullOrWhiteSpace(a.LastName) ? "Last Name" : a.LastName;
                    db.USER_DETAIL_INFORMATION.Add(userInfo);
                    foreach (var b in a.jADDRESSes)
                    {
                        var item = TinyMapper.Map<ADDRESS>(b);
                        item.AddressType = "Imported";
                        db.ADDRESS.Add(item);
                    }
                    db.SaveChanges();
                }
            }

            foreach (var a in model.jANSWER)
            {
                a.Assessment_Id = _assessmentId;
                a.Old_Answer_Id = a.Answer_Id;
                a.Answer_Id = 0;
            }
            db.SaveChanges();
            var objBulk = new BulkUploadToSql<jANSWER>()
            {
                InternalStore = model.jANSWER,
                TableName = "ANSWER",
                CommitBatchSize = 1000,
                ConnectionString = ((Microsoft.EntityFrameworkCore.DbContext)db).Database.GetDbConnection().ConnectionString
            };
            objBulk.Commit();


            oldAnswerId = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId).ToDictionary(x => x.Old_Answer_Id ?? 0, y => y.Answer_Id);
            oldIdNewAnswer = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId).ToDictionary(x => x.Old_Answer_Id ?? 0, y => y);


            if (model.jSTANDARD_SELECTION.Count > 0)
            {
                foreach (var a in model.jSTANDARD_SELECTION)
                {
                    var item = TinyMapper.Map<STANDARD_SELECTION>(a);
                    item.Assessment_Id = _assessmentId;
                    db.STANDARD_SELECTION.Add(item);
                }
            }
            else
            {
                db.STANDARD_SELECTION.Add(new STANDARD_SELECTION()
                {
                    Application_Mode = AssessmentModeData.QUESTIONS_BASED_APPLICATION_MODE,
                    Selected_Sal_Level = Constants.SAL_LOW,
                    Assessment_Id = _assessmentId,
                    Last_Sal_Determination_Type = Constants.SIMPLE_SAL,
                    Is_Advanced = false
                });
            }
            foreach (var a in model.jASSESSMENT_SELECTED_LEVELS)
            {
                var item = TinyMapper.Map<ASSESSMENT_SELECTED_LEVELS>(a);
                item.Assessment_Id = _assessmentId;
                db.ASSESSMENT_SELECTED_LEVELS.Add(item);
            }
            foreach (var a in model.jAVAILABLE_STANDARDS)
            {
                var item = TinyMapper.Map<AVAILABLE_STANDARDS>(a);
                item.Assessment_Id = _assessmentId;
                db.AVAILABLE_STANDARDS.Add(item);
            }
            foreach (var a in model.jCNSS_CIA_JUSTIFICATIONS)
            {
                var item = TinyMapper.Map<CNSS_CIA_JUSTIFICATIONS>(a);
                item.Assessment_Id = _assessmentId;
                db.CNSS_CIA_JUSTIFICATIONS.Add(item);
            }
            foreach (var a in model.jCUSTOM_BASE_STANDARDS) { var item = TinyMapper.Map<CUSTOM_BASE_STANDARDS>(a); db.CUSTOM_BASE_STANDARDS.Add(item); }
            foreach (var a in model.jCUSTOM_QUESTIONAIRES) { var item = TinyMapper.Map<CUSTOM_QUESTIONAIRES>(a); db.CUSTOM_QUESTIONAIRES.Add(item); }
            foreach (var a in model.jCUSTOM_QUESTIONAIRE_QUESTIONS)
            {
                var item = TinyMapper.Map<CUSTOM_QUESTIONAIRE_QUESTIONS>(a); db.CUSTOM_QUESTIONAIRE_QUESTIONS.Add(item);
            }
            foreach (var a in model.jCUSTOM_STANDARD_BASE_STANDARD)
            {
                var item = TinyMapper.Map<CUSTOM_STANDARD_BASE_STANDARD>(a); db.CUSTOM_STANDARD_BASE_STANDARD.Add(item);
            }
            foreach (var a in model.jDEMOGRAPHICS)
            {
                var item = TinyMapper.Map<DEMOGRAPHICS>(a);
                item.Assessment_Id = _assessmentId;
                if ((a.IndustryId == 0) || (a.SectorId == 0))
                {
                    //what do we want to do for a default?
                }
                else
                    db.DEMOGRAPHICS.Add(item);
            }
            //this needs the answers inserted first
            //then the documents and finally
            //we can associate documents and answers
            //look at adding a reference to the answer to jDocument_File
            //then as we iterate through the answers and documents keep the references
            foreach (var a in model.jDOCUMENT_FILE)
            {
                var item = TinyMapper.Map<DOCUMENT_FILE>(a);
                oldIdToNewDocument.Add(a.Document_Id, item);
                item.Assessment_Id = _assessmentId;
                db.DOCUMENT_FILE.Add(item);
            }
            db.SaveChanges();
            foreach (var a in model.jDOCUMENT_ANSWERS)
            {
                var item = oldIdToNewDocument[a.Document_Id];
                db.DOCUMENT_ANSWERS.Add(new DOCUMENT_ANSWERS() { Answer_Id = oldIdNewAnswer[a.Answer_Id].Answer_Id, Document_Id = item.Document_Id });                
            }
            Dictionary<int, FINDING> idToFinding = new Dictionary<int, FINDING>();
            foreach (var a in model.jFINDING)
            {
                var item = TinyMapper.Map<FINDING>(a);
                item.Importance_Id = item.Importance_Id == 0 ? 1 : item.Importance_Id;
                item.Answer_Id = oldAnswerId[a.Answer_Id];
                idToFinding.Add(a.Finding_Id, item);
                db.FINDING.Add(item);
            }
            var AcontactID = db.ASSESSMENT_CONTACTS.Where(x => x.UserId == currentUserId).FirstOrDefault();
            if (AcontactID != null)//if we dont have a current user we are in trouble
            {
                int acid = AcontactID.Assessment_Contact_Id;
                foreach (var a in model.jFINDING_CONTACT)
                {
                    db.FINDING_CONTACT.Add(new FINDING_CONTACT()
                    {
                        Assessment_Contact_Id = a.Assessment_Contact_Id == 0 ? acid : a.Assessment_Contact_Id,
                        Finding_Id = idToFinding[a.Finding_Id].Finding_Id,
                        Id = a.Old_Contact_Id
                    });
                }
            }

            foreach (var a in model.jFRAMEWORK_TIER_TYPE_ANSWER)
            {
                var item = TinyMapper.Map<FRAMEWORK_TIER_TYPE_ANSWER>(a);
                item.Assessment_Id = _assessmentId;
                db.FRAMEWORK_TIER_TYPE_ANSWER.Add(item);
            }
            foreach (var a in model.jGENERAL_SAL)
            {
                var item = TinyMapper.Map<GENERAL_SAL>(a);
                item.Assessment_Id = _assessmentId;
                db.GENERAL_SAL.Add(item);
            }
            foreach (var a in model.jINFORMATION)
            {
                var info = db.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();
                if (info != null)
                {
                    var b = TinyMapper.Map<INFORMATION>(a);
                    TinyMapper.Map(b, info);
                    db.SaveChanges();
                }
                else
                {
                    var item = TinyMapper.Map<INFORMATION>(a);
                    item.Id = _assessmentId;
                    db.INFORMATION.Add(item);
                }

                db.ASSESSMENTS.Where(x => x.Assessment_Id == _assessmentId).First().Assessment_Date = a.Assessment_Date;
                db.SaveChanges();
            }
            foreach (var a in model.jNIST_SAL_INFO_TYPES)
            {
                var item = TinyMapper.Map<NIST_SAL_INFO_TYPES>(a);
                item.Assessment_Id = _assessmentId;
                db.NIST_SAL_INFO_TYPES.Add(item);
            }
            foreach (var a in model.jNIST_SAL_QUESTION_ANSWERS)
            {
                var item = TinyMapper.Map<NIST_SAL_QUESTION_ANSWERS>(a);
                item.Question_Answer = item.Question_Answer ?? "No";
                item.Assessment_Id = _assessmentId;
                db.NIST_SAL_QUESTION_ANSWERS.Add(item);
                db.SaveChanges();
            }
            foreach (var a in model.jPARAMETER_VALUES)
            {
                var item = TinyMapper.Map<PARAMETER_VALUES>(a);
                item.Answer_Id = oldAnswerId[a.Answer_Id];
                db.PARAMETER_VALUES.Add(item);
            }
            foreach (var a in model.jPARAMETER_ASSESSMENTs)
            {
                var item = TinyMapper.Map<PARAMETER_ASSESSMENT>(a);
                item.Assessment_ID = _assessmentId;
                db.PARAMETER_ASSESSMENT.Add(item);
            }

            foreach (var a in model.jSUB_CATEGORY_ANSWERS)
            {
                var item = TinyMapper.Map<SUB_CATEGORY_ANSWERS>(a);
                item.Assessement_Id = _assessmentId;

                if ((a.Question_Group_Heading_Id > 0) && (a.Universal_Sub_Category_Id > 0))
                {
                    var header = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Question_Group_Heading_Id == a.Question_Group_Heading_Id && x.Universal_Sub_Category_Id == a.Universal_Sub_Category_Id).FirstOrDefault();
                    if (header != null)
                    {
                        item.Heading_Pair_Id = header.Heading_Pair_Id;
                    }
                    else
                    {
                        try
                        {
                            var tempHeading = db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == a.Universal_Sub_Category_Id).FirstOrDefault();
                            if (tempHeading != null)
                            {

                                var adding = new UNIVERSAL_SUB_CATEGORY_HEADINGS()
                                {
                                    Display_Radio_Buttons = false,
                                    Question_Group_Heading_Id = a.Question_Group_Heading_Id,
                                    Universal_Sub_Category_Id = a.Universal_Sub_Category_Id,
                                    Sub_Heading_Question_Description = null
                                };
                                //see if we can create the record
                                db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(adding);
                                db.SaveChanges();
                                item.Heading_Pair_Id = adding.Heading_Pair_Id;
                            }
                        }
                        catch
                        {
                            //silent throw away  NOT MY FAVORITE
                            //but ok because there is nothing else we can do here.
                        }
                    }
                }
                if (!String.IsNullOrWhiteSpace(a.Question_Group_Heading) && !String.IsNullOrWhiteSpace(a.Universal_Sub_Category))
                {
                    var header = db.vQUESTION_HEADINGS.Where(x => x.Question_Group_Heading == a.Question_Group_Heading && x.Universal_Sub_Category == a.Universal_Sub_Category).FirstOrDefault();
                    if (header == null)
                    {//try by id's 
                        var header2 = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Question_Group_Heading_Id == a.Question_Group_Heading_Id && x.Universal_Sub_Category_Id == a.Universal_Sub_Category_Id).FirstOrDefault();
                        if (header2 != null)
                            item.Heading_Pair_Id = header2.Heading_Pair_Id;
                    }
                    else
                    {
                        item.Heading_Pair_Id = header.Heading_Pair_Id;
                    }
                }
                if (item.Heading_Pair_Id > 0)
                    db.SUB_CATEGORY_ANSWERS.Add(item);
            }
            try
            {

                db.SaveChanges();
            }
            catch (Exception e)
            {
                throw e;
            }



            return new Tuple<int, Dictionary<int, DOCUMENT_FILE>>(_assessmentId, oldIdToNewDocument);
        }
    }
}

