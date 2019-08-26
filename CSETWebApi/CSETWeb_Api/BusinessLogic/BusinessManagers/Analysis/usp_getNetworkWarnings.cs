using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis
{
    /// <summary>
    /// A single warning message or recommendation.
    /// </summary>
    public class usp_getNetworkWarnings
    {
        public int Id { get; set; }
        public string WarningText { get; set; }
    }
}
