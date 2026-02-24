////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.Model.Document;
using System.Collections.Generic;

namespace CSETWebCore.Model.Reports
{
    public class DocumentsReport
    {
        public DocumentsReport() { }

        public Business.Reports.BasicReportData.INFORMATION information { get; set; }
        public List<DocumentWithAnswerId> documents { get; set; }
    }
}
