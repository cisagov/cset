using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class FINANCIAL_DETAILS
    {
        public FINANCIAL_DETAILS()
        {
            FINANCIAL_FFIEC_MAPPINGS = new HashSet<FINANCIAL_FFIEC_MAPPINGS>();
            FINANCIAL_QUESTIONS = new HashSet<FINANCIAL_QUESTIONS>();
            FINANCIAL_REQUIREMENTS = new HashSet<FINANCIAL_REQUIREMENTS>();
            FINANCIAL_TIERS = new HashSet<FINANCIAL_TIERS>();
        }

        [StringLength(255)]
        public string Label { get; set; }
        public int StmtNumber { get; set; }
        public int FinancialGroupId { get; set; }
        [Column("Binary Criteria ID")]
        public double? Binary_Criteria_ID { get; set; }
        [Column("Maturity Target")]
        [StringLength(255)]
        public string Maturity_Target { get; set; }
        [Column("CSC Organizational (17-20)")]
        [StringLength(255)]
        public string CSC_Organizational__17_20_ { get; set; }
        [Column("CSC Foundational  (7-16)")]
        [StringLength(255)]
        public string CSC_Foundational___7_16_ { get; set; }
        [Column("CSC Basic (1-6)")]
        [StringLength(255)]
        public string CSC_Basic__1_6_ { get; set; }
        [Column("CSC Mapping")]
        [StringLength(255)]
        public string CSC_Mapping { get; set; }
        [Column("NCUA R&R 748 Mapping")]
        [StringLength(255)]
        public string NCUA_R_R_748_Mapping { get; set; }
        [Column("NCUA R&R 749 Mapping")]
        [StringLength(255)]
        public string NCUA_R_R_749_Mapping { get; set; }
        [Column("FFIEC Booklets Mapping")]
        [StringLength(255)]
        public string FFIEC_Booklets_Mapping { get; set; }

        [ForeignKey("FinancialGroupId")]
        [InverseProperty("FINANCIAL_DETAILS")]
        public virtual FINANCIAL_GROUPS FinancialGroup { get; set; }
        [InverseProperty("StmtNumberNavigation")]
        public virtual ICollection<FINANCIAL_FFIEC_MAPPINGS> FINANCIAL_FFIEC_MAPPINGS { get; set; }
        [InverseProperty("StmtNumberNavigation")]
        public virtual ICollection<FINANCIAL_QUESTIONS> FINANCIAL_QUESTIONS { get; set; }
        [InverseProperty("StmtNumberNavigation")]
        public virtual ICollection<FINANCIAL_REQUIREMENTS> FINANCIAL_REQUIREMENTS { get; set; }
        [InverseProperty("StmtNumberNavigation")]
        public virtual ICollection<FINANCIAL_TIERS> FINANCIAL_TIERS { get; set; }
    }
}