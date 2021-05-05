using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class NCSF_CATEGORY
    {
        public NCSF_CATEGORY()
        {
            NEW_REQUIREMENT = new HashSet<NEW_REQUIREMENT>();
        }

        [Required]
        [StringLength(2)]
        public string NCSF_Function_Id { get; set; }
        [Required]
        [StringLength(20)]
        public string NCSF_Category_Id { get; set; }
        [Required]
        [StringLength(50)]
        public string NCSF_Category_Name { get; set; }
        [Required]
        [StringLength(500)]
        public string NCSF_Category_Description { get; set; }
        public int NCSF_Cat_Id { get; set; }
        public int Question_Group_Heading_Id { get; set; }

        [ForeignKey("NCSF_Function_Id")]
        [InverseProperty("NCSF_CATEGORY")]
        public virtual NCSF_FUNCTIONS NCSF_Function_ { get; set; }
        [InverseProperty("NCSF_Cat_")]
        public virtual ICollection<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
    }
}