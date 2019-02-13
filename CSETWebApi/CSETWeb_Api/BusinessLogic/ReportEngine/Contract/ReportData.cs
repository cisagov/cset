//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using CSET_Main.Common;
using CSET_Main.Data.AssessmentData;

namespace CSET_Main.ReportEngine.Contract
{

    public class ReportData
    {

        /// <summary>
        /// local config know the paths to the reports and images
        /// I should be recieving images and datatables.
        /// However hashing should happen in the client
        /// 
        /// </summary>
        public string AssessmentName{get;set;}

        public string TempReportsDirectory { get; set; }

        public List<DataTable> StandardsQuestionsTables{get;set;}

        public List<StandardImage> StandardImages{get;set;}    

        public List<NetworkWarning> NetworkWarnings{get;set;}

        public List<DataTable> MailMerges{get;set;}

        public List<Tuple<DataSet,ArrayList>> NestedMailMerges{ get;set;}

        public List<ImageHash> ReplacementImages{get;set;}
       
        public ReportConfig Config{get;set;}
      
        public string ApplicationPath { get; set; }
     
        public bool DiagramHasItems { get; set; }

        public bool HasComponentData { get; set; }

         public bool HasStandards { get; set; }
         public bool IsGenSAL { get; set; }

        public HashSet<int> StandardColumnsToRemove { get; set; }
        public Dictionary<int, SectionMap> SectionDictionary {get;set;}
        public ICSETGlobalProperties GlobalProperties{ get;set;}
        public String ReportsFolder { get { return GlobalProperties.ReportsFolder; } }

        public ReportData()
        {
            StandardsQuestionsTables = new List<DataTable>();
            StandardImages = new List<StandardImage>();
            NetworkWarnings = new List<NetworkWarning>();
            MailMerges = new List<DataTable>();
            NestedMailMerges = new List<Tuple<DataSet, ArrayList>>();
            ReplacementImages = new List<ImageHash>();
        }


        public StandardModeEnum StandardMode { get; set; }

        public bool DODSelected { get; set; }
        public bool Nerc5Selected { get; set; }

    }
}


