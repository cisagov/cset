//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class FrameworkQuestionItem
    {
        private string questionText;
        public string QuestionText
        {
            get { return questionText; }
            set { questionText = value; }
        }

        private string standard;
        public string Standard
        {
            get { return standard; }
            set { standard = value; }
        }

        private string reference;
        public string Reference
        {
            get { return reference; }
            set { reference = value; }
        }

        public int RequirementID { get; set; }

        public UNIVERSAL_SAL_LEVEL SALLevel { get; set; }

        public QUESTION_GROUP_HEADING QuestionGroupHeading { get; set; }

        public SETS SetName { get; set; }

        public NEW_QUESTION Question { get; set; }

        public Dictionary<string, SETS> GetSetAsDictionary()
        {
            return new Dictionary<string, SETS> { { SetName.Set_Name, SetName } };
        }

        public string CategoryAndQuestionNumber { get; set; }
    }
}