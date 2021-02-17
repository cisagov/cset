//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.ImportAssessment;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace CSETWeb_Api.BusinessLogic.AssessmentIO.import
{
    interface IImportAssessmentRule
    {
        void ProcessRule(JToken jObj, XmlElement xTable, DBIO dBIO);
    }
}
