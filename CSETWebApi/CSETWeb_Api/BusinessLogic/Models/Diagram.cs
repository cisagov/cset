//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////

using System;
using System.Collections.Generic;

namespace CSETWeb_Api.Models
{
    public class DiagramRequest
    {
        public string DiagramXml;
        public int LastUsedComponentNumber;
        public string DiagramSvg;
    }

    public class DiagramResponse
    {
        public string AssessmentName;
        public string DiagramXml;
        public int LastUsedComponentNumber;
    }

    public class ComponentNameMap
    {
        public List<ComponentName> Abbreviations = new List<ComponentName>();
    }

    public class ComponentName
    {
        public string Abbreviation;
        public string ImageFileName;

        public ComponentName(string abbrev, string fileName)
        {
            this.Abbreviation = abbrev;
            this.ImageFileName = fileName;
        }
    }

    public class ComponentSymbolGroup
    {
        public int SymbolGroupID;
        public string GroupName;
        public string SymbolGroupTitle;
        public List<ComponentSymbol> Symbols;
    }

    public class ComponentSymbol
    {
        public string Name;
        public string DiagramTypeXml;
        public string FileName;
        public string Abbreviation;
        public string LongName;
        public string DisplayName;
        public string ComponentFamilyName;
        public string Tags;
        public int Width;
        public int Height;
    }

    public class DiagramTemplate
    {
        public string Name { get; set; }
        public string ImageSource { get; set; }
        public string Markup { get; set; }
    }
}
