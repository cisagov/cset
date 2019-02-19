using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class COMPONENT_SYMBOLS
    {
        public COMPONENT_SYMBOLS()
        {
            COMPONENT_QUESTIONS = new HashSet<COMPONENT_QUESTIONS>();
            COMPONENT_STANDARD_QUESTIONS = new HashSet<COMPONENT_STANDARD_QUESTIONS>();
            COMPONENT_SYMBOLS_GM_TO_CSET = new HashSet<COMPONENT_SYMBOLS_GM_TO_CSET>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Diagram_Type_Xml { get; set; }
        public string File_Name { get; set; }
        public string Component_Family_Name { get; set; }
        public int Symbol_Group_Id { get; set; }
        public string Abbreviation { get; set; }
        public bool IsService { get; set; }
        public string Long_Name { get; set; }
        public string Display_Name { get; set; }

        public virtual COMPONENT_FAMILY Component_Family_NameNavigation { get; set; }
        public virtual DIAGRAM_TYPES_XML Diagram_Type_XmlNavigation { get; set; }
        public virtual SYMBOL_GROUPS Symbol_Group_ { get; set; }
        public virtual ICollection<COMPONENT_QUESTIONS> COMPONENT_QUESTIONS { get; set; }
        public virtual ICollection<COMPONENT_STANDARD_QUESTIONS> COMPONENT_STANDARD_QUESTIONS { get; set; }
        public virtual ICollection<COMPONENT_SYMBOLS_GM_TO_CSET> COMPONENT_SYMBOLS_GM_TO_CSET { get; set; }
    }
}
