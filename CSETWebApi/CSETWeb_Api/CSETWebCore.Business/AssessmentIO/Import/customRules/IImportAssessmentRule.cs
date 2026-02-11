//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Newtonsoft.Json.Linq;
using System.Xml;
using CSETWebCore.Helpers;


namespace CSETWebCore.Business.AssessmentIO.Import
{
    interface IImportAssessmentRule
    {
        void ProcessRule(JToken jObj, XmlElement xTable, DBIO dBIO);
    }
}
