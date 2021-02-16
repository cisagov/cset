//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using CSET_Main.Data;
using DataLayerCore.Model;

namespace CSET_Main.ReportEngine.Builder
{
    public class OverallSalObject
    {
     

        public string Availability_Level { get; set; }
        public string Confidence_Level { get; set; }
        public string Dod_Conf_Level { get; set; }
        public string Dod_Mac_Level { get; set; }
        public string Integrity_Level { get; set; }
        public string Selected_Sal_Level { get; set; }

        public OverallSalObject(ICollection<ASSESSMENT_SELECTED_LEVELS> collection, STANDARD_SELECTION sel)
        {
            PropertyInfo[] props = this.GetType().GetProperties();
            Dictionary<String,PropertyInfo> propsMap = new Dictionary<string,PropertyInfo>();
            foreach (var prop in props)
            {
                propsMap.Add(prop.Name, prop);
            }
            foreach (ASSESSMENT_SELECTED_LEVELS asl in collection)
            {
                propsMap[asl.Level_Name].SetValue(this, asl.Standard_Specific_Sal_Level,null);
            }
            Selected_Sal_Level = sel.Selected_Sal_Level;
        }

       
    }
}


