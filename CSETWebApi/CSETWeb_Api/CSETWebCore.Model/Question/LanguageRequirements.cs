using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Question
{
    public class LanguageRequirements
    {
        public List<LanguageRequirement> Requirements { get; set; } = new List<LanguageRequirement>();
    }

    public class LanguageRequirement
    {
        public int RequirementId { get; set; }
        public string RequirementText { get; set; }
        public string SupplementalInfo { get; set; }
    }
}
