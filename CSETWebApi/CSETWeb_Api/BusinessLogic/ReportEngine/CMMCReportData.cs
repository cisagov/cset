//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class CMMCReportData : BasicReportData
    {
        public int CMMCLevel;
        public int AssesmentId;
        public CMMCReportData(int AssesmentId)
        {
            this.AssesmentId = AssesmentId;
            this.CMMCLevel = 1;

        }
    }

}


