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

    public class LanguageCategories
    {
        public List<LanguageCategory> Categories { get; set; } = new List<LanguageCategory> { };
    }

    public class LanguageCategory
    {
        /// <summary>
        /// The English category name
        /// </summary>
        public string CategoryEn { get; set; }

        /// <summary>
        /// The translated category name
        /// </summary>
        public string Category { get; set; }
    }
}
