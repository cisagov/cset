using System;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Business.Demographic.DemographicIO.Models
{
	
    public class jDEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        public Int32 SectorId { get; set; }

        public Int32 IndustryId { get; set; }

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

        public Int32 OrganizationType { get; set; }

        public Int32 Facilitator { get; set; }

        public Int32 PointOfContact { get; set; }

        public Boolean IsScoped { get; set; }

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

        public Int32 IntValue { get; set; }

        public Double FloatValue { get; set; }

        public Boolean BoolValue { get; set; }

        public DateTime DateTimeValue { get; set; }

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

    public class jCIS_CSI_ORGANIZATION_DEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        public Boolean Motivation_CRR { get; set; }

        [MaxLength(150)]
        public String Motivation_CRR_Description { get; set; }

        public Boolean Motivation_RRAP { get; set; }

        [MaxLength(150)]
        public String Motivation_RRAP_Description { get; set; }

        public Boolean Motivation_Organization_Request { get; set; }

        [MaxLength(150)]
        public String Motivation_Organization_Request_Description { get; set; }

        public Boolean Motivation_Law_Enforcement_Request { get; set; }

        [MaxLength(150)]
        public String Motivation_Law_Enforcement_Description { get; set; }

        public Boolean Motivation_Direct_Threats { get; set; }

        [MaxLength(150)]
        public String Motivation_Direct_Threats_Description { get; set; }

        public Boolean Motivation_Special_Event { get; set; }

        [MaxLength(150)]
        public String Motivation_Special_Event_Description { get; set; }

        public Boolean Motivation_Other { get; set; }

        [MaxLength(150)]
        public String Motivation_Other_Description { get; set; }

        [MaxLength(50)]
        public String Parent_Organization { get; set; }

        [MaxLength(50)]
        public String Organization_Name { get; set; }

        [MaxLength(50)]
        public String Site_Name { get; set; }

        [MaxLength(75)]
        public String Street_Address { get; set; }

        public DateOnly Visit_Date { get; set; }

        public Boolean Completed_For_SLTT { get; set; }

        public Boolean Completed_For_Federal { get; set; }

        public Boolean Completed_For_National_Special_Event { get; set; }

        [MaxLength(50)]
        public String CIKR_Sector { get; set; }

        [MaxLength(50)]
        public String Sub_Sector { get; set; }

        [MaxLength(50)]
        public String IT_ICS_Staff_Count { get; set; }

        [MaxLength(50)]
        public String Cybersecurity_IT_ICS_Staff_Count { get; set; }

    }
}

