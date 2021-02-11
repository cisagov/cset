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
using System.Runtime.Serialization;

namespace CSET_Main.ReportEngine.Contract
{
   
    public class ReportConfig : IReportConfig
    {
       
        public bool PrintPdf { get; set; }
      
        public bool PrintDocx { get; set; }
      
        public bool PrintRTF { get; set; }
      
        public bool PrintDetail { get; set; }
       
        public bool PrintSiteSummary { get; set; }
      
        public bool PrintExecutive { get; set; }
      
        //public bool PrintDoc { get; set; }

        public bool PrintSecurityPlan { get; set; }
        public bool PrintComponentsGapAnalysis { get; set; }
        public bool PrintDiscoveriesTearoutSheets { get; set; }

        public bool PrintComparison { get; set; }
    
        public bool PrintTrend { get; set; }


        public int GetCount
        {
            get
            {
                int count = 0;
                if (PrintSiteSummary)
                    count += 35;
                if (PrintExecutive)
                    count += 28;
                if (PrintDetail)
                    count += 56;
                if (PrintSecurityPlan)
                    count += 35;

                return count;
            }
        }
       
        public List<string> OutputTypes
        {
            get{
                List<String> rval = new List<String>();
                if (PrintPdf)
                {
                    rval.Add("pdf");
                }
                if (PrintDocx)
                {
                    rval.Add("docx");
                }
                if (PrintRTF)
                {
                    rval.Add("rtf");
                }
                //if (PrintDoc)
                //{
                //    rval.Add("doc");
                //}                
                return rval;
            }
        }




       
    }
}


