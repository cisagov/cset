using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_SYMBOLS
    {
        public COMPONENT_SYMBOLS()
        {
            ASSESSMENT_DIAGRAM_COMPONENTS = new HashSet<ASSESSMENT_DIAGRAM_COMPONENTS>();
            COMPONENT_QUESTIONS = new HashSet<COMPONENT_QUESTIONS>();
            COMPONENT_STANDARD_QUESTIONS = new HashSet<COMPONENT_STANDARD_QUESTIONS>();
            COMPONENT_SYMBOLS_GM_TO_CSET = new HashSet<COMPONENT_SYMBOLS_GM_TO_CSET>();
        }

        public int Id { get; set; }
        [Required]
        [StringLength(50)]
        public string Name { get; set; }
        [Required]
        [StringLength(50)]
        public string Diagram_Type_Xml { get; set; }
        [Required]
        [StringLength(100)]
        public string File_Name { get; set; }
        [Required]
        [StringLength(150)]
        public string Component_Family_Name { get; set; }
        public int Symbol_Group_Id { get; set; }
        [StringLength(5)]
        public string Abbreviation { get; set; }
        public bool IsService { get; set; }
        [Required]
        [StringLength(100)]
        public string Long_Name { get; set; }
        [Required]
        [StringLength(100)]
        public string Display_Name { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        [StringLength(250)]
        public string Tags { get; set; }

        [ForeignKey("Component_Family_Name")]
        [InverseProperty("COMPONENT_SYMBOLS")]
        public virtual COMPONENT_FAMILY Component_Family_NameNavigation { get; set; }
        [ForeignKey("Diagram_Type_Xml")]
        [InverseProperty("COMPONENT_SYMBOLS")]
        public virtual DIAGRAM_TYPES_XML Diagram_Type_XmlNavigation { get; set; }
        [ForeignKey("Symbol_Group_Id")]
        [InverseProperty("COMPONENT_SYMBOLS")]
        public virtual SYMBOL_GROUPS Symbol_Group_ { get; set; }
        public virtual ICollection<ASSESSMENT_DIAGRAM_COMPONENTS> ASSESSMENT_DIAGRAM_COMPONENTS { get; set; }
        public virtual ICollection<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
        public virtual ICollection<COMPONENT_STANDARD_QUESTIONS> COMPONENT_STANDARD_QUESTIONS { get; set; }
        [InverseProperty("IdNavigation")]
        public virtual ICollection<COMPONENT_SYMBOLS_GM_TO_CSET> COMPONENT_SYMBOLS_GM_TO_CSET { get; set; }
    }
}