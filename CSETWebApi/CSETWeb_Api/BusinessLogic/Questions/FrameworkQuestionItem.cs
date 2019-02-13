//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;

namespace CSET_Main.Questions.QuestionList
{
    public class FrameworkQuestionItem
    {
        private String questionText;
        public String QuestionText
        {
            get { return questionText; }
            set { questionText = value;  }
        }

        private String standard;
        public String Standard
        {
            get { return standard; }
            set { standard = value;  }
        }

        private String reference;
        public String Reference
        {
            get { return reference; }
            set { reference = value;  }
        }       

        public int RequirementID { get; set; }

        public UNIVERSAL_SAL_LEVEL SALLevel { get; set; }

        public QUESTION_GROUP_HEADING QuestionGroupHeading { get; set; }

        public SET SetName { get; set; }

        public NEW_QUESTION Question { get; set; }

        internal Dictionary<string, SET> GetSetAsDictionary()
        {
            return new Dictionary<string, SET> { { SetName.Set_Name, SetName } };
        }

        public string CategoryAndQuestionNumber { get; set; }

    }
}


