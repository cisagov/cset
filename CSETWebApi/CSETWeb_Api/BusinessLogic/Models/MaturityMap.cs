using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityMap
    {
        public int MaturityID;

        /// <summary>
        /// The maturity level as an abbreviation.
        /// </summary>
        public string Acronym;

        /// <summary>
        /// The maturity level, spelled out
        /// </summary>
        public string MaturityLevel;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="acronym"></param>
        /// <param name="level"></param>
        public MaturityMap(int id, string acronym, string level)
        {
            this.MaturityID = id;
            this.Acronym = acronym;
            this.MaturityLevel = level;
        }
    }
}
