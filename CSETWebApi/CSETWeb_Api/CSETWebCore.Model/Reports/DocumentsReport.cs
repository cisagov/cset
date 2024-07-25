using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Document;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Reports
{
    public class DocumentsReport
    {
        public DocumentsReport() { }

        public Business.Reports.BasicReportData.INFORMATION information { get; set; }
        public List<DocumentWithAnswerId> documents { get; set; }
    }
}
