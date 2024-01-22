using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Question
{
    /// <summary>
    /// Tracks translation overlays for Requirements.
    /// </summary>
    public class RequirementTranslations
    {
        public List<RequirementTranslation> Requirements { get; set; } = new List<RequirementTranslation>();
    }


    /// <summary>
    /// Translation info for a single Requirement
    /// </summary>
    public class RequirementTranslation
    {
        public int RequirementId { get; set; }
        public string RequirementText { get; set; }
        public string SupplementalInfo { get; set; }
    }


    /// <summary>
    /// Tracks translation overlays for Categories.
    /// </summary>
    public class CategoryTranslation
    {
        public List<KeyValuePair> Categories { get; set; } = new List<KeyValuePair> { };
    }


    /// <summary>
    /// Tracks translation overlays for generic pairs
    /// </summary>
    public class GenericTranslation
    {
        public string Comment { get; set; }
        public List<KeyValuePair> Pairs { get; set; } = new List<KeyValuePair> { };
    }


    /// <summary>
    /// Translation info for a single Category
    /// </summary>
    public class KeyValuePair
    {
        /// <summary>
        /// The English category name
        /// </summary>
        public string Key { get; set; }

        /// <summary>
        /// The translated category name
        /// </summary>
        public string Value { get; set; }
    }
}
