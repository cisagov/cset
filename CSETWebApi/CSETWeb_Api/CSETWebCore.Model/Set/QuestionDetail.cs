using System.Collections.Generic;

namespace CSETWebCore.Model.Set
{
    public class QuestionDetail
    {
        public int QuestionID;
        public string QuestionText;
        public string QuestionGroupHeading;

        /// <summary>
        /// The primary key of the UNIVERSAL_SUBCATEGORY_HEADING.
        /// </summary>
        public int PairID;
        public string Subcategory;
        public string SubHeading;

        public int DisplayNumber;
        public string Title;
        public bool IsCustom;
        public List<string> SalLevels = new List<string>();
    }
}