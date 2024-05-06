using System;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Business.Demographic.DemographicIO.Models
{

    public class jDEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        public Int32? SectorId { get; set; }

        public Int32? IndustryId { get; set; }

        [MaxLength(50)]
        public String Size { get; set; }

        [MaxLength(50)]
        public String AssetValue { get; set; }

        public Boolean NeedsPrivacy { get; set; }

        public Boolean NeedsSupplyChain { get; set; }

        public Boolean NeedsICS { get; set; }

        [MaxLength(150)]
        public String OrganizationName { get; set; }

        [MaxLength(150)]
        public String Agency { get; set; }

        public Int32? OrganizationType { get; set; }

        public Int32? Facilitator { get; set; }

        public Int32? PointOfContact { get; set; }

        public Boolean? IsScoped { get; set; }

        [MaxLength(100)]
        public String CriticalService { get; set; }

    }


    public class jDETAILS_DEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [MaxLength(100)]
        [Required]
        public String DataItemName { get; set; }

        [MaxLength(150)]
        public String StringValue { get; set; }

        public Int32? IntValue { get; set; }

        public Double? FloatValue { get; set; }

        public Boolean? BoolValue { get; set; }

        public DateTime? DateTimeValue { get; set; }

    }

    public class jCIS_CSI_SERVICE_DEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [MaxLength(50)]
        public String Critical_Service_Name { get; set; }

        [MaxLength(150)]
        public String Critical_Service_Description { get; set; }

        [MaxLength(50)]
        public String IT_ICS_Name { get; set; }

        public Boolean Multi_Site { get; set; }

        [MaxLength(150)]
        public String Multi_Site_Description { get; set; }

        [MaxLength(50)]
        public String Budget_Basis { get; set; }

        [MaxLength(50)]
        public String Authorized_Organizational_User_Count { get; set; }

        [MaxLength(50)]
        public String Authorized_Non_Organizational_User_Count { get; set; }

        [MaxLength(50)]
        public String Customers_Count { get; set; }

        [MaxLength(50)]
        public String IT_ICS_Staff_Count { get; set; }

        [MaxLength(50)]
        public String Cybersecurity_IT_ICS_Staff_Count { get; set; }

    }

    public class jCIS_CSI_SERVICE_COMPOSITION
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [MaxLength(400)]
        public String Networks_Description { get; set; }

        [MaxLength(400)]
        public String Services_Description { get; set; }

        [MaxLength(400)]
        public String Applications_Description { get; set; }

        [MaxLength(400)]
        public String Connections_Description { get; set; }

        [MaxLength(400)]
        public String Personnel_Description { get; set; }

        [MaxLength(400)]
        public String Other_Defining_System_Description { get; set; }

        public Int32 Primary_Defining_System { get; set; }

    }

    public class jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        public Int32 Defining_System_Id { get; set; }
    }

    public class jINFORMATION
    {
        [Required]
        public Int32 Id { get; set; }

        [MaxLength(100)]
        public String Assessment_Name { get; set; }

        [MaxLength(100)]
        public String Facility_Name { get; set; }

        [MaxLength(100)]
        public String City_Or_Site_Name { get; set; }

        [MaxLength(100)]
        public String State_Province_Or_Region { get; set; }

        [MaxLength(100)]
        public String Assessor_Name { get; set; }

        [MaxLength(100)]
        public String Assessor_Email { get; set; }

        [MaxLength(150)]
        public String Assessor_Phone { get; set; }

        [MaxLength(4000)]
        public String Assessment_Description { get; set; }

        [MaxLength(4000)]
        public String Additional_Notes_And_Comments { get; set; }

        [MaxLength(50)]
        public String Additional_Contacts { get; set; }

        [MaxLength(50)]
        public String Executive_Summary { get; set; }

        [MaxLength(50)]
        public String Enterprise_Evaluation_Summary { get; set; }

        [MaxLength(70)]
        public String Real_Property_Unique_Id { get; set; }

        public Int32 eMass_Document_Id { get; set; }

        public Boolean IsAcetOnly { get; set; }

        [MaxLength(30)]
        public String Workflow { get; set; }

        public Int32 Baseline_Assessment_Id { get; set; }

        [MaxLength(20)]
        public String Origin { get; set; }

        [MaxLength(20)]
        public String Postal_Code { get; set; }

        public Int32 Region_Code { get; set; }

        public Boolean Ise_Submitted { get; set; }

        public DateTime? Submitted_Date { get; set; }

    }

    //Do not export demographics full information. Instead export chunks

    public class jORG_DETAILS
    {
        [MaxLength(100)]
        public String Facility_Name { get; set; }

        [MaxLength(100)]
        public String City_Or_Site_Name { get; set; }

        [MaxLength(100)]
        public String State_Province_Or_Region { get; set; }
    }
}

