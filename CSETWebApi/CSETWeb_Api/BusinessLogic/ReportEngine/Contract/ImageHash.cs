//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace CSET_Main.ReportEngine.Contract
{
    public class ImageHash
    {
        public Image NewImage { get; set; }
        public byte[] hashOfOldImage { get; set; }

        public string PathToOriginal { get; set; }


        public ReportImageStateEnum ImageReportState { get; set; }
    }
}


