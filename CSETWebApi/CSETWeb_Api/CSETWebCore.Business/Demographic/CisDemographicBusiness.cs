//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using System.Linq;
using CSETWebCore.Model.Assessment;
using System.Collections.Generic;
using CSETWebCore.Business.Assessment;


namespace CSETWebCore.Business.Demographic
{
    public class CisDemographicBusiness : ICisDemographicBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        public CisDemographicBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }

        /// <summary>
        /// Persists data to the CIS_CSI_ORGANIZATION_DEMOGRAPHICS table.
        /// </summary
        public int SaveOrgDemographics(CisOrganizationDemographics orgDemographics)
        {
            var dbOrgDemographics = _context.CIS_CSI_ORGANIZATION_DEMOGRAPHICS.Where(x => x.Assessment_Id == orgDemographics.AssessmentId).FirstOrDefault();

            // Creating new Organization Demographics record for this assessment
            if (dbOrgDemographics == null)
            {
                dbOrgDemographics = new CIS_CSI_ORGANIZATION_DEMOGRAPHICS()
                {
                    Assessment_Id = orgDemographics.AssessmentId
                };
                _context.CIS_CSI_ORGANIZATION_DEMOGRAPHICS.Add(dbOrgDemographics);
                _context.SaveChanges();
            }

            dbOrgDemographics.Motivation_CRR = orgDemographics.MotivationCrr;
            dbOrgDemographics.Motivation_CRR_Description = orgDemographics.MotivationCrrDescription;
            dbOrgDemographics.Motivation_RRAP = orgDemographics.MotivationRrap;
            dbOrgDemographics.Motivation_RRAP_Description = orgDemographics.MotivationRrapDescription;
            dbOrgDemographics.Motivation_Organization_Request = orgDemographics.MotivationOrganizationRequest;
            dbOrgDemographics.Motivation_Organization_Request_Description = orgDemographics.MotivationOrganizationRequestDescription;
            dbOrgDemographics.Motivation_Law_Enforcement_Request = orgDemographics.MotivationLawEnforcementRequest;
            dbOrgDemographics.Motivation_Law_Enforcement_Description = orgDemographics.MotivationLawEnforcementRequestDescription;
            dbOrgDemographics.Motivation_Direct_Threats = orgDemographics.MotivationDirectThreats;
            dbOrgDemographics.Motivation_Direct_Threats_Description = orgDemographics.MotivationDirectThreatsDescription;
            dbOrgDemographics.Motivation_Special_Event = orgDemographics.MotivationSpecialEvent;
            dbOrgDemographics.Motivation_Special_Event_Description = orgDemographics.MotivationSpecialEventDescription;
            dbOrgDemographics.Motivation_Other = orgDemographics.MotivationOther;
            dbOrgDemographics.Motivation_Other_Description = orgDemographics.MotivationOtherDescription;
            dbOrgDemographics.Parent_Organization = orgDemographics.ParentOrganization;
            dbOrgDemographics.Organization_Name = orgDemographics.OrganizationName;
            dbOrgDemographics.Site_Name = orgDemographics.SiteName;
            dbOrgDemographics.Street_Address = orgDemographics.StreetAddress;
            dbOrgDemographics.Visit_Date = orgDemographics.VisitDate;
            dbOrgDemographics.Completed_For_SLTT = orgDemographics.CompletedForSltt;
            dbOrgDemographics.Completed_For_Federal = orgDemographics.CompletedForFederal;
            dbOrgDemographics.Completed_For_National_Special_Event = orgDemographics.CompletedForNationalSpecialEvent;
            dbOrgDemographics.CIKR_Sector = orgDemographics.CikrSector;
            dbOrgDemographics.Sub_Sector = orgDemographics.SubSector;
            dbOrgDemographics.IT_ICS_Staff_Count = orgDemographics.ItIcsStaffCount;
            dbOrgDemographics.Cybersecurity_IT_ICS_Staff_Count = orgDemographics.CybersecurityItIcsStaffCount;

            _context.CIS_CSI_ORGANIZATION_DEMOGRAPHICS.Update(dbOrgDemographics);
            _context.SaveChanges();
            orgDemographics.AssessmentId = dbOrgDemographics.Assessment_Id;

            _assessmentUtil.TouchAssessment(dbOrgDemographics.Assessment_Id);

            return orgDemographics.AssessmentId;
        }

        /// <summary>
        /// Persists data to the CIS_CSI_SERVICE_DEMOGRAPHICS table.
        /// </summary
        public int SaveServiceDemographics(CisServiceDemographics serviceDemographics, int userid)
        {
            var dbServiceDemographics = _context.CIS_CSI_SERVICE_DEMOGRAPHICS.Where(x => x.Assessment_Id == serviceDemographics.AssessmentId).FirstOrDefault();

            // Creating new Service Demographics record for this assessment
            if (dbServiceDemographics == null)
            {
                dbServiceDemographics = new CIS_CSI_SERVICE_DEMOGRAPHICS()
                {
                    Assessment_Id = serviceDemographics.AssessmentId
                };
                _context.CIS_CSI_SERVICE_DEMOGRAPHICS.Add(dbServiceDemographics);
                _context.SaveChanges();
            }

            dbServiceDemographics.Critical_Service_Description = serviceDemographics.CriticalServiceDescription;
            dbServiceDemographics.IT_ICS_Name = serviceDemographics.ItIcsName;
            dbServiceDemographics.Multi_Site = serviceDemographics.MultiSite;
            dbServiceDemographics.Multi_Site_Description = serviceDemographics.MultiSiteDescription;
            dbServiceDemographics.Budget_Basis = serviceDemographics.BudgetBasis;
            dbServiceDemographics.Authorized_Organizational_User_Count = serviceDemographics.AuthorizedOrganizationalUserCount;
            dbServiceDemographics.Authorized_Non_Organizational_User_Count = serviceDemographics.AuthorizedNonOrganizationalUserCount;
            dbServiceDemographics.Customers_Count = serviceDemographics.CustomersCount;
            dbServiceDemographics.IT_ICS_Staff_Count = serviceDemographics.ItIcsStaffCount;
            dbServiceDemographics.Cybersecurity_IT_ICS_Staff_Count = serviceDemographics.CybersecurityItIcsStaffCount;

            _context.CIS_CSI_SERVICE_DEMOGRAPHICS.Update(dbServiceDemographics);
            _context.SaveChanges();
            serviceDemographics.AssessmentId = dbServiceDemographics.Assessment_Id;
            AssessmentNaming.ProcessName(_context, userid, serviceDemographics.AssessmentId);
            _assessmentUtil.TouchAssessment(dbServiceDemographics.Assessment_Id);

            return serviceDemographics.AssessmentId;
        }

        /// <summary>
        /// Persists data to the CIS_CSI_SERVICE_COMPOSITION table.
        /// </summary
        public int SaveServiceComposition(CisServiceComposition serviceComposition)
        {
            var dbServiceComposition = _context.CIS_CSI_SERVICE_COMPOSITION.Where(x => x.Assessment_Id == serviceComposition.AssessmentId).FirstOrDefault();

            // Creating new Service Composition record for this assessment
            if (dbServiceComposition == null)
            {
                dbServiceComposition = new CIS_CSI_SERVICE_COMPOSITION()
                {
                    Assessment_Id = serviceComposition.AssessmentId
                };
                _context.CIS_CSI_SERVICE_COMPOSITION.Add(dbServiceComposition);
                _context.SaveChanges();
            }

            dbServiceComposition.Networks_Description = serviceComposition.NetworksDescription;
            dbServiceComposition.Services_Description = serviceComposition.ServicesDescription;
            dbServiceComposition.Applications_Description = serviceComposition.ApplicationsDescription;
            dbServiceComposition.Connections_Description = serviceComposition.ConnectionsDescription;
            dbServiceComposition.Personnel_Description = serviceComposition.PersonnelDescription;
            dbServiceComposition.Other_Defining_System_Description = serviceComposition.OtherDefiningSystemDescription;
            dbServiceComposition.Primary_Defining_System = serviceComposition.PrimaryDefiningSystem;

            var currentSecondaryDefiningSystems = _context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Where(x => x.Assessment_Id == serviceComposition.AssessmentId).ToList();

            // Removing un selected secondary defining systems 
            foreach (var item in currentSecondaryDefiningSystems)
            {
                if (!serviceComposition.SecondaryDefiningSystems.Contains(item.Defining_System_Id))
                {
                    _context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Remove(currentSecondaryDefiningSystems.Find(x => x.Defining_System_Id == item.Defining_System_Id));
                }
            }

            // Adding newly selected secondary defining systems
            foreach (var systemId in serviceComposition.SecondaryDefiningSystems)
            {
                if (!currentSecondaryDefiningSystems.Exists(x => x.Defining_System_Id == systemId))
                {
                    _context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Add(
                        new CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS
                        {
                            Assessment_Id = serviceComposition.AssessmentId,
                            Defining_System_Id = systemId
                        });
                }
            }

            _context.CIS_CSI_SERVICE_COMPOSITION.Update(dbServiceComposition);
            _context.SaveChanges();
            serviceComposition.AssessmentId = dbServiceComposition.Assessment_Id;

            _assessmentUtil.TouchAssessment(dbServiceComposition.Assessment_Id);

            return serviceComposition.AssessmentId;
        }

        public CisOrganizationDemographics GetOrgDemographics(int assessmentId)
        {
            CisOrganizationDemographics orgDemographics = new CisOrganizationDemographics
            {
                AssessmentId = assessmentId
            };
            var dbOrgDemographics = _context.CIS_CSI_ORGANIZATION_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (dbOrgDemographics != null)
            {
                orgDemographics.MotivationCrr = dbOrgDemographics.Motivation_CRR;
                orgDemographics.MotivationCrrDescription = dbOrgDemographics.Motivation_CRR_Description;
                orgDemographics.MotivationRrap = dbOrgDemographics.Motivation_RRAP;
                orgDemographics.MotivationRrapDescription = dbOrgDemographics.Motivation_RRAP_Description;
                orgDemographics.MotivationOrganizationRequest = dbOrgDemographics.Motivation_Organization_Request;
                orgDemographics.MotivationOrganizationRequestDescription = dbOrgDemographics.Motivation_Organization_Request_Description;
                orgDemographics.MotivationLawEnforcementRequest = dbOrgDemographics.Motivation_Law_Enforcement_Request;
                orgDemographics.MotivationLawEnforcementRequestDescription = dbOrgDemographics.Motivation_Law_Enforcement_Description;
                orgDemographics.MotivationDirectThreats = dbOrgDemographics.Motivation_Direct_Threats;
                orgDemographics.MotivationDirectThreatsDescription = dbOrgDemographics.Motivation_Direct_Threats_Description;
                orgDemographics.MotivationSpecialEvent = dbOrgDemographics.Motivation_Special_Event;
                orgDemographics.MotivationSpecialEventDescription = dbOrgDemographics.Motivation_Special_Event_Description;
                orgDemographics.MotivationOther = dbOrgDemographics.Motivation_Other;
                orgDemographics.MotivationOtherDescription = dbOrgDemographics.Motivation_Other_Description;
                orgDemographics.ParentOrganization = dbOrgDemographics.Parent_Organization;
                orgDemographics.OrganizationName = dbOrgDemographics.Organization_Name;
                orgDemographics.SiteName = dbOrgDemographics.Site_Name;
                orgDemographics.StreetAddress = dbOrgDemographics.Street_Address;
                orgDemographics.VisitDate = dbOrgDemographics.Visit_Date;
                orgDemographics.CompletedForSltt = dbOrgDemographics.Completed_For_SLTT;
                orgDemographics.CompletedForFederal = dbOrgDemographics.Completed_For_Federal;
                orgDemographics.CompletedForNationalSpecialEvent = dbOrgDemographics.Completed_For_National_Special_Event;
                orgDemographics.CikrSector = dbOrgDemographics.CIKR_Sector;
                orgDemographics.SubSector = dbOrgDemographics.Sub_Sector;
                orgDemographics.ItIcsStaffCount = dbOrgDemographics.IT_ICS_Staff_Count;
                orgDemographics.CybersecurityItIcsStaffCount = dbOrgDemographics.Cybersecurity_IT_ICS_Staff_Count;
            }

            return orgDemographics;
        }

        public CisServiceDemographics GetServiceDemographics(int assessmentId)
        {
            CisServiceDemographics serviceDemographics = new CisServiceDemographics
            {
                AssessmentId = assessmentId
            };
            var dbServiceDemographics = _context.CIS_CSI_SERVICE_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            if (dbServiceDemographics != null)
            {
                serviceDemographics.CriticalServiceDescription = dbServiceDemographics.Critical_Service_Description;
                serviceDemographics.ItIcsName = dbServiceDemographics.IT_ICS_Name;
                serviceDemographics.MultiSite = dbServiceDemographics.Multi_Site;
                serviceDemographics.MultiSiteDescription = dbServiceDemographics.Multi_Site_Description;
                serviceDemographics.BudgetBasis = dbServiceDemographics.Budget_Basis;
                serviceDemographics.AuthorizedOrganizationalUserCount = dbServiceDemographics.Authorized_Organizational_User_Count;
                serviceDemographics.AuthorizedNonOrganizationalUserCount = dbServiceDemographics.Authorized_Non_Organizational_User_Count;
                serviceDemographics.CustomersCount = dbServiceDemographics.Customers_Count;
                serviceDemographics.ItIcsStaffCount = dbServiceDemographics.IT_ICS_Staff_Count;
                serviceDemographics.CybersecurityItIcsStaffCount = dbServiceDemographics.Cybersecurity_IT_ICS_Staff_Count;
            }

            return serviceDemographics;
        }

        public CisServiceComposition GetServiceComposition(int assessmentId)
        {
            CisServiceComposition serviceComposition = new CisServiceComposition
            {
                AssessmentId = assessmentId,
                SecondaryDefiningSystems = new List<int>()
            };
            var dbServiceComposition = _context.CIS_CSI_SERVICE_COMPOSITION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            var dbSecondaryDefiningSystems = _context.CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS.Where(x => x.Assessment_Id == assessmentId).ToList();

            if (dbServiceComposition != null)
            {
                serviceComposition.NetworksDescription = dbServiceComposition.Networks_Description;
                serviceComposition.ServicesDescription = dbServiceComposition.Services_Description;
                serviceComposition.ApplicationsDescription = dbServiceComposition.Applications_Description;
                serviceComposition.ConnectionsDescription = dbServiceComposition.Connections_Description;
                serviceComposition.PersonnelDescription = dbServiceComposition.Personnel_Description;
                serviceComposition.OtherDefiningSystemDescription = dbServiceComposition.Other_Defining_System_Description;
                serviceComposition.PrimaryDefiningSystem = dbServiceComposition.Primary_Defining_System;

                if (dbSecondaryDefiningSystems != null)
                {
                    dbSecondaryDefiningSystems.ForEach(item => { serviceComposition.SecondaryDefiningSystems.Add(item.Defining_System_Id); });
                }
            }

            return serviceComposition;
        }
    }
}
