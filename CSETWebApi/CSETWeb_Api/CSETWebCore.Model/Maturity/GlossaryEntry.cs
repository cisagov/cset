//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Maturity
{
    public class GlossaryEntry
    {
        /// <summary>
        /// A glossary term.
        /// </summary>
        public string Term { get; set; }

        /// <summary>
        /// The definition for the term.  May contain HTML markup.
        /// </summary>
        public string Definition { get; set; }
    }
}