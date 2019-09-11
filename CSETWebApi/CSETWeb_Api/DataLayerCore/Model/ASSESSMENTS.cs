using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENTS
    {
        public ASSESSMENTS()
        {
            ANSWER = new HashSet<ANSWER>();
            ASSESSMENTS_REQUIRED_DOCUMENTATION = new HashSet<ASSESSMENTS_REQUIRED_DOCUMENTATION>();
            ASSESSMENT_CONTACTS = new HashSet<ASSESSMENT_CONTACTS>();
            ASSESSMENT_DIAGRAM_COMPONENTS = new HashSet<ASSESSMENT_DIAGRAM_COMPONENTS>();
            ASSESSMENT_IRP = new HashSet<ASSESSMENT_IRP>();
            ASSESSMENT_IRP_HEADER = new HashSet<ASSESSMENT_IRP_HEADER>();
            AVAILABLE_STANDARDS = new HashSet<AVAILABLE_STANDARDS>();
            CNSS_CIA_JUSTIFICATIONS = new HashSet<CNSS_CIA_JUSTIFICATIONS>();
            DOCUMENT_FILE = new HashSet<DOCUMENT_FILE>();
            FINANCIAL_ASSESSMENT_VALUES = new HashSet<FINANCIAL_ASSESSMENT_VALUES>();
            FINANCIAL_DOMAIN_FILTERS = new HashSet<FINANCIAL_DOMAIN_FILTERS>();
            FINANCIAL_HOURS = new HashSet<FINANCIAL_HOURS>();
            FRAMEWORK_TIER_TYPE_ANSWER = new HashSet<FRAMEWORK_TIER_TYPE_ANSWER>();
            GENERAL_SAL = new HashSet<GENERAL_SAL>();
            NETWORK_WARNINGS = new HashSet<NETWORK_WARNINGS>();
            PARAMETER_ASSESSMENT = new HashSet<PARAMETER_ASSESSMENT>();
            REPORT_DETAIL_SECTION_SELECTION = new HashSet<REPORT_DETAIL_SECTION_SELECTION>();
            REPORT_OPTIONS_SELECTION = new HashSet<REPORT_OPTIONS_SELECTION>();
            REPORT_STANDARDS_SELECTION = new HashSet<REPORT_STANDARDS_SELECTION>();
            SUB_CATEGORY_ANSWERS = new HashSet<SUB_CATEGORY_ANSWERS>();
        }

        public int Assessment_Id { get; set; }
        public DateTime AssessmentCreatedDate { get; set; }
        public int? AssessmentCreatorId { get; set; }
        public DateTime? LastAccessedDate { get; set; }
        [StringLength(50)]
        public string Alias { get; set; }
        public Guid Assessment_GUID { get; set; }
        public DateTime Assessment_Date { get; set; }
        [StringLength(100)]
        public string CreditUnionName { get; set; }
        [StringLength(100)]
        public string Charter { get; set; }
        [StringLength(100)]
        public string Assets { get; set; }
        public int? IRPTotalOverride { get; set; }
        [StringLength(150)]
        public string IRPTotalOverrideReason { get; set; }
        [Required]
        public bool? MatDetail_targetBandOnly { get; set; }
        public string Diagram_Markup { get; set; }
        public int LastUsedComponentNumber { get; set; }

        [ForeignKey("AssessmentCreatorId")]
        [InverseProperty("ASSESSMENTS")]
        public virtual USERS AssessmentCreator { get; set; }
        [InverseProperty("Assessment_")]
        public virtual DEMOGRAPHICS DEMOGRAPHICS { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual INFORMATION INFORMATION { get; set; }
        [InverseProperty("Assessment_")]
        public virtual STANDARD_SELECTION STANDARD_SELECTION { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ANSWER> ANSWER { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ASSESSMENTS_REQUIRED_DOCUMENTATION> ASSESSMENTS_REQUIRED_DOCUMENTATION { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ASSESSMENT_CONTACTS> ASSESSMENT_CONTACTS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<ASSESSMENT_IRP> ASSESSMENT_IRP { get; set; }
        [InverseProperty("ASSESSMENT_")]
        public virtual ICollection<ASSESSMENT_IRP_HEADER> ASSESSMENT_IRP_HEADER { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<AVAILABLE_STANDARDS> AVAILABLE_STANDARDS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<CNSS_CIA_JUSTIFICATIONS> CNSS_CIA_JUSTIFICATIONS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<DOCUMENT_FILE> DOCUMENT_FILE { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<FINANCIAL_ASSESSMENT_VALUES> FINANCIAL_ASSESSMENT_VALUES { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<FINANCIAL_DOMAIN_FILTERS> FINANCIAL_DOMAIN_FILTERS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<FINANCIAL_HOURS> FINANCIAL_HOURS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<FRAMEWORK_TIER_TYPE_ANSWER> FRAMEWORK_TIER_TYPE_ANSWER { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<GENERAL_SAL> GENERAL_SAL { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<NETWORK_WARNINGS> NETWORK_WARNINGS { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<PARAMETER_ASSESSMENT> PARAMETER_ASSESSMENT { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<REPORT_DETAIL_SECTION_SELECTION> REPORT_DETAIL_SECTION_SELECTION { get; set; }
        [InverseProperty("Assessment_")]
        public virtual ICollection<REPORT_OPTIONS_SELECTION> REPORT_OPTIONS_SELECTION { get; set; }
        [InverseProperty("Assesment_")]
        public virtual ICollection<REPORT_STANDARDS_SELECTION> REPORT_STANDARDS_SELECTION { get; set; }
        [InverseProperty("Assessement_")]
        public virtual ICollection<SUB_CATEGORY_ANSWERS> SUB_CATEGORY_ANSWERS { get; set; }
    }
}