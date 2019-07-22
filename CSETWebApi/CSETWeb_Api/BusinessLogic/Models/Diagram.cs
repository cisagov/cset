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
}
