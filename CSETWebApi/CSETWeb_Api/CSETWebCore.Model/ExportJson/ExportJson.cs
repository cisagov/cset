//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using CSETWebCore.Model.Maturity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.ExportJson
{
    public class AssessmentJson
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public DateTime? CreatedDate { get; set; }
        public bool SelfAssessment { get; set; }
        public DateTime? AssessmentDate { get; set; }
        public Guid AssessmentGuid { get; set; }

        public OrganizationInfoJson OrganizationInfo { get; set; } = new OrganizationInfoJson();


       

        public SalJson Sal { get; set; }

        public List<ObservationJson> Observations { get; set; }
    }


    public class OrganizationInfoJson
    {
        public string OrganizationType { get; set; }
        public string OrganizationName { get; set; }
        public string BusinessUnit { get; set; }


        public string CityOrSiteName { get; set; }
        public string StateProvRegion {  get; set; }
        public string FacilityName { get; set; }


        public int SectorId { get; set; }
        public string SectorName { get; set; }
        public int? SubsectorId { get; set; }
        public string SubsectorName { get; set; }

        public string FacilitatorName { get; set; }


        public string NumberEmployeesInOrg { get; set; }
        public string NumberEmployeesInDept { get; set; }
        public string AnnualBudgetFunding { get; set; }

    }


    public class SalJson
    {
        /// <summary>
        /// Simple, GENERAL, NIST
        /// </summary>
        public string Methodology { get; set; }

        /// <summary>
        /// L, M, H, VH
        /// </summary>
        public string OverallLevel { get; set; }
    }


    ////// Maturity Model Content /////////////////////////////////////

    public class ModelsJson
    {
        public List<ModelJson> Models { get; set; }
    }


    public class ModelJson
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public string ModelTitle { get; set; }
        public List<MaturityLevel> Levels { get; set; } = [];

        public List<GroupingJson> Groupings { get; set; } = [];
    }


    public class GroupingJson
    {
        public int GroupingId { get; set; }
        public string Title { get; set; }
        public List<GroupingJson> Groupings { get; set; } = [];
        public List<MaturityQuestionJson> Questions { get; set; } = [];
    }


    public class MaturityQuestionJson
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; }
        public int MaturityLevel { get; set; }
        public AnswerJson Answer { get; set; }

        public List<ObservationJson> Observations { get; set; } = [];

        public List<MaturityQuestionJson> FollowupQuestions { get; set; } = [];
    }


    ////// Standards Content /////////////////////////////////////

    /// <summary>
    /// This is only included if the assessment contains standards
    /// </summary>
    public class StandardsJson
    {
        public List<StandardJson> Standards { get; set; }

        /// <summary>
        /// Requirements Mode or Questions Mode
        /// </summary>
        public string Mode { get; set; }

        /// <summary>
        /// This property is only applicable for assessments in Questions Mode.
        /// Groups questions by subcategory with the subCategoryHeadingText.
        /// </summary>
        public List<StandardQuestionSubCategoryJson> Questions { get; set; } = [];
    }


    public class StandardQuestionSubCategoryJson
    {
        public string SubCategory { get; set; }
        public List<StandardQuestionJson> Questions { get; set; } = [];
    }


    public class StandardJson
    {
        public string SetName { get; set; }
        public List<RequirementJson> Requirements { get; set; } = [];
    }


    public class RequirementJson
    {
        public int RequirementId { get; set; }
        public string RequirementText { get; set; }
        public string Title { get; set; }
    }


    public class StandardQuestionJson
    {
        public int QuestionId { get; set; }
        public string QuestionText { get; set; }
        public string Title { get; set; }

        public AnswerJson Answer { get; set; }

        public List<ObservationJson> Observations { get; set; } = [];
    }


    ////// Shared between Maturity and Standards ///////////////////////

    public class AnswerJson
    {
        public string AnswerText { get; set; }
        public string Comment { get; set; }
    }


    public class ObservationJson
    {
        public int ObservationId { get; set; }
        public int? AnswerId { get; set; }
        public string Importance { get; set; }
        public string Summary { get; set; }
        public string Title { get; set; }
        public string Issue { get; set; }
        public string Impacts { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public string AutoGeneratedBy { get; set; }
    }


    public class ContactJson
    {
        public string UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Role { get; set; }

        public bool Invited { get; set; }
        public bool IsPrimaryPoc { get; set; }
        public bool IsSiteParticipant { get; set; }
    }


    ////// CIS Demographics Content ///////////////////////

    /// <summary>
    /// Container for all CIS-specific demographics data
    /// </summary>
    public class CisDemographicsJson
    {
        public CisServiceDemographicsJson ServiceDemographics { get; set; }
        public CisOrganizationDemographicsJson OrganizationDemographics { get; set; }
        public CisServiceCompositionJson ServiceComposition { get; set; }
    }


    public class CisServiceDemographicsJson
    {
        public string CriticalServiceDescription { get; set; }
        public string ItIcsName { get; set; }
        public bool MultiSite { get; set; }
        public string MultiSiteDescription { get; set; }
        public string BudgetBasis { get; set; }
        public string AuthorizedOrganizationalUserCount { get; set; }
        public string AuthorizedNonOrganizationalUserCount { get; set; }
        public string CustomersCount { get; set; }
        public string ItIcsStaffCount { get; set; }
        public string CybersecurityItIcsStaffCount { get; set; }
    }


    public class CisOrganizationDemographicsJson
    {
        public bool MotivationCrr { get; set; }
        public string MotivationCrrDescription { get; set; }
        public bool MotivationRrap { get; set; }
        public string MotivationRrapDescription { get; set; }
        public bool MotivationOrganizationRequest { get; set; }
        public string MotivationOrganizationRequestDescription { get; set; }
        public bool MotivationLawEnforcementRequest { get; set; }
        public string MotivationLawEnforcementRequestDescription { get; set; }
        public bool MotivationDirectThreats { get; set; }
        public string MotivationDirectThreatsDescription { get; set; }
        public bool MotivationSpecialEvent { get; set; }
        public string MotivationSpecialEventDescription { get; set; }
        public bool MotivationOther { get; set; }
        public string MotivationOtherDescription { get; set; }
        public string ParentOrganization { get; set; }
        public string OrganizationName { get; set; }
        public string SiteName { get; set; }
        public string StreetAddress { get; set; }
        public DateTime? VisitDate { get; set; }
        public bool CompletedForSltt { get; set; }
        public bool CompletedForFederal { get; set; }
        public bool CompletedForNationalSpecialEvent { get; set; }
        public string CikrSector { get; set; }
        public string SubSector { get; set; }
        public string CustomersCount { get; set; }
        public string ItIcsStaffCount { get; set; }
        public string CybersecurityItIcsStaffCount { get; set; }
    }


    public class CisServiceCompositionJson
    {
        public string NetworksDescription { get; set; }
        public string ServicesDescription { get; set; }
        public string ApplicationsDescription { get; set; }
        public string ConnectionsDescription { get; set; }
        public string PersonnelDescription { get; set; }
        public string OtherDefiningSystemDescription { get; set; }
        public int? PrimaryDefiningSystem { get; set; }
        public List<int> SecondaryDefiningSystems { get; set; }
    }
}
