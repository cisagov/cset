using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class COMPONENT_SYMBOLS
    {
        public COMPONENT_SYMBOLS()
        {
            ASSESSMENT_DIAGRAM_COMPONENTS = new HashSet<ASSESSMENT_DIAGRAM_COMPONENTS>();
            COMPONENT_NAMES_LEGACY = new HashSet<COMPONENT_NAMES_LEGACY>();
            COMPONENT_QUESTIONS = new HashSet<COMPONENT_QUESTIONS>();
        }

        [Key]
        public int Component_Symbol_Id { get; set; }
        [Required]
        [StringLength(100)]
        public string File_Name { get; set; }
        [Required]
        [StringLength(150)]
        public string Component_Family_Name { get; set; }
        public int Symbol_Group_Id { get; set; }
        [Required]
        [StringLength(5)]
        public string Abbreviation { get; set; }
        public bool IsService { get; set; }
        [Required]
        [StringLength(100)]
        public string Symbol_Name { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        [StringLength(250)]
        public string Search_Tags { get; set; }

        [ForeignKey("Component_Family_Name")]
        [InverseProperty("COMPONENT_SYMBOLS")]
        public virtual COMPONENT_FAMILY Component_Family_NameNavigation { get; set; }
        [ForeignKey("Symbol_Group_Id")]
        [InverseProperty("COMPONENT_SYMBOLS")]
        public virtual SYMBOL_GROUPS Symbol_Group_ { get; set; }
        [InverseProperty("Component_Symbol_")]
        public virtual ICollection<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
        [InverseProperty("Component_Symbol_")]
        public virtual ICollection<COMPONENT_NAMES_LEGACY> COMPONENT_NAMES_LEGACY { get; set; }
        [InverseProperty("Component_Symbol_")]
        public virtual ICollection<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
    }
}