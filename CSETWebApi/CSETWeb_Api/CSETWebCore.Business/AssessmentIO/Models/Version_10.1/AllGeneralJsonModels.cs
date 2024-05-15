//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CSETWebCore.Business.ImportAssessment.Models.Version_10_1
{
    public class jACCESS_KEY
    {
        [Required]
        public String AccessKey { get; set; }
    }





  

    public class jACCESS_KEY_ASSESSMENT
    {
        [Required]
        public String AccessKey { get; set; }
        [Required]
        public Int32 Assessment_Id { get; set; }
    }

    public class jCSET_VERSION
    {
        [Required]
        public Int32 Id { get; set; }
        [Required]
        [MaxLength(50)]
        public String Cset_Version1 { get; set; }
        [MaxLength(500)]
        public String Build_Number { get; set; }
    }
    public class jASSESSMENT_SELECTED_LEVELS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Level_Name { get; set; }

        [Required]
        [MaxLength(50)]
        public String Standard_Specific_Sal_Level { get; set; }

    }

    public class jAVAILABLE_STANDARDS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Set_Name { get; set; }

        [Required]
        public Boolean Selected { get; set; }

    }

    public class jCNSS_CIA_JUSTIFICATIONS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String CIA_Type { get; set; }

        [Required]
        [MaxLength(50)]
        public String DropDownValueLevel { get; set; }

        [Required]
        [MaxLength(1500)]
        public String Justification { get; set; }

    }



    public class jASSESSMENTS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        public DateTime AssessmentCreatedDate { get; set; }

        public Int32 AssessmentCreatorId { get; set; }

        public DateTime LastAccessedDate { get; set; }

        public DateTime AssessmentEffectiveDate { get; set; }

        [MaxLength(50)]
        public String Alias { get; set; }

        [Required]
        public Guid Assessment_GUID { get; set; }

        [StringLength(100)]
        public String CreditUnionName { get; set; }

        [StringLength(100)]
        public String Charter { get; set; }

        [StringLength(100)]
        public String Assets { get; set; }
        public int? IRPTotalOverride { get; set; }
        public String IRPTotalOverrideReason { get; set; }
        public bool? MatDetail_targetBandOnly { get; set; }

        public String Diagram_Markup { get; set; }

        public int LastUsedComponentNumber { get; set; }

        public String Diagram_Image { get; set; }
        public bool AnalyzeDiagram { get; set; }
        public bool UseDiagram { get; set; }
        public bool UseStandard { get; set; }
        public bool UseMaturity { get; set; }
        public Guid GalleryItemGuid { get; set; }
        public Boolean ISE_StateLed { get; set; }

        public bool Is_PCII { get; set; }

        [StringLength(50)]
        public String PCII_Number { get; set; }
    }

    public class jvQUESTION_HEADINGS
    {
        [Required]
        public Int32 Heading_Pair_Id { get; set; }

        [Required]
        [MaxLength(250)]
        public String Question_Group_Heading { get; set; }

        [Required]
        [MaxLength(100)]
        public String Universal_Sub_Category { get; set; }

    }


    public class jCUSTOM_QUESTIONAIRES
    {
        [Required]
        [MaxLength(50)]
        public String Custom_Questionaire_Name { get; set; }

        [MaxLength(800)]
        public String Description { get; set; }

        [Required]
        [MaxLength(50)]
        public String Set_Name { get; set; }

    }


    public class jCUSTOM_BASE_STANDARDS
    {
        [Required]
        [MaxLength(50)]
        public String Custom_Questionaire_Name { get; set; }

        [Required]
        [MaxLength(50)]
        public String Base_Standard { get; set; }

    }

    public class jSTANDARD_SELECTION
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Application_Mode { get; set; }

        [Required]
        [MaxLength(10)]
        public String Selected_Sal_Level { get; set; }

        [MaxLength(50)]
        public String Last_Sal_Determination_Type { get; set; }

        [MaxLength(50)]
        public String Sort_Set_Name { get; set; }

        [Required]
        public Boolean Is_Advanced { get; set; }

        [MaxLength(100)]
        public String Hidden_Screens { get; set; }

    }

    public class jCUSTOM_STANDARD_BASE_STANDARD
    {
        [Required]
        [MaxLength(50)]
        public String Custom_Questionaire_Name { get; set; }

        [Required]
        [MaxLength(50)]
        public String Base_Standard { get; set; }

        [Required]
        public Int32 Custom_Standard_Base_Standard_Id { get; set; }

    }


    public class jCUSTOM_QUESTIONAIRE_QUESTIONS
    {
        [Required]
        [MaxLength(50)]
        public String Custom_Questionaire_Name { get; set; }

        [Required]
        public Int32 Question_Id { get; set; }

    }

    public class jADDRESS
    {
        [Required]
        [MaxLength(150)]
        public String PrimaryEmail { get; set; }

        [Required]
        [MaxLength(50)]
        public String AddressType { get; set; }

        public Guid Id { get; set; }

        [MaxLength(150)]
        public String City { get; set; }

        [MaxLength(150)]
        public String Country { get; set; }

        [MaxLength(150)]
        public String Line1 { get; set; }

        [MaxLength(150)]
        public String Line2 { get; set; }

        [MaxLength(150)]
        public String State { get; set; }

        [MaxLength(150)]
        public String Zip { get; set; }

    }

    public class jDOCUMENT_FILE
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        public Int32 Document_Id { get; set; }

        [MaxLength(3990)]
        public String Path { get; set; }

        [MaxLength(3990)]
        public String Title { get; set; }

        [MaxLength(32)]
        public String FileMd5 { get; set; }

        [MaxLength(200)]
        public String ContentType { get; set; }

        public Nullable<DateTime> CreatedTimestamp { get; set; }

        public Nullable<DateTime> UpdatedTimestamp { get; set; }

        [MaxLength(500)]
        public String Name { get; set; }

        public byte[] Data { get; set; }

    }


    public class jFRAMEWORK_TIER_TYPE_ANSWER
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String TierType { get; set; }

        [Required]
        [MaxLength(50)]
        public String Tier { get; set; }

    }

    public class jSUB_CATEGORY_ANSWERS
    {
        [Required]
        public Int32 Assessement_Id { get; set; }


        public Int32 Heading_Pair_Id { get; set; }

        [Required]
        public Int32 Component_Id { get; set; }

        [Required]
        public Boolean Is_Component { get; set; }

        [Required]
        public Boolean Is_Override { get; set; }

        [Required]
        [MaxLength(50)]
        public String Answer_Text { get; set; }
        public String Question_Group_Heading { get; set; }
        public String Universal_Sub_Category { get; set; }
        public int Question_Group_Heading_Id { get; set; }
        public int Universal_Sub_Category_Id { get; set; }


    }

    public class jASSESSMENT_CONTACTS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(150)]
        public String PrimaryEmail { get; set; }

        [MaxLength(150)]
        public String FirstName { get; set; }

        [MaxLength(150)]
        public String LastName { get; set; }

        [Required]
        public Boolean Invited { get; set; }

        [Required]
        public Int32 AssessmentRoleId { get; set; }

        public Int32 UserId { get; set; }

        [Required]
        public Int32 Assessment_Contact_Id { get; set; }

    }

    public class jFINDING
    {
        [Required]
        public Int32 Answer_Id { get; set; }

        [Required]
        public Int32 Finding_Id { get; set; }

        public String Summary { get; set; }

        public String Issue { get; set; }

        public String Impact { get; set; }

        public String Recommendations { get; set; }

        public String Vulnerabilities { get; set; }

        public String Resolution_Date { get; set; }

        public Int32 Importance_Id { get; set; }

        public String Title { get; set; }

        public String Type { get; set; }

        public String Risk_Area { get; set; }

        public String Sub_Risk { get; set; }

        public String Description { get; set; }

        public String Citations { get; set; }

        public String ActionItems { get; set; }

        public String Auto_Generated { get; set; }

        public String Supp_Guidance { get; set; }

    }

    public class jISE_ACTIONS_FINDINGS
    {
        public Int32 Finding_Id { get; set; }
        public Int32 Mat_Question_Id { get; set; }
        public String Action_Items_Override { get; set; }

    }

    public class jHYDRO_DATA_ACTIONS
    {
        public Int32 Answer_Id { get; set; }
        public Int32 Progress_Id { get; set; }
        public String Comment { get; set; }

    }

    public class jANSWER
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        public Int32 Answer_Id { get; set; }

        [Required]
        public Boolean Is_Requirement { get; set; }

        [Required]
        public Int32 Question_Or_Requirement_Id { get; set; }

        [Required]
        public Guid Component_Guid { get; set; }

        public Boolean Mark_For_Review { get; set; }

        public Boolean Reviewed { get; set; }


        public String Comment { get; set; }


        public String Alternate_Justification { get; set; }

        public Int32 Question_Number { get; set; }

        [Required]
        [MaxLength(50)]
        public String Answer_Text { get; set; }

        public String Question_Type { get; set; }

        [Required]
        public Boolean Is_Component { get; set; }

        [MaxLength(50)]
        public String Custom_Question_Guid { get; set; }

        [Required]
        public Boolean Is_Framework { get; set; }

        public int Old_Answer_Id { get; internal set; }

        public String FeedBack { get; set; }

        public bool Is_Maturity { get; set; }

        public String Free_Response_Answer { get; set; }

        public Nullable<Int32> Mat_Option_Id { get; set; }
    }

    public class jAVAILABLE_MATURITY_MODELS
    {
        public int Assessment_Id { get; set; }
        public bool Selected { get; set; }
        public int model_id { get; set; }
    }

    public class jNIST_SAL_INFO_TYPES
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Type_Value { get; set; }

        [Required]
        public Boolean Selected { get; set; }

        [MaxLength(50)]
        public String Confidentiality_Value { get; set; }

        [MaxLength(1500)]
        public String Confidentiality_Special_Factor { get; set; }

        [MaxLength(50)]
        public String Integrity_Value { get; set; }

        [MaxLength(1500)]
        public String Integrity_Special_Factor { get; set; }

        [MaxLength(50)]
        public String Availability_Value { get; set; }

        [MaxLength(1500)]
        public String Availability_Special_Factor { get; set; }

        [MaxLength(50)]
        public String Area { get; set; }

        [MaxLength(50)]
        public String NIST_Number { get; set; }

    }


    public class jDOCUMENT_ANSWERS
    {
        [Required]
        public Int32 Document_Id { get; set; }

        [Required]
        public Int32 Answer_Id { get; set; }
        [Required]
        public Int32 Question_Or_Requirement_Id { get; set; }

        [Required]
        public Boolean Is_Requirement { get; set; }

        [Required]
        public Int32 Component_Id { get; set; }

    }


    public class jGENERAL_SAL
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Sal_Name { get; set; }

        [Required]
        public Int32 Slider_Value { get; set; }
        public int Sal_Weight_Id { get; set; }
    }

    public class jNIST_SAL_QUESTION_ANSWERS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        [Required]
        public Int32 Question_Id { get; set; }

        [Required]
        [MaxLength(50)]
        public String Question_Answer { get; set; }

    }



    public class jINFORMATION
    {
        [Required]
        public Int32 Id { get; set; }

        [Required]
        [MaxLength(100)]
        public String Assessment_Name { get; set; }

        [Required]
        public DateTime Assessment_Date { get; set; }

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

        [MaxLength(100)]
        public String Assessor_Phone { get; set; }

        [MaxLength(4000)]
        public String Assessment_Description { get; set; }

        [MaxLength(100)]
        public String Workflow { get; set; }

        [MaxLength(4000)]
        public String Additional_Notes_And_Comments { get; set; }


        public String Additional_Contacts { get; set; }


        public String Executive_Summary { get; set; }


        public String Enterprise_Evaluation_Summary { get; set; }

        [MaxLength(70)]
        public String Real_Property_Unique_Id { get; set; }

        public Int32 eMass_Document_Id { get; set; }

        public Nullable<Int32> Baseline_Assessment_Id { get; set; }

        public int? Region_Code { get; set; }

        public bool? IsAcetOnly { get; set; }

        public bool? Ise_Submitted { get; set; }

        public DateTime? Submitted_Date { get; set; }
    }


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

        [Required]
        public Boolean NeedsPrivacy { get; set; }

        [Required]
        public Boolean NeedsSupplyChain { get; set; }

        [Required]
        public Boolean NeedsICS { get; set; }

        public String OrganizationName { get; set; }

        public String Agency { get; set; }

        public Nullable<Int32> OrganizationType { get; set; }

        public Nullable<Int32> Facilitator { get; set; }

        public Nullable<Int32> PointOfContact { get; set; }

        public Nullable<Boolean> IsScoped { get; set; }

        [MaxLength(100)]
        public String CriticalService { get; set; }
    }

    public class jDETAILS_DEMOGRAPHICS
    {
        [Required]
        public Int32 Assessment_Id { get; set; }

        public String DataItemName { get; set; }

        public String StringValue { get; set; }

        public Nullable<Int32> IntValue { get; set; }

        public Nullable<Double> FloatValue { get; set; }

        public Nullable<Boolean> BoolValue { get; set; }

        public Nullable<DateTime> DateTimeValue { get; set; }

    }

    public class jPARAMETER_ASSESSMENT
    {
        [Required]
        public Int32 Assessment_ID { get; set; }

        [Required]
        public Int32 Parameter_ID { get; set; }
        [Required]
        public String Parameter_Value_Assessment { get; set; }
    }

    public class jPARAMETER_VALUES
    {
        [Required]
        public Int32 Answer_Id { get; set; }

        [Required]
        public Int32 Parameter_Id { get; set; }

        [Required]
        [MaxLength(2000)]
        public String Parameter_Value { get; set; }

        [Required]
        public Boolean Parameter_Is_Default { get; set; }

    }


    public class jFINDING_CONTACT
    {
        [Required]
        public Int32 Finding_Id { get; set; }

        [Required]
        public Int32 Assessment_Contact_Id { get; set; }

        public Int32 IgnoreThis { get; set; }

        public Guid Old_Contact_Id { get; set; }
    }

    public class jUSER_DETAIL_INFORMATION
    {
        public jUSER_DETAIL_INFORMATION()
        {
            jADDRESSes = new List<jADDRESS>();
        }
        public List<jADDRESS> jADDRESSes { get; set; }


        [Required]
        public Guid Id { get; set; }

        [MaxLength(150)]
        public String CellPhone { get; set; }


        [MaxLength(150)]
        public String FirstName { get; set; }


        [MaxLength(150)]
        public String LastName { get; set; }

        [MaxLength(150)]
        public String HomePhone { get; set; }

        [MaxLength(150)]
        public String OfficePhone { get; set; }

        [MaxLength(150)]
        public String ImagePath { get; set; }

        [MaxLength(150)]
        public String JobTitle { get; set; }

        [MaxLength(150)]
        public String Organization { get; set; }

        [Required]
        [MaxLength(150)]
        public String PrimaryEmail { get; set; }

        [MaxLength(150)]
        public String SecondaryEmail { get; set; }        

    }

    public class jFINANCIAL_HOURS
    {
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public String Component { get; set; }
        [StringLength(50)]
        public String ReviewType { get; set; }
        public decimal Hours { get; set; }
        [StringLength(512)]
        public String OtherSpecifyValue { get; set; }
    }

    public class jFINANCIAL_ASSESSMENT_VALUES
    {
        public int Assessment_Id { get; set; }

        [StringLength(250)]
        public String AttributeName { get; set; }

        [StringLength(50)]
        public String AttributeValue { get; set; }
    }

    public class jASSESSMENTS_REQUIRED_DOCUMENTATION
    {
        public int Assessment_Id { get; set; }

        public int Documentation_Id { get; set; }

        [Required]
        [StringLength(50)]
        public String Answer { get; set; }

        public String Comment { get; set; }
    }

    public class jASSESSMENT_IRP_HEADER
    {
        public int ASSESSMENT_ID { get; set; }

        public int IRP_HEADER_ID { get; set; }

        public int? RISK_LEVEL { get; set; }

        public int HEADER_RISK_LEVEL_ID { get; set; }

        public String COMMENT { get; set; }
    }

    public class jASSESSMENT_IRP
    {
        public int Answer_Id { get; set; }

        public int Assessment_Id { get; set; }

        public int IRP_Id { get; set; }

        public int? Response { get; set; }

        [StringLength(500)]
        public String Comment { get; set; }
    }

    public class jDIAGRAM_CONTAINER
    {
        public int Container_Id { get; set; }

        [StringLength(50)]
        public String ContainerType { get; set; }

        [StringLength(250)]
        public String Name { get; set; }

        public bool Visible { get; set; }

        [StringLength(50)]
        public String DrawIO_id { get; set; }

        public int Assessment_Id { get; set; }

        public String Universal_Sal_Level { get; set; }

        public int Parent_Id { get; set; }

        [StringLength(50)]
        public String Parent_Draw_IO_Id { get; set; }
    }

    public class jASSESSMENT_DIAGRAM_COMPONENTS
    {
        public int Assessment_id { get; set; }

        public Guid Component_Guid { get; set; }

        public int Component_Symbol_Id { get; set; }

        [StringLength(200)]
        public String label { get; set; }

        [StringLength(50)]
        public String DrawIO_id { get; set; }

        public Nullable<int> Zone_Id { get; set; }

        public Nullable<int> Layer_Id { get; set; }

        [StringLength(50)]
        public String Parent_DrawIO_Id { get; set; }
    }
    //start here new tables
    public class jANSWER_PROFILE
    {
        [Required]
        public int Profile_Id { get; set; }

        public String ProfileName { get; set; }

        public DateTime Profile_Date { get; set; }
    }
    public class jCIS_CSI_ORGANIZATION_DEMOGRAPHICS
    {
        [Required]
        public int Assessment_Id { get; set; }
        public bool Motivation_CRR { get; set; }

        public String Motivation_CRR_Description { get; set; }
        public bool Motivation_RRAP { get; set; }

        public String Motivation_RRAP_Description { get; set; }
        public bool Motivation_Organization_Request { get; set; }

        public String Motivation_Organization_Request_Description { get; set; }
        public bool Motivation_Law_Enforcement_Request { get; set; }

        public String Motivation_Law_Enforcement_Description { get; set; }
        public bool Motivation_Direct_Threats { get; set; }

        public String Motivation_Direct_Threats_Description { get; set; }
        public bool Motivation_Special_Event { get; set; }
        public String Motivation_Special_Event_Description { get; set; }
        public bool Motivation_Other { get; set; }
        public String Motivation_Other_Description { get; set; }
        public String Parent_Organization { get; set; }
        public String Organization_Name { get; set; }
        public String Site_Name { get; set; }
        public String Street_Address { get; set; }
        public DateTime? Visit_Date { get; set; }
        public bool Completed_For_SLTT { get; set; }
        public bool Completed_For_Federal { get; set; }
        public bool Completed_For_National_Special_Event { get; set; }
        public String CIKR_Sector { get; set; }
        public String Sub_Sector { get; set; }
        public String IT_ICS_Staff_Count { get; set; }
        public String Cybersecurity_IT_ICS_Staff_Count { get; set; }

    }
    public class jCIS_CSI_SERVICE_COMPOSITION
    {
        [Required]
        public int Assessment_Id { get; set; }
        [StringLength(400)]
        public String Networks_Description { get; set; }
        [StringLength(400)]
        public String Services_Description { get; set; }
        [StringLength(400)]
        public String Applications_Description { get; set; }
        [StringLength(400)]
        public String Connections_Description { get; set; }
        [StringLength(400)]
        public String Personnel_Description { get; set; }
        [StringLength(400)]
        public String Other_Defining_System_Description { get; set; }
        public int? Primary_Defining_System { get; set; }
    }
    public class jCIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS
    {
        [Required]
        public int Assessment_Id { get; set; }
        public int Defining_System_Id { get; set; }
        [StringLength(400)]
        public String Networks_Description { get; set; }
        [StringLength(400)]
        public String Services_Description { get; set; }
        [StringLength(400)]
        public String Applications_Description { get; set; }
        [StringLength(400)]
        public String Connections_Description { get; set; }
        [StringLength(400)]
        public String Personnel_Description { get; set; }
        [StringLength(400)]
        public String Other_Defining_System_Description { get; set; }
        public int? Primary_Defining_System { get; set; }
    }
    public class jCIS_CSI_SERVICE_DEMOGRAPHICS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [StringLength(50)]
        public String Critical_Service_Name { get; set; }
        [StringLength(150)]
        public String Critical_Service_Description { get; set; }
        [StringLength(50)]
        public String IT_ICS_Name { get; set; }
        public bool Multi_Site { get; set; }
        [StringLength(150)]
        public String Multi_Site_Description { get; set; }
        [StringLength(50)]
        public String Budget_Basis { get; set; }
        [StringLength(50)]
        public String Authorized_Organizational_User_Count { get; set; }
        [StringLength(50)]
        public String Authorized_Non_Organizational_User_Count { get; set; }
        [StringLength(50)]
        public String Customers_Count { get; set; }
        [StringLength(50)]
        public String IT_ICS_Staff_Count { get; set; }
        [StringLength(50)]
        public String Cybersecurity_IT_ICS_Staff_Count { get; set; }
    }
    public class jCIS_CSI_USER_COUNTS
    {
        [Required]
        public String User_Count { get; set; }
        public int Sequence { get; set; }
    }
    public class jCOUNTY_ANSWERS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [Required]
        public String County_FIPS { get; set; }

    }
    public class jCSAF_FILE
    {
        [Required]
        public String File_Name { get; set; }
        public byte[] Data { get; set; }
        public double? File_Size { get; set; }
        public DateTime? Upload_Date { get; set; }
    }
    public class jDEMOGRAPHIC_ANSWERS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [StringLength(100)]
        public String Employees { get; set; }
        [StringLength(100)]
        public String CustomersSupported { get; set; }
        [StringLength(100)]
        public String GeographicScope { get; set; }
        [StringLength(50)]
        public String CIOExists { get; set; }
        [StringLength(50)]
        public String CISOExists { get; set; }
        [StringLength(10)]
        public String CyberTrainingProgramExists { get; set; }
        public int? SectorId { get; set; }
        public int? SubSectorId { get; set; }
        [StringLength(10)]
        public String CyberRiskService { get; set; }
    }
    public class jMETRO_ANSWERS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [Required]
        public String Metro_FIPS { get; set; }
    }
    public class jNETWORK_WARNINGS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [Required]
        public int Id { get; set; }

        public String WarningText { get; set; }
    }
    public class jREGION_ANSWERS
    {
        [Required]
        public int Assessment_Id { get; set; }
        [Required]
        [StringLength(50)]
        public String State { get; set; }
        [Required]
        [StringLength(50)]
        public String RegionCode { get; set; }
    }
    public class jREPORT_DETAIL_SECTION_SELECTION
    {
        [Required]
        public int Report_Section_Id { get; set; }
        [StringLength(250)]
        public String Display_Name { get; set; }
        public int Display_Order { get; set; }
        public int Report_Order { get; set; }
        [StringLength(500)]
        public String Tool_Tip { get; set; }
    }
    public class jREPORT_OPTIONS_SELECTION
    {
        [Required]
        public int Assessment_Id { get; set; }
        [Required]
        public int Report_Option_Id { get; set; }
        public bool Is_Selected { get; set; }
    }
}



