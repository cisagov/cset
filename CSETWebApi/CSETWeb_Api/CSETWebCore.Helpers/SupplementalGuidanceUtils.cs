//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using CSETWebCore.DataLayer.Model;
using System;
using System.Linq;
using System.Text.RegularExpressions;


namespace CSETWebCore.Helpers
{
    public class SupplementalGuidanceUtils
    {
        /// <summary>
        /// The "technology domain" of the assessment, e.g., "OT", "IT", or "OT+IT"
        /// </summary>
        string _techDomain;


        /// <summary>
        /// CTOR
        /// </summary>
        public SupplementalGuidanceUtils(int assessmentId, CSETContext _context)
        {
            _techDomain = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "TECH-DOMAIN").FirstOrDefault()?.StringValue ?? null;

            // if a techDomain is not specified, we want to keep the "both" (OT+IT) section
            if (String.IsNullOrEmpty(_techDomain))
            {
                _techDomain = "OT+IT";
            }
        }


        /// <summary>
        /// Removes non-applicable elements of Supplemental Guidance
        /// from a CPG 2.0 assessment, based on the assessment's 
        /// technology domain (OT, IT or OT+IT)
        /// 
        /// When defining the supplemental text, make sure to include the techdomain="x" attribute
        /// on the closing div tag as well.  This is not standard HTML but is needed to 
        /// find the closing tag in cases where the supplemental text is not HTML.
        /// 
        /// We are using regular expressions for parsing, not HTML parsing.
        /// </summary>
        /// <returns></returns>
        public string RemoveNonApplicableTechDomains(string supp)
        {
            return KeepSpecificTechDomainText(supp, _techDomain);
        }


        /// <summary>
        /// Removes any text delimited by <div techdomain="X">......</div techdomain="X">
        /// where "X" is not the value specified in the techDomain argument.
        /// </summary>
        /// <returns></returns>
        public static string KeepSpecificTechDomainText(string input, string techDomain)
        {
            if (string.IsNullOrEmpty(input) || string.IsNullOrEmpty(techDomain))
            {
                return input;
            }

            // Pattern to match divs with any 'techdomain' attribute
            string pattern = $@"<div techdomain=""(?<domain>.*?)"">(.*?)</div techdomain=""\k<domain>"">";

            string result = Regex.Replace(input, pattern, match =>
            {
                if (match.Groups["domain"].Value == techDomain)
                {
                    return match.Value;
                }
                else
                {
                    return string.Empty;
                }
            }, RegexOptions.Singleline);

            return result;
        }
    }
}
