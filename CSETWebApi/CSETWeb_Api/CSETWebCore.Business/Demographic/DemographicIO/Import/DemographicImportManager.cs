//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml;
using Ionic.Zip;
using System.Collections.Generic;
using CSETWebCore.Business.Demographic.DemographicIO.Models;
using DocumentFormat.OpenXml.Spreadsheet;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Model.Demographic;
using CSETWebCore.Model.Assessment;


namespace CSETWebCore.Business.Demographic.Import
{
    public class DemographicImportManager : IDemographicImportManager
    {
        private ITokenManager _token;
        private IAssessmentUtil _assessmentUtil;
        private IUtilities _utilities;
        private CSETContext _context;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        public DemographicImportManager(ITokenManager token, IAssessmentUtil assessmentUtil, IUtilities utilities, CSETContext context)
        {
            _token = token;
            _assessmentUtil = assessmentUtil;
            _utilities = utilities;
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="zipFileFromDatabase"></param>
        /// <param name="currentUserId"></param>
        /// <returns></returns>
        public async Task ProcessCSETDemographicImport(byte[] zipFileFromDatabase, int? currentUserId, int assessmentId, string accessKey, CSETContext context, string password = "", bool overwriteAssessment = false)
        {
            //* read from db and set as memory stream here.
            using (Stream fs = new MemoryStream(zipFileFromDatabase))
            {
                MemoryStream ms = new MemoryStream(zipFileFromDatabase);
                ms.Position = 0;
                StreamReader sr = new StreamReader(ms);
                string jsonObject = sr.ReadToEnd();


                try
                {
                    UploadDemographicsModel model = (UploadDemographicsModel)JsonConvert.DeserializeObject(jsonObject, new UploadDemographicsModel().GetType());

                    foreach (var serviceDemographics in model.jCIS_CSI_SERVICE_DEMOGRAPHICS)
                    {
                        var dbServiceDemographics = context.CIS_CSI_SERVICE_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                        // Creating new Service Demographics record for this assessment
                        if (dbServiceDemographics == null)
                        {
                            dbServiceDemographics = new CIS_CSI_SERVICE_DEMOGRAPHICS()
                            {
                                Assessment_Id = assessmentId
                            };
                            context.CIS_CSI_SERVICE_DEMOGRAPHICS.Add(dbServiceDemographics);
                            context.SaveChanges();
                        }

                        dbServiceDemographics.Critical_Service_Description = serviceDemographics.Critical_Service_Description;
                        dbServiceDemographics.IT_ICS_Name = serviceDemographics.IT_ICS_Name;
                        dbServiceDemographics.Multi_Site = serviceDemographics.Multi_Site;
                        dbServiceDemographics.Multi_Site_Description = serviceDemographics.Multi_Site_Description;
                        dbServiceDemographics.Budget_Basis = serviceDemographics.Budget_Basis;
                        dbServiceDemographics.Authorized_Organizational_User_Count = serviceDemographics.Authorized_Organizational_User_Count;
                        dbServiceDemographics.Authorized_Non_Organizational_User_Count = serviceDemographics.Authorized_Non_Organizational_User_Count;
                        dbServiceDemographics.Customers_Count = serviceDemographics.Customers_Count;
                        dbServiceDemographics.IT_ICS_Staff_Count = serviceDemographics.IT_ICS_Staff_Count;
                        dbServiceDemographics.Cybersecurity_IT_ICS_Staff_Count = serviceDemographics.Cybersecurity_IT_ICS_Staff_Count;

                        context.SaveChanges();
                    }

                    foreach (var serviceComposition in model.jCIS_CSI_SERVICE_COMPOSITION)
                    {
                        var dbServiceComposition = context.CIS_CSI_SERVICE_COMPOSITION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                        // Creating new Service Composition record for this assessment
                        if (dbServiceComposition == null)
                        {
                            dbServiceComposition = new CIS_CSI_SERVICE_COMPOSITION()
                            {
                                Assessment_Id = assessmentId
                            };
                            context.CIS_CSI_SERVICE_COMPOSITION.Add(dbServiceComposition);
                            context.SaveChanges();
                        }

                        dbServiceComposition.Networks_Description = serviceComposition.Networks_Description;
                        dbServiceComposition.Services_Description = serviceComposition.Services_Description;
                        dbServiceComposition.Applications_Description = serviceComposition.Applications_Description;
                        dbServiceComposition.Connections_Description = serviceComposition.Connections_Description;
                        dbServiceComposition.Personnel_Description = serviceComposition.Personnel_Description;
                        dbServiceComposition.Other_Defining_System_Description = serviceComposition.Other_Defining_System_Description;
                        dbServiceComposition.Primary_Defining_System = serviceComposition.Primary_Defining_System;


                        context.SaveChanges();

                    }

                    foreach (var demographics in model.jDEMOGRAPHICS)
                    {
                        var dDemographics = context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                        // Creating new Service Composition record for this assessment
                        if (dDemographics == null)
                        {
                            dDemographics = new DEMOGRAPHICS()
                            {
                                Assessment_Id = assessmentId,
                                CriticalService = demographics.CriticalService


                            };
                            context.DEMOGRAPHICS.Add(dDemographics);
                            context.SaveChanges();
                        }

                        dDemographics.SectorId = demographics.SectorId;
                        dDemographics.IndustryId = demographics.IndustryId;
                        dDemographics.Size = demographics.Size;
                        dDemographics.AssetValue = demographics.AssetValue;
                        dDemographics.NeedsPrivacy = demographics.NeedsPrivacy;
                        dDemographics.NeedsSupplyChain = demographics.NeedsSupplyChain;
                        dDemographics.NeedsICS = demographics.NeedsICS;
                        dDemographics.OrganizationName = demographics.OrganizationName;
                        dDemographics.Agency = demographics.Agency;
                        dDemographics.OrganizationType = demographics.OrganizationType;
                        dDemographics.IsScoped = demographics.IsScoped;
                        dDemographics.CriticalService = demographics.CriticalService;

                        context.SaveChanges();
                    }


                    foreach (var jdd in model.jDETAILS_DEMOGRAPHICS)
                    {
                        var dd = context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == jdd.DataItemName).FirstOrDefault();
                        if (dd == null)
                        {
                            dd = new DETAILS_DEMOGRAPHICS()
                            {
                                Assessment_Id = assessmentId,
                                DataItemName = jdd.DataItemName
                            };

                            context.DETAILS_DEMOGRAPHICS.Add(dd);
                            context.SaveChanges();
                        }

                        dd.DateTimeValue = jdd.DateTimeValue;
                        // handle low dates for SQL Server
                        if (jdd.DateTimeValue?.Year < 1753)
                        {
                            dd.DateTimeValue = null;
                        }
                        dd.StringValue = jdd.StringValue;
                        dd.IntValue = jdd.IntValue;
                        dd.FloatValue = jdd.FloatValue;
                        dd.BoolValue = jdd.BoolValue;
                    }

                    context.SaveChanges();


                    foreach (var serviceCompositionSecondary in model.jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS)
                    {
                        var dserviceCompositionSecondary = context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                        // Creating new Service Composition record for this assessment
                        if (dserviceCompositionSecondary == null)
                        {
                            dserviceCompositionSecondary = new CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS()
                            {
                                Assessment_Id = assessmentId,
                                Defining_System_Id = serviceCompositionSecondary.Defining_System_Id
                            };
                            context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Add(dserviceCompositionSecondary);
                        }

                        context.SaveChanges();
                    }

                    foreach (var information in model.jORG_DETAILS)
                    {
                        var dinformation = context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();

                        // Creating new Service Composition record for this assessment
                        if (dinformation == null)
                        {
                            dinformation = new INFORMATION()
                            {
                                Id = assessmentId,

                            };
                            context.INFORMATION.Add(dinformation);
                            context.SaveChanges();
                        }
                        dinformation.Facility_Name = information.Facility_Name;
                        dinformation.City_Or_Site_Name = information.City_Or_Site_Name;
                        dinformation.State_Province_Or_Region = information.State_Province_Or_Region;

                        context.SaveChanges();
                    }


                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                    throw;
                }
            }
        }

    }
}