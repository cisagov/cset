using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class AnalyticsDemographic
    {

        public int SectorId { get; set; }
        public int IndustryId { get; set; }
        public string IndustryName { get; set; }
        public string SectorName { get; set; }
        public string Size { get; set; }
        public string AssetValue { get; set; }
    }
}
