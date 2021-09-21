using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Edm;
using CSETWebCore.Reports.Models.CRR;
using CSETWebCore.Business.Reports;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Reports.Models
{
    public class CrrResultsViewModel : PageModel
    {
        public CrrResultsViewModel(CrrResultsModel CrrResultsData = null)
        {
            crrResultsData = CrrResultsData;
        }
        public CrrResultsModel crrResultsData { get; set; }

        public string getName(CrrMaturityDomainModel data)
        {
            return data.domainName;
        }
    }

}