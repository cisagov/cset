//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
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
using CSETWeb_Api.BusinessLogic.ImportAssessment.Models.Version_9_0_1;
using Nelibur.ObjectMapper;
using CSET_Main.Data.AssessmentData;
using BusinessLogic.Helpers;
using System.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json.Linq;



namespace CSETWeb_Api.BusinessLogic.ImportAssessment
{
    public class Importer
    {
        /// <summary>
        /// Maps old keys to new keys.
        /// </summary>
        Dictionary<string, Dictionary<int, int>> mapIdentity = new Dictionary<string, Dictionary<int, int>>();


        /// <summary>
        /// 
        /// </summary>
        public Importer()
        {
            //ignore the emass document we are not using it anyway.
            TinyMapper.Bind<jINFORMATION, INFORMATION>(config =>
            {
                config.Ignore(x => x.eMass_Document_Id);
                config.Ignore(x => x.Id);
            });
            TinyMapper.Bind<jASSESSMENT_CONTACTS, ASSESSMENT_CONTACTS>(config =>
            {
                config.Ignore(x => x.Assessment_Contact_Id);
            });
            TinyMapper.Bind<jFINDING, FINDING>(config =>
             {
                 config.Ignore(x => x.Finding_Id);
             });
            //copy the incoming information to an intermediary
            //then copy from the intermediary to destination
            //and permit updates.

            // RKW 22-MAR-19 - this was crashing with a StackOverflowException.  
            //TinyMapper.Bind<INFORMATION, INFORMATION>(config =>
            //{
            //    config.Ignore(x => x.Id);
            //    config.Ignore(x => x.IdNavigation);
            //    config.Ignore(x => x.ASSESSMENT);
            //});
        }


        /// <summary>
        /// Populates a few principal assessment tables.
        /// </summary>
        /// <param name="model"></param>
        /// <param name="currentUserId"></param>
        /// <param name="primaryEmail"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        public int RunImportManualPortion(UploadAssessmentModel model,
            int currentUserId, string primaryEmail, CSET_Context db)
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

            Dictionary<string, int> oldUserNewUser = db.USERS.ToDictionary(x => x.PrimaryEmail, y => y.UserId);

            foreach(var a in model.jASSESSMENTS)
            {
                var item = db.ASSESSMENTS.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
                if (item != null)
                {
                    item.Assets = a.Assets;
                    item.Charter = a.Charter;
                    item.CreditUnionName = a.CreditUnionName;
                    item.IRPTotalOverride = a.IRPTotalOverride;
                    item.IRPTotalOverrideReason = a.IRPTotalOverrideReason;
                    item.MatDetail_targetBandOnly = a.MatDetail_targetBandOnly != null ? a.MatDetail_targetBandOnly : false;
                    db.SaveChanges();
                }
            }

            foreach (var a in model.jINFORMATION)
            {
                var item = db.ASSESSMENTS.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
                if (item != null)
                {
                    item.Assessment_Date = a.Assessment_Date;
                    db.SaveChanges();
                }
            }

            // go through the assessment contacts and: 
            // - if the contact does exist create it then add the id
            // - if the contact does exist update the id
            var dictAC = new Dictionary<int, int>();
            foreach (var a in model.jASSESSMENT_CONTACTS)
            {
                // Don't create another primary contact, but map its ID
                if (a.PrimaryEmail == primaryEmail)
                {
                    var newPrimaryContact = db.ASSESSMENT_CONTACTS.Where(x => x.PrimaryEmail == primaryEmail && x.Assessment_Id == _assessmentId).FirstOrDefault();
                    dictAC.Add(a.Assessment_Contact_Id, newPrimaryContact.Assessment_Contact_Id);
                    continue;
                }

                var item = TinyMapper.Map<ASSESSMENT_CONTACTS>(a);
                item.Assessment_Id = _assessmentId;
                item.PrimaryEmail = a.PrimaryEmail;
               
                if (oldUserNewUser.TryGetValue(a.PrimaryEmail, out int userid))
                {
                    item.UserId = userid;
                }
                else
                {
                    item.UserId = null;
                }

                db.ASSESSMENT_CONTACTS.Add(item);
                db.SaveChanges();

                dictAC.Add(a.Assessment_Contact_Id, item.Assessment_Contact_Id);
            }

            // map the primary keys so that they can be passed to the generic import logic
            this.mapIdentity.Add("ASSESSMENT_CONTACTS", dictAC);


            //
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

            return _assessmentId;
        }


        /// <summary>
        /// Processes the rest of the tables automatically. 
        /// </summary>
        /// <param name="jsonObject"></param>
        /// <param name="context"></param>
        internal void RunImportAutomatic(int assessmentId, string jsonObject)
        {
            var genericImporter = new GenericImporter(assessmentId);
            genericImporter.SetManualIdentityMaps(this.mapIdentity);
            genericImporter.SaveFromJson(jsonObject);
        }
    }
}

